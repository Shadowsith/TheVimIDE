/*
*   Copyright (c) 2017, Masatake YAMATO
*
*   This source code is released for free distribution under the terms of the
*   GNU General Public License version 2 or (at your option) any later version.
*
*/

#include "general.h"  /* must always come first */
#include "tcl.h"
#include "entry.h"
#include "parse.h"
#include "string.h"
#include "read.h"
#include "keyword.h"

struct itclSubparser {
	tclSubparser tcl;
	bool foundITclPackageRequired;
	bool foundITclNamespaceImported;
};

static scopeSeparator ITclGenericSeparators [] = {
	{ KIND_WILDCARD_INDEX, "::" },
};

enum ITclKind {
	K_CLASS,
	K_METHOD,
	K_VARIABLE,
	K_COMMON,
	K_PROC,
};

static kindDefinition ITclKinds[] = {
	{ true, 'c', "class", "classes" },
	{ true, 'm', "method", "methods",
	  ATTACH_SEPARATORS(ITclGenericSeparators)},
	{ true, 'v', "variable", "object-specific variables",
	  ATTACH_SEPARATORS(ITclGenericSeparators)},
	{ true, 'C', "common", "common variables",
	  ATTACH_SEPARATORS(ITclGenericSeparators)},
	{ true, 'p', "procedure", "procedures within the  class  namespace",
	  ATTACH_SEPARATORS(ITclGenericSeparators)},
};

enum {
	KEYWORD_INHERIT,
	KEYWORD_METHOD,
	KEYWORD_PRIVATE,
	KEYWORD_PROTECTED,
	KEYWORD_PUBLIC,
	KEYWORD_VARIABLE,
	KEYWORD_COMMON,
	KEYWORD_PROC,
};

typedef int keywordId; /* to allow KEYWORD_NONE */

static const keywordTable ITclKeywordTable[] = {
	/* keyword			keyword ID */
	{ "inherit",		KEYWORD_INHERIT		},
	{ "method",			KEYWORD_METHOD		},
	{ "private",		KEYWORD_PRIVATE		},
	{ "protected",		KEYWORD_PROTECTED	},
	{ "public",			KEYWORD_PUBLIC		},
	{ "variable",		KEYWORD_VARIABLE	},
	{ "common",			KEYWORD_COMMON		},
	{ "proc",			KEYWORD_PROC		},
};

static keywordId resolveKeyword (vString *string)
{
	char *s = vStringValue (string);
	static langType lang = LANG_AUTO;

	if (lang == LANG_AUTO)
		lang = getInputLanguage ();

	return lookupKeyword (s, lang);
}

static void parseInherit (tokenInfo *token, int r)
{
	vString *inherits = vStringNew ();

	do {
		tokenRead (token);
		if (tokenIsType (token, TCL_IDENTIFIER))
		{
			if (vStringLength(inherits) != 0)
				vStringPut (inherits, ',');
			vStringCat(inherits, token->string);
		}
		else if (tokenIsType(token, TCL_EOL))
			break;
		else
		{
			skipToEndOfTclCmdline (token);
			break;
		}
	} while (1);

	if (vStringLength(inherits) > 0)
	{
		tagEntryInfo *e = getEntryInCorkQueue (r);
		if (e)
		{
			e->extensionFields.inheritance = vStringDeleteUnwrap (inherits);
			return;
		}
	}

	vStringDelete (inherits);
}

static void attachProtectionMaybe(tagEntryInfo *e, keywordId protection)
{
		switch (protection)
		{
		case KEYWORD_PROTECTED:
			e->extensionFields.implementation = "protected";
			break;
		case KEYWORD_PRIVATE:
			e->extensionFields.implementation = "private";
			break;
		case KEYWORD_PUBLIC:
			e->extensionFields.implementation = "public";
			break;
		}
}

static void parseSubobject (tokenInfo *token, int parent, enum ITclKind kind, keywordId protection)
{
	int r = CORK_NIL;

	tokenRead (token);
	if (tokenIsType (token, TCL_IDENTIFIER))
	{
		tagEntryInfo e;

		initTagEntry(&e, vStringValue (token->string), kind);
		e.extensionFields.scopeIndex = parent;
		attachProtectionMaybe (&e, protection);
		r = makeTagEntry (&e);
	}

	skipToEndOfTclCmdline (token);
	if (r != CORK_NIL)
	{
		tagEntryInfo *e = getEntryInCorkQueue (r);
		e->extensionFields.endLine = token->lineNumber;
	}
}


static void parseVariable (tokenInfo *token, int r, keywordId protection)
{
	parseSubobject(token, r, K_VARIABLE, protection);
}

static void parseMethod (tokenInfo *token, int r, keywordId protection)
{
	parseSubobject(token, r, K_METHOD, protection);
}

static void parseProc (tokenInfo *token, int r, keywordId protection)
{
	parseSubobject(token, r, K_PROC, protection);
}

static void parseCommon (tokenInfo *token, int r, keywordId protection)
{
	parseSubobject(token, r, K_COMMON, protection);
}

static int parseClass (tclSubparser *s CTAGS_ATTR_UNUSED, int parentIndex,
					   void *pstate)
{
	tokenInfo *token = newTclToken (pstate);
	int r = CORK_NIL;

	tokenRead (token);
	if (tokenIsType (token, TCL_IDENTIFIER))
	{
		tagEntryInfo e;

		initTagEntry(&e, vStringValue (token->string), K_CLASS);
		e.extensionFields.scopeIndex = parentIndex;
		r = makeTagEntry (&e);
	}

	if (tokenSkipToType (token, '{'))
	{
		keywordId protection = KEYWORD_NONE;

		do {
			tokenRead (token);
			if (tokenIsType (token, TCL_IDENTIFIER)
				|| tokenIsType (token, TCL_KEYWORD))
			{
				keywordId k = resolveKeyword (token->string);
				switch (k)
				{
				case KEYWORD_INHERIT:
					parseInherit(token, r);
					protection = KEYWORD_NONE;
					break;
				case KEYWORD_VARIABLE:
					parseVariable(token, r, protection);
					protection = KEYWORD_NONE;
					break;
				case KEYWORD_METHOD:
					parseMethod(token, r, protection);
					protection = KEYWORD_NONE;
					break;
				case KEYWORD_COMMON:
					parseCommon(token, r, protection);
					protection = KEYWORD_NONE;
					break;
				case KEYWORD_PUBLIC:
				case KEYWORD_PROTECTED:
				case KEYWORD_PRIVATE:
					protection = k;
					continue;
				case KEYWORD_PROC:
					parseProc(token, r, protection);
					protection = KEYWORD_NONE;
					break;
				default:
					protection = KEYWORD_NONE;
					skipToEndOfTclCmdline (token);
					break;
				}
			}
			else if (token->type == '}')
			{
				protection = KEYWORD_NONE;
				break;
			}
			else
			{
				protection = KEYWORD_NONE;
				skipToEndOfTclCmdline (token);
			}
		} while (!tokenIsEOF(token));
	}

	tokenDestroy(token);
	return r;
}

static int commandNotify (tclSubparser *s, char *command,
						  int parentIndex, void *pstate)
{
	struct itclSubparser *itcl = (struct itclSubparser *)s;
	int r = CORK_NIL;

	if (!itcl->foundITclPackageRequired)
		return r;

	if ((itcl->foundITclNamespaceImported
		 && (strcmp (command, "class") == 0))
		|| (strcmp (command, "itcl::class") == 0))
		r = parseClass (s, parentIndex, pstate);

	return r;
}

static void packageRequirementNotify (tclSubparser *s, char *package,
									  void *pstate CTAGS_ATTR_UNUSED)
{
	struct itclSubparser *itcl = (struct itclSubparser *)s;
	if (strcmp (package, "Itcl") == 0)
		itcl->foundITclPackageRequired = true;
}

static void namespaceImportNotify (tclSubparser *s, char *namespace,
								   void *pstate CTAGS_ATTR_UNUSED)
{
	struct itclSubparser *itcl = (struct itclSubparser *)s;

	if (strcmp(namespace, "itcl::*") == 0
		|| strcmp(namespace, "itcl::class") == 0)
		itcl->foundITclNamespaceImported = true;
}

static void inputStart (subparser *s)
{
	struct itclSubparser *itcl = (struct itclSubparser *)s;

	itcl->foundITclPackageRequired = false;
	itcl->foundITclNamespaceImported = false;
}

struct itclSubparser itclSubparser = {
	.tcl = {
		.subparser = {
			.direction = SUBPARSER_BI_DIRECTION,
			.inputStart = inputStart,
		},
		.commandNotify = commandNotify,
		.packageRequirementNotify = packageRequirementNotify,
		.namespaceImportNotify = namespaceImportNotify,
	},
};

static void findITclTags(void)
{
	scheduleRunningBaseparser (RUN_DEFAULT_SUBPARSERS);
}

extern parserDefinition* ITclParser (void)
{
	static const char *const extensions [] = { "itcl", NULL };
	parserDefinition* const def = parserNew("ITcl");

	static parserDependency dependencies [] = {
		[0] = { DEPTYPE_SUBPARSER, "Tcl", &itclSubparser },
	};

	def->dependencies = dependencies;
	def->dependencyCount = ARRAY_SIZE (dependencies);

	def->kindTable = ITclKinds;
	def->kindCount = ARRAY_SIZE(ITclKinds);

	def->extensions = extensions;
	def->parser = findITclTags;
	def->useCork = true;
	def->requestAutomaticFQTag = true;

	def->keywordTable = ITclKeywordTable;
	def->keywordCount = ARRAY_SIZE (ITclKeywordTable);

	return def;
}
