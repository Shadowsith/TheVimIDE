# Copyright: 2015 Masatake YAMATO
# License: GPL-2

CTAGS=$1
${CTAGS} --quiet --options=NONE --kinds-all='*' --list-kinds | grep '\[off\]'

