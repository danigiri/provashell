#!/usr/bin/env bash

# load without running any tests
PS_SKIP_ALL=1 . classes/provashell

OK_=0
ERR_=1
FAIL_=3
PARAMS_=4
BADTEST_=5

echo_() {
	printf %s\\n "$@"
}

err_() {
	printf %s\\n "$@"
	exit 1
}

echo_ 'THE NEXT TESTS USE NETWORK CONNECTIVITY, DEFINE ENV VAR'
echo_ "'PS_SKIP_NET' TO SKIP THEM"

[ ! -z "$PS_SKIP_NET" ] && startSkippingTests
echo_ '-------------- Testing assertPing --------------'
$(assertPing 2>/dev/null)
[ $? -ne "$PARAMS_" ] && err_ 'assertPing without params should be an error' 

assertPing '8.8.8.8'
[ $? -ne "$OK_" ] && err_ 'assertPing to google dns primary at 8.8.8.8 should not fail'

$(assertPing '127.0.0.257' 2>/dev/null)
[ $? -ne $FAIL_ ] && err_ 'assertPing to a nonexistant IP should fail'

assertPing 'www.google.com'
[ $? -ne "$OK_" ] && err_ 'assertPing to google should not fail'

$(assertPing 'www.xyz12345xzy12345xyz.zzz' 2>/dev/null)
[ $? -ne $FAIL_ ] && err_ 'assertPing to a nonexistant DNS entry should fail'

[ ! -z "$PS_SKIP_NET" ] && stopSkippingTests


exit 0