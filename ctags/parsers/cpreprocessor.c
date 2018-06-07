/*
*   Copyright (c) 1996-2002, Darren Hiebert
*
*   This source code is released for free distribution under the terms of the
*   GNU General Public License version 2 or (at your option) any later version.
*
*   This module contains the high level input read functions (preprocessor
*   directives are handled within this level).
*/

/*
*   INCLUDE FILES
*/
#include "general.h"  /* must always come first */

#include <string.h>

#include "debug.h"
#include "entry.h"
#include "htable.h"
#include "cpreprocessor.h"
#include "kind.h"
#include "options.h"
#include "read.h"
#include "vstring.h"
#include "parse.h"
#include "trashbox.h"
#include "xtag.h"

#include "cxx/cxx_debug.h"

/*
*   MACROS
*/
#define stringMatch(s1,s2)		(strcmp (s1,s2) == 0)
#define isspacetab(c)			((c) == SPACE || (c) == TAB)

/*
*   DATA DECLARATIONS
*/
typedef enum { COMMENT_NONE, COMMENT_C, COMMENT_CPLUS, COMMENT_D } Comment;

enum eCppLimits {
	MaxCppNestingLevel = 20,
	MaxDirectiveName = 10
};

/*  Defines the one nesting level of a preprocessor conditional.
 */
typedef struct sConditionalInfo {
	bool ignoreAllBranches;  /* ignoring parent conditional branch */
	bool singleBranch;       /* choose only one branch */
	bool branchChosen;       /* branch already selected */
	bool ignoring;           /* current ignore state */
	int enterExternalParserBlockNestLevel;          /* the parser state when entering this conditional: used only by cxx */
} conditionalInfo;

enum eState {
	DRCTV_NONE,    /* no known directive - ignore to end of line */
	DRCTV_DEFINE,  /* "#define" encountered */
	DRCTV_HASH,    /* initial '#' read; determine directive */
	DRCTV_IF,      /* "#if" or "#ifdef" encountered */
	DRCTV_PRAGMA,  /* #pragma encountered */
	DRCTV_UNDEF,   /* "#undef" encountered */
	DRCTV_INCLUDE, /* "#include" encountered */
};

/*  Defines the current state of the pre-processor.
 */
typedef struct sCppState {
	langType lang;
	langType clientLang;

	int * ungetBuffer;       /* memory buffer for unget characters */
	int ungetBufferSize;      /* the current unget buffer size */
	int * ungetPointer;      /* the current unget char: points in the middle of the buffer */
	int ungetDataSize;        /* the number of valid unget characters in the buffer */

	bool resolveRequired;     /* must resolve if/else/elif/endif branch */
	bool hasAtLiteralStrings; /* supports @"c:\" strings */
	bool hasCxxRawLiteralStrings; /* supports R"xxx(...)xxx" strings */
	bool hasSingleQuoteLiteralNumbers; /* supports vera number literals:
						 'h..., 'o..., 'd..., and 'b... */

	bool useClientLangDefineMacroKindIndex;
	int defineMacroKindIndex;
	int macroUndefRoleIndex;

	bool useClientLangHeaderKindIndex;
	int headerKindIndex;
	int headerSystemRoleIndex;
	int headerLocalRoleIndex;

	struct sDirective {
		enum eState state;       /* current directive being processed */
		bool	accept;          /* is a directive syntactically permitted? */
		vString * name;          /* macro name */
		unsigned int nestLevel;  /* level 0 is not used */
		conditionalInfo ifdef [MaxCppNestingLevel];
	} directive;
} cppState;


typedef enum {
	CPREPRO_MACRO_KIND_UNDEF_ROLE,
} cPreProMacroRole;

static roleDefinition CPREPROMacroRoles [] = {
	RoleTemplateUndef,
};


typedef enum {
	CPREPRO_HEADER_KIND_SYSTEM_ROLE,
	CPREPRO_HEADER_KIND_LOCAL_ROLE,
} cPreProHeaderRole;

static roleDefinition CPREPROHeaderRoles [] = {
	RoleTemplateSystem,
	RoleTemplateLocal,
};


typedef enum {
	CPREPRO_MACRO, CPREPRO_HEADER,
} cPreProkind;

static kindDefinition CPreProKinds [] = {
	{ true,  'd', "macro",      "macro definitions",
	  .referenceOnly = false, ATTACH_ROLES(CPREPROMacroRoles)},
	{ true, 'h', "header",     "included header files",
	  .referenceOnly = true, ATTACH_ROLES(CPREPROHeaderRoles)},
};

/*
*   DATA DEFINITIONS
*/

static bool doesExaminCodeWithInIf0Branch;

/*
* CXX parser state. This is stored at the beginning of a conditional.
* If at the exit of the conditional the state is changed then we assume
* that no further branches should be followed.
*/
static int externalParserBlockNestLevel;


/*  Use brace formatting to detect end of block.
 */
static bool BraceFormat = false;

void cppPushExternalParserBlock(void)
{
	externalParserBlockNestLevel++;
}

void cppPopExternalParserBlock(void)
{
	externalParserBlockNestLevel--;
}


static cppState Cpp = {
	.lang = LANG_IGNORE,
	.clientLang = LANG_IGNORE,
	.ungetBuffer = NULL,
	.ungetBufferSize = 0,
	.ungetPointer = NULL,
	.ungetDataSize = 0,
	.resolveRequired = false,
	.hasAtLiteralStrings = false,
	.hasCxxRawLiteralStrings = false,
	.hasSingleQuoteLiteralNumbers = false,
	.useClientLangDefineMacroKindIndex = false,
	.defineMacroKindIndex = CPREPRO_MACRO,
	.macroUndefRoleIndex = CPREPRO_MACRO_KIND_UNDEF_ROLE,
	.useClientLangHeaderKindIndex = false,
	.headerKindIndex = CPREPRO_HEADER,
	.headerSystemRoleIndex = CPREPRO_HEADER_KIND_SYSTEM_ROLE,
	.headerLocalRoleIndex = CPREPRO_HEADER_KIND_LOCAL_ROLE,
	.directive = {
		.state = DRCTV_NONE,
		.accept = false,
		.name = NULL,
		.nestLevel = 0,
		.ifdef = {
			{
				.ignoreAllBranches = false,
				.singleBranch = false,
				.branchChosen = false,
				.ignoring = false,
			}
		}
	}  /* directive */
};

/*
*   FUNCTION DEFINITIONS
*/

extern bool cppIsBraceFormat (void)
{
	return BraceFormat;
}

extern unsigned int cppGetDirectiveNestLevel (void)
{
	return Cpp.directive.nestLevel;
}

static void cppInitCommon(langType clientLang,
		     const bool state, const bool hasAtLiteralStrings,
		     const bool hasCxxRawLiteralStrings,
		     const bool hasSingleQuoteLiteralNumbers,
		     int defineMacroKindIndex,
		     int macroUndefRoleIndex,
		     int headerKindIndex,
		     int headerSystemRoleIndex, int headerLocalRoleIndex)
{
	BraceFormat = state;

	CXX_DEBUG_PRINT("cppInit: brace format is %d",BraceFormat);

	externalParserBlockNestLevel = 0;

	if (Cpp.lang == LANG_IGNORE)
	{
		langType t;

		t = getNamedLanguage ("CPreProcessor", 0);
		initializeParser (t);
	}

	Cpp.clientLang = clientLang;
	Cpp.ungetBuffer = NULL;
	Cpp.ungetPointer = NULL;

	Cpp.resolveRequired = false;
	Cpp.hasAtLiteralStrings = hasAtLiteralStrings;
	Cpp.hasCxxRawLiteralStrings = hasCxxRawLiteralStrings;
	Cpp.hasSingleQuoteLiteralNumbers = hasSingleQuoteLiteralNumbers;

	if (defineMacroKindIndex != KIND_GHOST_INDEX)
	{
		Cpp.defineMacroKindIndex = defineMacroKindIndex;
		Cpp.useClientLangDefineMacroKindIndex = true;

		Cpp.macroUndefRoleIndex = macroUndefRoleIndex;
	}
	else
	{
		Cpp.defineMacroKindIndex = CPREPRO_MACRO;
		Cpp.useClientLangDefineMacroKindIndex = false;

		Cpp.macroUndefRoleIndex = CPREPRO_MACRO_KIND_UNDEF_ROLE;
	}

	if (headerKindIndex != KIND_GHOST_INDEX)
	{
		Cpp.headerKindIndex = headerKindIndex;
		Cpp.useClientLangHeaderKindIndex = true;

		Cpp.headerSystemRoleIndex = headerSystemRoleIndex;
		Cpp.headerLocalRoleIndex =  headerLocalRoleIndex;
	}
	else
	{
		Cpp.headerKindIndex = CPREPRO_HEADER;
		Cpp.useClientLangHeaderKindIndex = false;

		Cpp.headerSystemRoleIndex = CPREPRO_HEADER_KIND_SYSTEM_ROLE;
		Cpp.headerLocalRoleIndex = CPREPRO_HEADER_KIND_LOCAL_ROLE;
	}

	Cpp.directive.state     = DRCTV_NONE;
	Cpp.directive.accept    = true;
	Cpp.directive.nestLevel = 0;

	Cpp.directive.ifdef [0].ignoreAllBranches = false;
	Cpp.directive.ifdef [0].singleBranch = false;
	Cpp.directive.ifdef [0].branchChosen = false;
	Cpp.directive.ifdef [0].ignoring     = false;

	Cpp.directive.name = vStringNewOrClear (Cpp.directive.name);
}

extern void cppInit (const bool state, const bool hasAtLiteralStrings,
		     const bool hasCxxRawLiteralStrings,
		     const bool hasSingleQuoteLiteralNumbers,
		     int defineMacroKindIndex,
		     int macroUndefRoleIndex,
			 int headerKindIndex,
		     int headerSystemRoleIndex, int headerLocalRoleIndex)
{
	langType client = getInputLanguage ();

	cppInitCommon (client, state, hasAtLiteralStrings,
				   hasCxxRawLiteralStrings, hasSingleQuoteLiteralNumbers,
				   defineMacroKindIndex, macroUndefRoleIndex, headerKindIndex,
				   headerSystemRoleIndex, headerLocalRoleIndex);
}

extern void cppTerminate (void)
{
	if (Cpp.directive.name != NULL)
	{
		vStringDelete (Cpp.directive.name);
		Cpp.directive.name = NULL;
	}

	if(Cpp.ungetBuffer)
	{
		eFree(Cpp.ungetBuffer);
		Cpp.ungetBuffer = NULL;
	}

	Cpp.clientLang = LANG_IGNORE;
}

extern void cppBeginStatement (void)
{
	Cpp.resolveRequired = true;
}

extern void cppEndStatement (void)
{
	Cpp.resolveRequired = false;
}

/*
*   Scanning functions
*
*   This section handles preprocessor directives.  It strips out all
*   directives and may emit a tag for #define directives.
*/

/*  This puts a character back into the input queue for the input File. */
extern void cppUngetc (const int c)
{
	if(!Cpp.ungetPointer)
	{
		// no unget data
		if(!Cpp.ungetBuffer)
		{
			Cpp.ungetBuffer = (int *)eMalloc(8 * sizeof(int));
			Cpp.ungetBufferSize = 8;
		}
		Assert(Cpp.ungetBufferSize > 0);
		Cpp.ungetPointer = Cpp.ungetBuffer + Cpp.ungetBufferSize - 1;
		*(Cpp.ungetPointer) = c;
		Cpp.ungetDataSize = 1;
		return;
	}

	// Already have some unget data in the buffer. Must prepend.
	Assert(Cpp.ungetBuffer);
	Assert(Cpp.ungetBufferSize > 0);
	Assert(Cpp.ungetDataSize > 0);
	Assert(Cpp.ungetPointer >= Cpp.ungetBuffer);

	if(Cpp.ungetPointer == Cpp.ungetBuffer)
	{
		Cpp.ungetBufferSize += 8;
		int * tmp = (int *)eMalloc(Cpp.ungetBufferSize * sizeof(int));
		memcpy(tmp+8,Cpp.ungetPointer,Cpp.ungetDataSize * sizeof(int));
		eFree(Cpp.ungetBuffer);
		Cpp.ungetBuffer = tmp;
		Cpp.ungetPointer = tmp + 7;
	} else {
		Cpp.ungetPointer--;
	}

	*(Cpp.ungetPointer) = c;
	Cpp.ungetDataSize++;
}


/*  This puts an entire string back into the input queue for the input File. */
void cppUngetString(const char * string,int len)
{
	if(!string)
		return;
	if(len < 1)
		return;

	if(!Cpp.ungetPointer)
	{
		// no unget data
		if(!Cpp.ungetBuffer)
		{
			Cpp.ungetBufferSize = 8 + len;
			Cpp.ungetBuffer = (int *)eMalloc(Cpp.ungetBufferSize * sizeof(int));
		} else if(Cpp.ungetBufferSize < len)
		{
			Cpp.ungetBufferSize = 8 + len;
			Cpp.ungetBuffer = (int *)eRealloc(Cpp.ungetBuffer,Cpp.ungetBufferSize * sizeof(int));
		}
		Cpp.ungetPointer = Cpp.ungetBuffer + Cpp.ungetBufferSize - len;
	} else {
		// Already have some unget data in the buffer. Must prepend.
		Assert(Cpp.ungetBuffer);
		Assert(Cpp.ungetBufferSize > 0);
		Assert(Cpp.ungetDataSize > 0);
		Assert(Cpp.ungetPointer >= Cpp.ungetBuffer);

		if(Cpp.ungetBufferSize < (Cpp.ungetDataSize + len))
		{
			Cpp.ungetBufferSize = 8 + len + Cpp.ungetDataSize;
			int * tmp = (int *)eMalloc(Cpp.ungetBufferSize * sizeof(int));
			memcpy(tmp + 8 + len,Cpp.ungetPointer,Cpp.ungetDataSize * sizeof(int));
			eFree(Cpp.ungetBuffer);
			Cpp.ungetBuffer = tmp;
			Cpp.ungetPointer = tmp + 8;
		} else {
			Cpp.ungetPointer -= len;
			Assert(Cpp.ungetPointer >= Cpp.ungetBuffer);
		}
	}

	int * p = Cpp.ungetPointer;
	const char * s = string;
	const char * e = string + len;

	while(s < e)
		*p++ = *s++;

	Cpp.ungetDataSize += len;
}

static int cppGetcFromUngetBufferOrFile(void)
{
	if(Cpp.ungetPointer)
	{
		Assert(Cpp.ungetBuffer);
		Assert(Cpp.ungetBufferSize > 0);
		Assert(Cpp.ungetDataSize > 0);

		int c = *(Cpp.ungetPointer);
		Cpp.ungetDataSize--;
		if(Cpp.ungetDataSize > 0)
			Cpp.ungetPointer++;
		else
			Cpp.ungetPointer = NULL;
		return c;
	}

	return getcFromInputFile();
}


/*  Reads a directive, whose first character is given by "c", into "name".
 */
static bool readDirective (int c, char *const name, unsigned int maxLength)
{
	unsigned int i;

	for (i = 0  ;  i < maxLength - 1  ;  ++i)
	{
		if (i > 0)
		{
			c = cppGetcFromUngetBufferOrFile ();
			if (c == EOF  ||  ! isalpha (c))
			{
				cppUngetc (c);
				break;
			}
		}
		name [i] = c;
	}
	name [i] = '\0';  /* null terminate */

	return (bool) isspacetab (c);
}

/*  Reads an identifier, whose first character is given by "c", into "tag",
 *  together with the file location and corresponding line number.
 */
static void readIdentifier (int c, vString *const name)
{
	vStringClear (name);
	do
	{
		vStringPut (name, c);
		c = cppGetcFromUngetBufferOrFile ();
	} while (c != EOF  && cppIsident (c));
	cppUngetc (c);
}

static void readFilename (int c, vString *const name)
{
	int c_end = (c == '<')? '>': '"';

	vStringClear (name);

	while (c = cppGetcFromUngetBufferOrFile (), (c != EOF && c != c_end && c != '\n'))
		vStringPut (name, c);
}

static conditionalInfo *currentConditional (void)
{
	return &Cpp.directive.ifdef [Cpp.directive.nestLevel];
}

static bool isIgnore (void)
{
	return Cpp.directive.ifdef [Cpp.directive.nestLevel].ignoring;
}

static bool setIgnore (const bool ignore)
{
	return Cpp.directive.ifdef [Cpp.directive.nestLevel].ignoring = ignore;
}

static bool isIgnoreBranch (void)
{
	conditionalInfo *const ifdef = currentConditional ();

	/*  Force a single branch if an incomplete statement is discovered
	 *  en route. This may have allowed earlier branches containing complete
	 *  statements to be followed, but we must follow no further branches.
	 */

	/*
	* CXX: Force a single branch if the external parser (cxx) block nest level at the beginning
	* of this conditional is not equal to the current block nest level (at exit of the first branch).
	*
	* Follow both branches example: (same state at enter and exit)
	*
	* #if something
	*     xxxxx;
	* #else
	*     yyyy;
	* #endif
	*
	* Follow single branch example: (different block level at enter and exit)
	*
	*    if {
	* #if something
    *    } else x;
	* #else
	*    }
	* #endif
	*/

	if (
			(Cpp.resolveRequired || (ifdef->enterExternalParserBlockNestLevel != externalParserBlockNestLevel)) &&
			(!BraceFormat)
		)
	{
		CXX_DEBUG_PRINT("Choosing single branch");
		ifdef->singleBranch = true;
	}

	/*  We will ignore this branch in the following cases:
	 *
	 *  1.  We are ignoring all branches (conditional was within an ignored
	 *        branch of the parent conditional)
	 *  2.  A branch has already been chosen and either of:
	 *      a.  A statement was incomplete upon entering the conditional
	 *      b.  A statement is incomplete upon encountering a branch
	 */
	return (bool) (ifdef->ignoreAllBranches ||
					 (ifdef->branchChosen  &&  ifdef->singleBranch));
}

static void chooseBranch (void)
{
	if (! BraceFormat)
	{
		conditionalInfo *const ifdef = currentConditional ();

		ifdef->branchChosen = (bool) (ifdef->singleBranch ||
										Cpp.resolveRequired);
	}
}

/*  Pushes one nesting level for an #if directive, indicating whether or not
 *  the branch should be ignored and whether a branch has already been chosen.
 */
static bool pushConditional (const bool firstBranchChosen)
{
	const bool ignoreAllBranches = isIgnore ();  /* current ignore */
	bool ignoreBranch = false;

	if (Cpp.directive.nestLevel < (unsigned int) MaxCppNestingLevel - 1)
	{
		conditionalInfo *ifdef;

		++Cpp.directive.nestLevel;
		ifdef = currentConditional ();

		/*  We take a snapshot of whether there is an incomplete statement in
		 *  progress upon encountering the preprocessor conditional. If so,
		 *  then we will flag that only a single branch of the conditional
		 *  should be followed.
		 */
		ifdef->ignoreAllBranches = ignoreAllBranches;
		ifdef->singleBranch      = Cpp.resolveRequired;
		ifdef->branchChosen      = firstBranchChosen;
		ifdef->ignoring = (bool) (ignoreAllBranches || (
				! firstBranchChosen  &&  ! BraceFormat  &&
				(ifdef->singleBranch || !doesExaminCodeWithInIf0Branch)));
		ifdef->enterExternalParserBlockNestLevel = externalParserBlockNestLevel;
		ignoreBranch = ifdef->ignoring;
	}
	return ignoreBranch;
}

/*  Pops one nesting level for an #endif directive.
 */
static bool popConditional (void)
{
	if (Cpp.directive.nestLevel > 0)
		--Cpp.directive.nestLevel;

	return isIgnore ();
}

static bool doesCPreProRunAsStandaloneParser (int kind)
{
	if (kind == CPREPRO_HEADER)
		return !Cpp.useClientLangDefineMacroKindIndex;
	else if (kind == CPREPRO_MACRO)
		return !Cpp.useClientLangHeaderKindIndex;
	else
	{
		AssertNotReached();
		return true;
	}
}

static int makeDefineTag (const char *const name, const char* const signature, bool undef)
{
	bool standing_alone = doesCPreProRunAsStandaloneParser(CPREPRO_MACRO);
	langType lang = standing_alone ? Cpp.lang: Cpp.clientLang;
	const bool isFileScope = (bool) (! isInputHeaderFile ());

	if (!isLanguageEnabled (lang))
			return CORK_NIL;

	Assert (Cpp.defineMacroKindIndex != KIND_GHOST_INDEX);

	if (isFileScope && !isXtagEnabled(XTAG_FILE_SCOPE))
		return CORK_NIL;

	if (undef && (Cpp.macroUndefRoleIndex == ROLE_INDEX_DEFINITION))
		return CORK_NIL;

	if (! isLanguageKindEnabled (lang,
								 Cpp.defineMacroKindIndex))
		return CORK_NIL;

	if (
		/* condition for definition tag */
		(!undef)
		|| /* condition for reference tag */
		(undef && isXtagEnabled(XTAG_REFERENCE_TAGS) &&
		 isLanguageRoleEnabled(lang, Cpp.defineMacroKindIndex,
							   Cpp.macroUndefRoleIndex)))
	{
		tagEntryInfo e;
		int r;

		if (standing_alone)
			pushLanguage (Cpp.lang);

		if (undef)
			initRefTagEntry (&e, name, Cpp.defineMacroKindIndex,
							 Cpp.macroUndefRoleIndex);
		else
			initTagEntry (&e, name, Cpp.defineMacroKindIndex);
		e.isFileScope  = isFileScope;
		if (isFileScope)
			markTagExtraBit (&e, XTAG_FILE_SCOPE);
		e.truncateLineAfterTag = true;
		e.extensionFields.signature = signature;

		r = makeTagEntry (&e);

		if (standing_alone)
			popLanguage ();

		return r;
	}
	return CORK_NIL;
}

static void makeIncludeTag (const  char *const name, bool systemHeader)
{
	bool standing_alone = doesCPreProRunAsStandaloneParser(CPREPRO_HEADER);
	langType lang = standing_alone ? Cpp.lang: Cpp.clientLang;
	tagEntryInfo e;
	int role_index;

	if (!isLanguageEnabled (lang))
		return;

	Assert (Cpp.headerKindIndex != KIND_GHOST_INDEX);

	role_index = systemHeader? Cpp.headerSystemRoleIndex: Cpp.headerLocalRoleIndex;
	if (role_index == ROLE_INDEX_DEFINITION)
		return;

	if (!isXtagEnabled (XTAG_REFERENCE_TAGS))
		return;

	if (!isLanguageKindEnabled(lang, Cpp.headerKindIndex))
		return;

	if (isLanguageRoleEnabled(lang, Cpp.headerKindIndex, role_index))
	{
		if (doesCPreProRunAsStandaloneParser (CPREPRO_HEADER))
			pushLanguage (Cpp.lang);

		initRefTagEntry (&e, name, Cpp.headerKindIndex, role_index);
		e.isFileScope  = false;
		e.truncateLineAfterTag = true;
		makeTagEntry (&e);

		if (doesCPreProRunAsStandaloneParser (CPREPRO_HEADER))
			popLanguage ();
	}
}

static vString *signature;
static int directiveDefine (const int c, bool undef)
{
	// FIXME: We could possibly handle the macros here!
	//        However we'd need a separate hash table for macros of the current file
	//        to avoid breaking the "global" ones.

	int r = CORK_NIL;

	if (cppIsident1 (c))
	{
		readIdentifier (c, Cpp.directive.name);
		if (! isIgnore ())
		{
			int p;

			p = cppGetcFromUngetBufferOrFile ();
			if (p == '(')
			{
				signature = vStringNewOrClearWithAutoRelease (signature);
				do {
					if (!isspacetab(p))
						vStringPut (signature, p);
					/* TODO: Macro parameters can be captured here. */
					p = cppGetcFromUngetBufferOrFile ();
				} while (p != ')' && p != EOF);

				if (p == ')')
				{
					vStringPut (signature, p);
					r = makeDefineTag (vStringValue (Cpp.directive.name), vStringValue (signature), undef);
				}
				else
					r = makeDefineTag (vStringValue (Cpp.directive.name), NULL, undef);
			}
			else
			{
				cppUngetc (p);
				r = makeDefineTag (vStringValue (Cpp.directive.name), NULL, undef);
			}
		}
	}
	Cpp.directive.state = DRCTV_NONE;
	return r;
}

static void directiveUndef (const int c)
{
	if (isXtagEnabled (XTAG_REFERENCE_TAGS))
	{
		directiveDefine (c, true);
	}
	else
	{
		Cpp.directive.state = DRCTV_NONE;
	}
}

static void directivePragma (int c)
{
	if (cppIsident1 (c))
	{
		readIdentifier (c, Cpp.directive.name);
		if (stringMatch (vStringValue (Cpp.directive.name), "weak"))
		{
			/* generate macro tag for weak name */
			do
			{
				c = cppGetcFromUngetBufferOrFile ();
			} while (c == SPACE);
			if (cppIsident1 (c))
			{
				readIdentifier (c, Cpp.directive.name);
				makeDefineTag (vStringValue (Cpp.directive.name), NULL, false);
			}
		}
	}
	Cpp.directive.state = DRCTV_NONE;
}

static bool directiveIf (const int c)
{
	DebugStatement ( const bool ignore0 = isIgnore (); )
	const bool ignore = pushConditional ((bool) (c != '0'));

	Cpp.directive.state = DRCTV_NONE;
	DebugStatement ( debugCppNest (true, Cpp.directive.nestLevel);
	                 if (ignore != ignore0) debugCppIgnore (ignore); )

	return ignore;
}


static void directiveInclude (const int c)
{
	if (c == '<' || c == '"')
	{
		readFilename (c, Cpp.directive.name);
		if ((! isIgnore ()) && vStringLength (Cpp.directive.name))
			makeIncludeTag (vStringValue (Cpp.directive.name),
					c == '<');
	}
	Cpp.directive.state = DRCTV_NONE;
}

static bool directiveHash (const int c)
{
	bool ignore = false;
	char directive [MaxDirectiveName];
	DebugStatement ( const bool ignore0 = isIgnore (); )

	readDirective (c, directive, MaxDirectiveName);
	if (stringMatch (directive, "define"))
		Cpp.directive.state = DRCTV_DEFINE;
	else if (stringMatch (directive, "include"))
		Cpp.directive.state = DRCTV_INCLUDE;
	else if (stringMatch (directive, "undef"))
		Cpp.directive.state = DRCTV_UNDEF;
	else if (strncmp (directive, "if", (size_t) 2) == 0)
		Cpp.directive.state = DRCTV_IF;
	else if (stringMatch (directive, "elif")  ||
			stringMatch (directive, "else"))
	{
		ignore = setIgnore (isIgnoreBranch ());
		CXX_DEBUG_PRINT("Found #elif or #else: ignore is %d",ignore);
		if (! ignore  &&  stringMatch (directive, "else"))
			chooseBranch ();
		Cpp.directive.state = DRCTV_NONE;
		DebugStatement ( if (ignore != ignore0) debugCppIgnore (ignore); )
	}
	else if (stringMatch (directive, "endif"))
	{
		DebugStatement ( debugCppNest (false, Cpp.directive.nestLevel); )
		ignore = popConditional ();
		Cpp.directive.state = DRCTV_NONE;
		DebugStatement ( if (ignore != ignore0) debugCppIgnore (ignore); )
	}
	else if (stringMatch (directive, "pragma"))
		Cpp.directive.state = DRCTV_PRAGMA;
	else
		Cpp.directive.state = DRCTV_NONE;

	return ignore;
}

/*  Handles a pre-processor directive whose first character is given by "c".
 */
static bool handleDirective (const int c, int *macroCorkIndex)
{
	bool ignore = isIgnore ();

	switch (Cpp.directive.state)
	{
		case DRCTV_NONE:    ignore = isIgnore ();        break;
		case DRCTV_DEFINE:
			*macroCorkIndex = directiveDefine (c, false);
			break;
		case DRCTV_HASH:    ignore = directiveHash (c);  break;
		case DRCTV_IF:      ignore = directiveIf (c);    break;
		case DRCTV_PRAGMA:  directivePragma (c);         break;
		case DRCTV_UNDEF:   directiveUndef (c);         break;
		case DRCTV_INCLUDE: directiveInclude (c);         break;
	}
	return ignore;
}

/*  Called upon reading of a slash ('/') characters, determines whether a
 *  comment is encountered, and its type.
 */
static Comment isComment (void)
{
	Comment comment;
	const int next = cppGetcFromUngetBufferOrFile ();

	if (next == '*')
		comment = COMMENT_C;
	else if (next == '/')
		comment = COMMENT_CPLUS;
	else if (next == '+')
		comment = COMMENT_D;
	else
	{
		cppUngetc (next);
		comment = COMMENT_NONE;
	}
	return comment;
}

/*  Skips over a C style comment. According to ANSI specification a comment
 *  is treated as white space, so we perform this substitution.
 */
int cppSkipOverCComment (void)
{
	int c = cppGetcFromUngetBufferOrFile ();

	while (c != EOF)
	{
		if (c != '*')
			c = cppGetcFromUngetBufferOrFile ();
		else
		{
			const int next = cppGetcFromUngetBufferOrFile ();

			if (next != '/')
				c = next;
			else
			{
				c = SPACE;  /* replace comment with space */
				break;
			}
		}
	}
	return c;
}

/*  Skips over a C++ style comment.
 */
static int skipOverCplusComment (void)
{
	int c;

	while ((c = cppGetcFromUngetBufferOrFile ()) != EOF)
	{
		if (c == BACKSLASH)
			cppGetcFromUngetBufferOrFile ();  /* throw away next character, too */
		else if (c == NEWLINE)
			break;
	}
	return c;
}

/* Skips over a D style comment.
 * Really we should match nested /+ comments. At least they're less common.
 */
static int skipOverDComment (void)
{
	int c = cppGetcFromUngetBufferOrFile ();

	while (c != EOF)
	{
		if (c != '+')
			c = cppGetcFromUngetBufferOrFile ();
		else
		{
			const int next = cppGetcFromUngetBufferOrFile ();

			if (next != '/')
				c = next;
			else
			{
				c = SPACE;  /* replace comment with space */
				break;
			}
		}
	}
	return c;
}

/*  Skips to the end of a string, returning a special character to
 *  symbolically represent a generic string.
 */
static int skipToEndOfString (bool ignoreBackslash)
{
	int c;

	while ((c = cppGetcFromUngetBufferOrFile ()) != EOF)
	{
		if (c == BACKSLASH && ! ignoreBackslash)
			cppGetcFromUngetBufferOrFile ();  /* throw away next character, too */
		else if (c == DOUBLE_QUOTE)
			break;
	}
	return STRING_SYMBOL;  /* symbolic representation of string */
}

static int isCxxRawLiteralDelimiterChar (int c)
{
	return (c != ' ' && c != '\f' && c != '\n' && c != '\r' && c != '\t' && c != '\v' &&
	        c != '(' && c != ')' && c != '\\');
}

static int skipToEndOfCxxRawLiteralString (void)
{
	int c = cppGetcFromUngetBufferOrFile ();

	if (c != '(' && ! isCxxRawLiteralDelimiterChar (c))
	{
		cppUngetc (c);
		c = skipToEndOfString (false);
	}
	else
	{
		char delim[16];
		unsigned int delimLen = 0;
		bool collectDelim = true;

		do
		{
			if (collectDelim)
			{
				if (isCxxRawLiteralDelimiterChar (c) &&
				    delimLen < (sizeof delim / sizeof *delim))
					delim[delimLen++] = c;
				else
					collectDelim = false;
			}
			else if (c == ')')
			{
				unsigned int i = 0;

				while ((c = cppGetcFromUngetBufferOrFile ()) != EOF && i < delimLen && delim[i] == c)
					i++;
				if (i == delimLen && c == DOUBLE_QUOTE)
					break;
				else
					cppUngetc (c);
			}
		}
		while ((c = cppGetcFromUngetBufferOrFile ()) != EOF);
		c = STRING_SYMBOL;
	}
	return c;
}

/*  Skips to the end of the three (possibly four) 'c' sequence, returning a
 *  special character to symbolically represent a generic character.
 *  Also detects Vera numbers that include a base specifier (ie. 'b1010).
 */
static int skipToEndOfChar (void)
{
	int c;
	int count = 0, veraBase = '\0';

	while ((c = cppGetcFromUngetBufferOrFile ()) != EOF)
	{
	    ++count;
		if (c == BACKSLASH)
			cppGetcFromUngetBufferOrFile ();  /* throw away next character, too */
		else if (c == SINGLE_QUOTE)
			break;
		else if (c == NEWLINE)
		{
			cppUngetc (c);
			break;
		}
		else if (Cpp.hasSingleQuoteLiteralNumbers)
		{
			if (count == 1  &&  strchr ("DHOB", toupper (c)) != NULL)
				veraBase = c;
			else if (veraBase != '\0'  &&  ! isalnum (c))
			{
				cppUngetc (c);
				break;
			}
		}
	}
	return CHAR_SYMBOL;  /* symbolic representation of character */
}

static void attachEndFieldMaybe (int macroCorkIndex)
{
	if (macroCorkIndex != CORK_NIL)
	{
		tagEntryInfo *tag;

		tag = getEntryInCorkQueue (macroCorkIndex);
		tag->extensionFields.endLine = getInputLineNumber ();
	}
}


/*  This function returns the next character, stripping out comments,
 *  C pre-processor directives, and the contents of single and double
 *  quoted strings. In short, strip anything which places a burden upon
 *  the tokenizer.
 */
extern int cppGetc (void)
{
	bool directive = false;
	bool ignore = false;
	int c;
	int macroCorkIndex = CORK_NIL;


	do {
start_loop:
		c = cppGetcFromUngetBufferOrFile ();
process:
		switch (c)
		{
			case EOF:
				ignore    = false;
				directive = false;
				attachEndFieldMaybe (macroCorkIndex);
				macroCorkIndex = CORK_NIL;
				break;

			case TAB:
			case SPACE:
				break;  /* ignore most white space */

			case NEWLINE:
				if (directive  &&  ! ignore)
				{
					attachEndFieldMaybe (macroCorkIndex);
					macroCorkIndex = CORK_NIL;
					directive = false;
				}
				Cpp.directive.accept = true;
				break;

			case DOUBLE_QUOTE:
				if (Cpp.directive.state == DRCTV_INCLUDE)
					goto enter;
				else
				{
					Cpp.directive.accept = false;
					c = skipToEndOfString (false);
				}

				break;

			case '#':
				if (Cpp.directive.accept)
				{
					directive = true;
					Cpp.directive.state  = DRCTV_HASH;
					Cpp.directive.accept = false;
				}
				break;

			case SINGLE_QUOTE:
				Cpp.directive.accept = false;
				c = skipToEndOfChar ();
				break;

			case '/':
			{
				const Comment comment = isComment ();

				if (comment == COMMENT_C)
					c = cppSkipOverCComment ();
				else if (comment == COMMENT_CPLUS)
				{
					c = skipOverCplusComment ();
					if (c == NEWLINE)
						cppUngetc (c);
				}
				else if (comment == COMMENT_D)
					c = skipOverDComment ();
				else
					Cpp.directive.accept = false;
				break;
			}

			case BACKSLASH:
			{
				int next = cppGetcFromUngetBufferOrFile ();

				if (next == NEWLINE)
					goto start_loop;
				else
					cppUngetc (next);
				break;
			}

			case '?':
			{
				int next = cppGetcFromUngetBufferOrFile ();
				if (next != '?')
					cppUngetc (next);
				else
				{
					next = cppGetcFromUngetBufferOrFile ();
					switch (next)
					{
						case '(':          c = '[';       break;
						case ')':          c = ']';       break;
						case '<':          c = '{';       break;
						case '>':          c = '}';       break;
						case '/':          c = BACKSLASH; goto process;
						case '!':          c = '|';       break;
						case SINGLE_QUOTE: c = '^';       break;
						case '-':          c = '~';       break;
						case '=':          c = '#';       goto process;
						default:
							cppUngetc ('?');
							cppUngetc (next);
							break;
					}
				}
			} break;

			/* digraphs:
			 * input:  <:  :>  <%  %>  %:  %:%:
			 * output: [   ]   {   }   #   ##
			 */
			case '<':
			{
				/*
				   Quoted from http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2011/n3237.html:
				   ------
				   if the next three characters are <:: and the
				   subsequent character is neither : nor >, the < is
				   treated as a preprocessor token by itself (and not as
				   the first character of the alternative token */
				int next[3];
				next[0] = cppGetcFromUngetBufferOrFile ();
				switch (next[0])
				{
					case ':':
						next[1] = cppGetcFromUngetBufferOrFile ();
						if (next[1] == ':')
						{
							next[2] = cppGetcFromUngetBufferOrFile ();
							if (! (next[2] == ':' || next[2] == '>'))
							{
								cppUngetc (next[2]);
								cppUngetc (next[1]);
								cppUngetc (next[0]);
								c = '<';
							}
							else
							{
								cppUngetc (next[2]);
								cppUngetc (next[1]);
								c = '[';
							}
						}
						else
						{
							cppUngetc (next[1]);
							c = '[';
						}
						break;
					case '%':	c = '{'; break;
					default: cppUngetc (next[0]);
				}
				goto enter;
			}
			case ':':
			{
				int next = cppGetcFromUngetBufferOrFile ();
				if (next == '>')
					c = ']';
				else
					cppUngetc (next);
				goto enter;
			}
			case '%':
			{
				int next = cppGetcFromUngetBufferOrFile ();
				switch (next)
				{
					case '>':	c = '}'; break;
					case ':':	c = '#'; goto process;
					default: cppUngetc (next);
				}
				goto enter;
			}

			default:
				if (c == '@' && Cpp.hasAtLiteralStrings)
				{
					int next = cppGetcFromUngetBufferOrFile ();
					if (next == DOUBLE_QUOTE)
					{
						Cpp.directive.accept = false;
						c = skipToEndOfString (true);
						break;
					}
					else
						cppUngetc (next);
				}
				else if (c == 'R' && Cpp.hasCxxRawLiteralStrings)
				{
					/* OMG!11 HACK!!11  Get the previous character.
					 *
					 * We need to know whether the previous character was an identifier or not,
					 * because "R" has to be on its own, not part of an identifier.  This allows
					 * for constructs like:
					 *
					 * 	#define FOUR "4"
					 * 	const char *p = FOUR"5";
					 *
					 * which is not a raw literal, but a preprocessor concatenation.
					 *
					 * FIXME: handle
					 *
					 * 	const char *p = R\
					 * 	"xxx(raw)xxx";
					 *
					 * which is perfectly valid (yet probably very unlikely). */
					int prev = getNthPrevCFromInputFile (1, '\0');
					int prev2 = getNthPrevCFromInputFile (2, '\0');
					int prev3 = getNthPrevCFromInputFile (3, '\0');

					if (! cppIsident (prev) ||
					    (! cppIsident (prev2) && (prev == 'L' || prev == 'u' || prev == 'U')) ||
					    (! cppIsident (prev3) && (prev2 == 'u' && prev == '8')))
					{
						int next = cppGetcFromUngetBufferOrFile ();
						if (next != DOUBLE_QUOTE)
							cppUngetc (next);
						else
						{
							Cpp.directive.accept = false;
							c = skipToEndOfCxxRawLiteralString ();
							break;
						}
					}
				}
				else if(isxdigit(c))
				{
					/* Check for digit separator. If we find it we just skip it */
					int next = cppGetcFromUngetBufferOrFile();
					if(next != SINGLE_QUOTE)
						cppUngetc(next);
				}
			enter:
				Cpp.directive.accept = false;
				if (directive)
					ignore = handleDirective (c, &macroCorkIndex);
				break;
		}
	} while (directive || ignore);

	DebugStatement ( debugPutc (DEBUG_CPP, c); )
	DebugStatement ( if (c == NEWLINE)
				debugPrintf (DEBUG_CPP, "%6ld: ", getInputLineNumber () + 1); )

	return c;
}

static void findCppTags (void)
{
	cppInitCommon (Cpp.lang, 0, false, false, false,
				   KIND_GHOST_INDEX, 0, KIND_GHOST_INDEX, 0, 0);

	findRegexTagsMainloop (cppGetc);

	cppTerminate ();
}


/*
 *  Token ignore processing
 */

static hashTable * defineMacroTable;

/*  Determines whether or not "name" should be ignored, per the ignore list.
 */
extern const cppMacroInfo * cppFindMacro(const char *const name)
{
	if(!defineMacroTable)
		return NULL;

	return (const cppMacroInfo *)hashTableGetItem(defineMacroTable,(char *)name);
}

extern vString * cppBuildMacroReplacement(
		const cppMacroInfo * macro,
		const char ** parameters, /* may be NULL */
		int parameterCount
	)
{
	if(!macro)
		return NULL;

	if(!macro->replacements)
		return NULL;

	vString * ret = vStringNew();

	cppMacroReplacementPartInfo * r = macro->replacements;

	while(r)
	{
		if(r->parameterIndex < 0)
		{
			if(r->constant)
				vStringCat(ret,r->constant);
		} else {
			if(parameters && (r->parameterIndex < parameterCount))
			{
				if(r->flags & CPP_MACRO_REPLACEMENT_FLAG_STRINGIFY)
					vStringPut(ret,'"');

				vStringCatS(ret,parameters[r->parameterIndex]);
				if(r->flags & CPP_MACRO_REPLACEMENT_FLAG_VARARGS)
				{
					int idx = r->parameterIndex + 1;
					while(idx < parameterCount)
					{
						vStringPut(ret,',');
						vStringCatS(ret,parameters[idx]);
						idx++;
					}
				}

				if(r->flags & CPP_MACRO_REPLACEMENT_FLAG_STRINGIFY)
					vStringPut(ret,'"');
			}
		}

		r = r->next;
	}

	return ret;
}


static void saveIgnoreToken(const char * ignoreToken)
{
	if(!ignoreToken)
		return;

	Assert (defineMacroTable);

	const char * c = ignoreToken;
	char cc = *c;

	const char * tokenBegin = c;
	const char * tokenEnd = NULL;
	const char * replacement = NULL;
	bool ignoreFollowingParenthesis = false;

	while(cc)
	{
		if(cc == '=')
		{
			if(!tokenEnd)
				tokenEnd = c;
			c++;
			if(*c)
				replacement = c;
			break;
		}

		if(cc == '+')
		{
			if(!tokenEnd)
				tokenEnd = c;
			ignoreFollowingParenthesis = true;
		}

		c++;
		cc = *c;
	}

	if(!tokenEnd)
		tokenEnd = c;

	if(tokenEnd <= tokenBegin)
		return;

	cppMacroInfo * info = (cppMacroInfo *)eMalloc(sizeof(cppMacroInfo));

	info->hasParameterList = ignoreFollowingParenthesis;
	if(replacement)
	{
		cppMacroReplacementPartInfo * rep = \
			(cppMacroReplacementPartInfo *)eMalloc(sizeof(cppMacroReplacementPartInfo));
		rep->parameterIndex = -1;
		rep->flags = 0;
		rep->constant = vStringNewInit(replacement);
		rep->next = NULL;
		info->replacements = rep;
	} else {
		info->replacements = NULL;
	}

	hashTablePutItem(defineMacroTable,eStrndup(tokenBegin,tokenEnd - tokenBegin),info);

	verbose ("    ignore token: %s\n", ignoreToken);
}

static void saveMacro(const char * macro)
{
	CXX_DEBUG_ENTER_TEXT("Save macro %s",macro);

	if(!macro)
		return;

	Assert (defineMacroTable);

	const char * c = macro;

	// skip initial spaces
	while(*c && isspacetab(*c))
		c++;

	if(!*c)
	{
		CXX_DEBUG_LEAVE_TEXT("Bad empty macro definition");
		return;
	}

	if(!(isalpha(*c) || (*c == '_')))
	{
		CXX_DEBUG_LEAVE_TEXT("Macro does not start with an alphanumeric character");
		return; // must be a sequence of letters and digits
	}

	const char * identifierBegin = c;

	while(*c && (isalnum(*c) || (*c == '_')))
		c++;

	const char * identifierEnd = c;

	CXX_DEBUG_PRINT("Macro identifier '%.*s'",identifierEnd - identifierBegin,identifierBegin);

#define MAX_PARAMS 16

	const char * paramBegin[MAX_PARAMS];
	const char * paramEnd[MAX_PARAMS];

	int iParamCount = 0;

	while(*c && isspacetab(*c))
		c++;

	cppMacroInfo * info = (cppMacroInfo *)eMalloc(sizeof(cppMacroInfo));

	if(*c == '(')
	{
		// parameter list
		CXX_DEBUG_PRINT("Macro has a parameter list");

		info->hasParameterList = true;

		c++;
		while(*c)
		{
			while(*c && isspacetab(*c))
				c++;

			if(*c && (*c != ',') && (*c != ')'))
			{
				paramBegin[iParamCount] = c;
				c++;
				while(*c && (*c != ',') && (*c != ')') && (!isspacetab(*c)))
					c++;
				paramEnd[iParamCount] = c;

				CXX_DEBUG_PRINT(
						"Macro parameter %d '%.*s'",
							iParamCount,
							paramEnd[iParamCount] - paramBegin[iParamCount],
							paramBegin[iParamCount]
					);

				iParamCount++;
				if(iParamCount >= MAX_PARAMS)
					break;
			}

			while(*c && isspacetab(*c))
				c++;

			if(*c == ')')
				break;

			if(*c == ',')
				c++;
		}

		while(*c && (*c != ')'))
			c++;

		if(*c == ')')
			c++;

		CXX_DEBUG_PRINT("Got %d parameters",iParamCount);

	} else {
		info->hasParameterList = false;
	}

	while(*c && isspacetab(*c))
		c++;

	info->replacements = NULL;


	if(*c == '=')
	{
		CXX_DEBUG_PRINT("Macro has a replacement part");

		// have replacement part
		c++;

		cppMacroReplacementPartInfo * lastReplacement = NULL;
		int nextParameterReplacementFlags = 0;

#define ADD_REPLACEMENT_NEW_PART(part) \
		do { \
			if(lastReplacement) \
				lastReplacement->next = part; \
			else \
				info->replacements = part; \
			lastReplacement = part; \
		} while(0)

#define ADD_CONSTANT_REPLACEMENT_NEW_PART(start,len) \
		do { \
			cppMacroReplacementPartInfo * rep = \
				(cppMacroReplacementPartInfo *)eMalloc(sizeof(cppMacroReplacementPartInfo)); \
			rep->parameterIndex = -1; \
			rep->flags = 0; \
			rep->constant = vStringNew(); \
			vStringNCatS(rep->constant,start,len); \
			rep->next = NULL; \
			CXX_DEBUG_PRINT("Constant replacement part: '%s'",vStringValue(rep->constant)); \
			ADD_REPLACEMENT_NEW_PART(rep); \
		} while(0)

#define ADD_CONSTANT_REPLACEMENT(start,len) \
		do { \
			if(lastReplacement && (lastReplacement->parameterIndex == -1)) \
			{ \
				vStringNCatS(lastReplacement->constant,start,len); \
				CXX_DEBUG_PRINT( \
						"Constant replacement part changed: '%s'", \
						vStringValue(lastReplacement->constant) \
					); \
			} else { \
				ADD_CONSTANT_REPLACEMENT_NEW_PART(start,len); \
			} \
		} while(0)

		// parse replacements
		const char * begin = c;

		while(*c)
		{
			if(isalpha(*c) || (*c == '_'))
			{
				if(c > begin)
					ADD_CONSTANT_REPLACEMENT(begin,c - begin);

				const char * tokenBegin = c;

				while(*c && (isalnum(*c) || (*c == '_')))
					c++;

				// check if it is a parameter
				int tokenLen = c - tokenBegin;

				CXX_DEBUG_PRINT("Check token '%.*s'",tokenLen,tokenBegin);

				bool bIsVarArg = (tokenLen == 11) && (strncmp(tokenBegin,"__VA_ARGS__",11) == 0);

				int i = 0;
				for(;i<iParamCount;i++)
				{
					int paramLen = paramEnd[i] - paramBegin[i];

					if(
							(
								bIsVarArg &&
								(paramLen == 3) &&
								(strncmp(paramBegin[i],"...",3) == 0)
							) || (
								(!bIsVarArg) &&
								(paramLen == tokenLen) &&
								(strncmp(paramBegin[i],tokenBegin,paramLen) == 0)
							)
						)
					{
						// parameter!
						cppMacroReplacementPartInfo * rep = \
								(cppMacroReplacementPartInfo *)eMalloc(sizeof(cppMacroReplacementPartInfo));
						rep->parameterIndex = i;
						rep->flags = nextParameterReplacementFlags |
								(bIsVarArg ? CPP_MACRO_REPLACEMENT_FLAG_VARARGS : 0);
						rep->constant = NULL;
						rep->next = NULL;

						nextParameterReplacementFlags = 0;

						CXX_DEBUG_PRINT("Parameter replacement part: %d (vararg %d)",i,bIsVarArg);

						ADD_REPLACEMENT_NEW_PART(rep);
						break;
					}
				}

				if(i >= iParamCount)
				{
					// no parameter found
					ADD_CONSTANT_REPLACEMENT(tokenBegin,tokenLen);
				}

				begin = c;
				continue;
			}

			if((*c == '"') || (*c == '\''))
			{
				// skip string/char constant
				char term = *c;
				c++;
				while(*c)
				{
					if(*c == '\\')
					{
						c++;
						if(*c)
							c++;
					} else if(*c == term)
					{
						c++;
						break;
					}
					c++;
				}
				continue;
			}

			if(*c == '#')
			{
				// check for token paste/stringification
				if(c > begin)
					ADD_CONSTANT_REPLACEMENT(begin,c - begin);

				c++;
				if(*c == '#')
				{
					// token paste
					CXX_DEBUG_PRINT("Found token paste operator");
					while(*c == '#')
						c++;

					// we just skip this part and the following spaces
					while(*c && isspacetab(*c))
						c++;

					if(lastReplacement && (lastReplacement->parameterIndex == -1))
					{
						// trim spaces from the last replacement constant!
						vStringStripTrailing(lastReplacement->constant);
						CXX_DEBUG_PRINT(
								"Last replacement truncated to '%s'",
								vStringValue(lastReplacement->constant)
							);
					}
				} else {
					// stringification
					CXX_DEBUG_PRINT("Found stringification operator");
					nextParameterReplacementFlags |= CPP_MACRO_REPLACEMENT_FLAG_STRINGIFY;
				}

				begin = c;
				continue;
			}

			c++;
		}

		if(c > begin)
			ADD_CONSTANT_REPLACEMENT(begin,c - begin);
	}

	hashTablePutItem(defineMacroTable,eStrndup(identifierBegin,identifierEnd - identifierBegin),info);
	CXX_DEBUG_LEAVE();
}

static void freeMacroInfo(cppMacroInfo * info)
{
	if(!info)
		return;
	cppMacroReplacementPartInfo * pPart = info->replacements;
	while(pPart)
	{
		if(pPart->constant)
			vStringDelete(pPart->constant);
		cppMacroReplacementPartInfo * pPartToDelete = pPart;
		pPart = pPart->next;
		eFree(pPartToDelete);
	}
	eFree(info);
}

static hashTable *makeMacroTable (void)
{
	return hashTableNew(
		1024,
		hashCstrhash,
		hashCstreq,
		free,
		(void (*)(void *))freeMacroInfo
		);
}

static void initializeCpp (const langType language)
{
	Cpp.lang = language;

	defineMacroTable = makeMacroTable ();
	DEFAULT_TRASH_BOX(defineMacroTable,hashTableDelete);
}

static void CpreProInstallIgnoreToken (const langType language CTAGS_ATTR_UNUSED, const char *optname CTAGS_ATTR_UNUSED, const char *arg)
{
	if (arg == NULL || arg[0] == '\0')
	{
		DEFAULT_TRASH_BOX_TAKE_BACK(defineMacroTable);
		hashTableDelete(defineMacroTable);
		defineMacroTable = makeMacroTable ();
		DEFAULT_TRASH_BOX(defineMacroTable,hashTableDelete);

		verbose ("    clearing list\n");
	} else {
		saveIgnoreToken(arg);
	}
}

static void CpreProInstallMacroToken (const langType language CTAGS_ATTR_UNUSED, const char *optname CTAGS_ATTR_UNUSED, const char *arg)
{
	if (arg == NULL || arg[0] == '\0')
	{
		hashTableDelete(defineMacroTable);
		defineMacroTable = makeMacroTable ();
		verbose ("    clearing list\n");
	} else {
		saveMacro(arg);
	}
}

static void CpreProSetIf0 (const langType language CTAGS_ATTR_UNUSED, const char *name, const char *arg)
{
	doesExaminCodeWithInIf0Branch = paramParserBool (arg, doesExaminCodeWithInIf0Branch,
													 name, "parameter");
}

static parameterHandlerTable CpreProParameterHandlerTable [] = {
	{ .name = "if0",
	  .desc = "examine code within \"#if 0\" branch (true or [false])",
	  .handleParameter = CpreProSetIf0,
	},
	{ .name = "ignore",
	  .desc = "a token to be specially handled",
	  .handleParameter = CpreProInstallIgnoreToken,
	},
	{ .name = "define",
	  .desc = "define replacement for an identifier",
	  .handleParameter = CpreProInstallMacroToken,
	},
};

extern parserDefinition* CPreProParser (void)
{
	parserDefinition* const def = parserNew ("CPreProcessor");
	def->kindTable      = CPreProKinds;
	def->kindCount  = ARRAY_SIZE (CPreProKinds);
	def->initialize = initializeCpp;
	def->parser     = findCppTags;

	def->parameterHandlerTable = CpreProParameterHandlerTable;
	def->parameterHandlerCount = ARRAY_SIZE(CpreProParameterHandlerTable);

	return def;
}
