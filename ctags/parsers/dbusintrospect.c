/*
*
*   Copyright (c) 2016, Masatake YAMATO
*   Copyright (c) 2016, Red Hat, K.K.
*
*   This source code is released for free distribution under the terms of the
*   GNU General Public License version 2 or (at your option) any later version.
*
*   This module contains functions for generating tags for
*   <!DOCTYPE node PUBLIC
*             "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN"
*             "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">
*
*/

#include "general.h"	/* must always come first */
#include "debug.h"
#include "options.h"
#include "parse.h"
#include "read.h"
#include "routines.h"
#include "selectors.h"


typedef enum {
	K_INTERFACE, K_METHOD, K_SIGNAL, K_PROPERTY
} dbusIntrospectKind;

static kindDefinition DbusIntrospectKinds [] = {
	{ true,  'i', "interface", "interfaces" },
	{ true,  'm', "method",    "methods"    },
	{ true,  's', "signal",    "signals"    },
	{ true,  'p', "property",  "properties" },
};

static void dbusIntrospectFindTagsUnderInterface (xmlNode *node,
						  const struct sTagXpathRecurSpec *spec,
						  xmlXPathContext *ctx,
						  void *userData);
static void makeTagForInterfaceName (xmlNode *node,
				     const struct sTagXpathMakeTagSpec *spec,
				     struct sTagEntryInfo *tag,
				     void *userData);
static void makeTagWithScope (xmlNode *node,
			      const struct sTagXpathMakeTagSpec *spec,
			      struct sTagEntryInfo *tag,
			      void *userData);


static tagXpathTable dbusIntrospectXpathInterfaceTable [] = {
	{ "//method/@name",
	  LXPATH_TABLE_DO_MAKE,
	  { .makeTagSpec = {K_METHOD, ROLE_INDEX_DEFINITION,
			    makeTagWithScope } }
	},
	{ "//signal/@name",
	  LXPATH_TABLE_DO_MAKE,
	  { .makeTagSpec = { K_SIGNAL, ROLE_INDEX_DEFINITION,
			     makeTagWithScope } }
	},
	{ "//property/@name",
	  LXPATH_TABLE_DO_MAKE,
	  { .makeTagSpec = { K_PROPERTY, ROLE_INDEX_DEFINITION,
			     makeTagWithScope } }
	},
};

static tagXpathTable dbusIntrospectXpathMainTable [] = {
	{ "///interface",
	  LXPATH_TABLE_DO_RECUR,
	  { .recurSpec = { dbusIntrospectFindTagsUnderInterface } }
	},
};

static tagXpathTable dbusIntrospectXpathMainNameTable [] = {
	{ "@name",
	  LXPATH_TABLE_DO_MAKE,
	  { .makeTagSpec = { K_INTERFACE, ROLE_INDEX_DEFINITION,
			     makeTagForInterfaceName } }
	},
};

enum dbusIntrospectXpathTable {
	TABLE_MAIN, TABLE_INTERFACE, TABLE_MAIN_NAME,
};

static tagXpathTableTable dbusIntrospectXpathTableTable[] = {
	[TABLE_MAIN]      = { ARRAY_AND_SIZE (dbusIntrospectXpathMainTable)     },
	[TABLE_INTERFACE] = { ARRAY_AND_SIZE (dbusIntrospectXpathInterfaceTable)},
	[TABLE_MAIN_NAME] = { ARRAY_AND_SIZE (dbusIntrospectXpathMainNameTable) },
};

static void dbusIntrospectFindTagsUnderInterface (xmlNode *node,
						  const struct sTagXpathRecurSpec *spec CTAGS_ATTR_UNUSED,
						  xmlXPathContext *ctx,
						  void *userData CTAGS_ATTR_UNUSED)
{
	int corkIndex = CORK_NIL;

	findXMLTags (ctx, node,
		     dbusIntrospectXpathTableTable + TABLE_MAIN_NAME,
		     DbusIntrospectKinds,
		     &corkIndex);
	findXMLTags (ctx, node,
		     dbusIntrospectXpathTableTable + TABLE_INTERFACE,
		     DbusIntrospectKinds,
		     &corkIndex);
}

static void makeTagWithScope (xmlNode *node CTAGS_ATTR_UNUSED,
			      const struct sTagXpathMakeTagSpec *spec CTAGS_ATTR_UNUSED,
			      struct sTagEntryInfo *tag,
			      void *userData)
{
	tag->extensionFields.scopeKindIndex = KIND_GHOST_INDEX;
	tag->extensionFields.scopeName  = NULL;
	tag->extensionFields.scopeIndex = *(int *)userData;

	makeTagEntry (tag);
}

static void makeTagForInterfaceName (xmlNode *node CTAGS_ATTR_UNUSED,
				     const struct sTagXpathMakeTagSpec *spec CTAGS_ATTR_UNUSED,
				     struct sTagEntryInfo *tag,
				     void *userData)
{
	int *corkIndex = userData;

	*corkIndex = makeTagEntry (tag);
}

static void
findDbusIntrospectTags (void)
{
	findXMLTags (NULL, NULL,
		     dbusIntrospectXpathTableTable + TABLE_MAIN,
		     DbusIntrospectKinds,
		     NULL);
}

extern parserDefinition*
DbusIntrospectParser (void)
{
	static const char *const extensions [] = { "xml", NULL };
	parserDefinition* const def = parserNew ("DBusIntrospect");
	static selectLanguage selectors[] = { selectByXpathFileSpec, NULL };

	static xpathFileSpec xpathFileSpecs[] = {
		{
			/* <!DOCTYPE node PUBLIC "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN"
			   "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">
			   <node ... */
			.externalID = "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN",
			.systemID   = "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd",
		},
	};
	def->kindTable         = DbusIntrospectKinds;
	def->kindCount     = ARRAY_SIZE (DbusIntrospectKinds);
	def->extensions    = extensions;
	def->parser        = findDbusIntrospectTags;
	def->tagXpathTableTable = dbusIntrospectXpathTableTable;
	def->tagXpathTableCount = ARRAY_SIZE (dbusIntrospectXpathTableTable);
	def->useCork = true;
	def->selectLanguage = selectors;
	def->xpathFileSpecs = xpathFileSpecs;
	def->xpathFileSpecCount = ARRAY_SIZE (xpathFileSpecs);

	return def;
}
