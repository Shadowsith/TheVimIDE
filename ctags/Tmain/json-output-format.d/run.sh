# Copyright: 2016 Aman Gupta
# License: GPL-2

CTAGS=$1

. ../utils.sh

if is_feature_available "${CTAGS}" json; then
    {
	run_with_format json --languages=+man
	run_with_format json --languages=+man --fields="*"
	run_with_format json --languages=+man --fields="*" --extras='*'-{subword}
    } | grep -v TAG_PROGRAM_VERSION
fi
