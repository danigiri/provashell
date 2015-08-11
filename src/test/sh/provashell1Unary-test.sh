#!/usr/bin/env bash

# load without running any tests
PS_SKIP_ALL=1 . classes/provashell

OK_=0
ERR_=1
FAIL_=3
PARAMS_=4
BADTEST_=5

err_() {
	printf %s\\n "$@"
	exit 1
}


echo '------------- Testing assertTrue -------------'

$(assertTrue 2>/dev/null)
[ $? -ne "$PARAMS_" ] && err_ 'assertTrue without params should be an error'

assertTrue `[ 0 -eq 0 ]; echo $?`
[ $? -ne "$OK_" ] && err_ 'assertTrue a true statement should not fail'

assertTrue `echo 0`
[ $? -ne "$OK_" ] && err_ 'assertTrue a true statement should not fail'

assertTrue `echo 1` >/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertTrue a false statement should fail'

assertTrue 'message' `[ 0 -eq 0 ]; echo $?`
[ $? -ne $OK_ ] && err_ 'assertTrue a true statement with a message should not fail'

m_=$(assertTrue 'message' $([ 0 -eq 1 ]; echo $?) )
[ "$m_" != 'message' ] && err_ 'assertTrue a false statement should fail with message'


echo '------------ Testing assertFalse -------------'

$(assertFalse 2>/dev/null)
[ $? -ne $PARAMS_ ] && err_ 'assertFalse without params should be an error'

assertFalse `echo 1`
[ $? -ne $OK_ ] && err_ 'assertFalse a false statement should not fail'

assertFalse `[ 0 -eq 0 ]; echo $?` >/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertFalse a true statement should fail'

assertFalse 'message' `[ 0 -eq 1 ]; echo $?`
[ $? -ne $OK_ ] && err_ 'assertFalse a false statement with a message should not fail'

m_=$(assertFalse 'message' $([ 0 -eq 0 ]; echo $?))
[ "$m_" != 'message' ] && err_ 'assertFalse a true statement should fail with message'


echo '-------------- Testing assertZ ---------------'

$(assertZ 2>/dev/null)
[ $? -ne $PARAMS_ ] && err_ 'assertZ without params should be an error'

assertZ ''
[ $? -ne $OK_ ] && err_ 'assertZ an empty string should not fail'

assertZ 'a' >/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertZ a non empty string should fail'

m_=$(assertZ 'message' 'nonempty')
[ "$m_" != 'message' ] && err_ 'assertZ a nonempty string should fail with message'


echo '-------------- Testing assertN ---------------'

$(assertN 2>/dev/null)
[ $? -ne $PARAMS_ ] && err_ 'assertN without params should be an error'

assertN '' >/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertN an empty string should fail'

assertN 'a'
[ $? -ne $OK_ ] && err_ 'assertN a non empty string should not fail'

m_=$(assertN 'message' '')
[ "$m_" != 'message' ] && err_ 'assertN an empty string should fail with message'

exit 0
