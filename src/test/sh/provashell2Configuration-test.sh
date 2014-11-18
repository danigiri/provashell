#!/usr/bin/env bash

# load without running any tests
PS_SKIP_ALL=1 . classes/provashell

FAIL_=3
PARAMS_=4

err_() {
	printf %s\\n "$@"
	exit 1
}

exiting_() {

	unset PS_EXIT_ON_FAIL
	assertTrue 0

	exit 0
}

echo '----------- Testing PS_EXIT_ON_FAIL ----------'

PS_EXIT_ON_FAIL='true'

trap exiting_ EXIT

# this should exit and run 'exiting_'
assertTrue 1 >/dev/null

err_ 'assertTrue with EXIT_ON_FAIL should be an error ($?)'
