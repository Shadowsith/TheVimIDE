# Copyright: 2015 Masatake YAMATO
# License: GPL-2

CTAGS=$1

${CTAGS} --quiet --options=NONE -o - \
	 --langdef=foo \
	 --regex-foo=/a/\0/a/ --kinds-foo=-a --foo-kinds=+a \
	 --regex-foo=/b/\0/b/ --foo-kinds=-b \
	 --regex-foo=/c/\0/c/ \
	 --kinds-foo=-c \
	 --regex-foo=/d/\0/d/ \
	 --list-kinds=foo | sort
