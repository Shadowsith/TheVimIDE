#!/bin/sh

# Copyright: 2017 Masatake YAMATO
# License: GPL-2

CTAGS=$1

. ../utils.sh
is_feature_available $CTAGS sandbox
is_feature_available ${CTAGS} '!' gcov

{
    echo '{"command":"generate-tags", "filename":"input.c", "size": -1}'
    echo '{"command":"generate-tags", "filename":"input.el", "size": 16}'
    echo '(defun foo () 0)'
} | $CTAGS --quiet --options=NONE  --_interactive=sandbox

exit $?
