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


echo_ '---------------- Network tests ------------------------'
echo_ 'THE NEXT TESTS USE NETWORK CONNECTIVITY, DEFINE ENV VAR'
echo_ "'PS_SKIP_NET' TO SKIP THEM"
echo_ '-------------------------------------------------------'

[ ! -z "$PS_SKIP_NET" ] && startSkippingTests
echo_ '-------------- Testing assertPing --------------'
$(assertPing 2>/dev/null)
[ $? -ne "$PARAMS_" ] && err_ 'assertPing without params should be an error' 

assertPing '8.8.8.8'
[ $? -ne "$OK_" ] && err_ 'assertPing to google dns primary at 8.8.8.8 should not fail'

assertPing '127.0.0.257' 2>1 >/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertPing to a nonexistant IP should fail'

assertPing 'www.google.com'
[ $? -ne "$OK_" ] && err_ 'assertPing to google should not fail'

assertPing 'www.xyz12345xzy12345xyz.zzz' 2>1 >/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertPing to a nonexistant DNS entry should fail'

m_=$(assertPing 'message' 'www.xyz12345xzy12345xyz.zzz' 2>/dev/null)
[ "$m_" != 'message' ] && err_ 'assertPing a nonexistant DNS entry should fail with message'

echo_ '-------------- Testing assertTCPConnect --------------'
$(assertTCPConnect 2>/dev/null)
[ $? -ne "$PARAMS_" ] && err_ 'assertTCPConnect without params should be an error' 

$(assertTCPConnect 8.8.8.8 2>/dev/null)
[ $? -ne $PARAMS_ ] && err_ 'assertTCPConnect with only one param should be an error' 

assertTCPConnect 8.8.8.8 53
[ $? -ne "$OK_" ] && err_ 'assertTCPConnect to google dns primary at 8.8.8.8 should not fail'

assertTCPConnect 8.8.8.8 55555 >/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertTCPConnect to a random port should fail'

assertTCPConnect 127.0.0.257 53 2>1 >/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertTCPConnect to a random host should fail'

m_=$(assertTCPConnect 'message' 'www.xyz12345xzy12345xyz.zzz' 53 2>/dev/null)
[ "$m_" != 'message' ] && err_ 'assertTCPConnect to a random host should fail with message'


[ ! -z "$PS_SKIP_NET" ] && stopSkippingTests


exit 0