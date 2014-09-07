#!/usr/bin/env bash

# load without running any tests
PS_SKIP_ALL=1 . classes/provashell

OK_=0
ERR_=1
FAIL_=3
PARAMS_=4
BADTEST_=5

err_() {
	echo "$1"
	exit 1
}


echo '------------- Testing assertTrue -------------'

assertTrue &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertTrue without params should fail'

assertTrue '' &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertTrue with empty test should fail'

assertTrue '[ 0 -eq 0 ]'
[ $? -ne $OK_ ] && err_ 'assertTrue a true statement should not fail'

assertTrue '[ 0 -eq 1 ]' &>/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertTrue a false statement should fail'

assertTrue 'message' '[ 0 -eq 0 ]'
[ $? -ne $OK_ ] && err_ 'assertTrue a true statement with a message should not fail'

m_=$(assertTrue 'message' '[ 0 -eq 1 ]')
[ "$m_" != 'message' ] && err_ 'assertTrue a false statement should fail with message'


echo '------------ Testing assertFalse -------------'

assertFalse &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertFalse without params should fail'

assertFalse '' &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertFalse with empty test should fail'

assertFalse '[ 0 -eq 1 ]'
[ $? -ne $OK_ ] && err_ 'assertFalse a false statement should not fail'

assertFalse '[ 0 -eq 0 ]' &>/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertFalse a true statement should fail'

assertFalse 'message' '[ 0 -eq 1 ]'
[ $? -ne $OK_ ] && err_ 'assertFalse a false statement with a message should not fail'

m_=$(assertFalse 'message' '[ 0 -eq 0 ]')
[ "$m_" != 'message' ] && err_ 'assertFalse a true statement should fail with message'


echo '------------ Testing assertZ -------------'

assertZ &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertZ without params should fail'

assertZ ''
[ $? -ne $OK_ ] && err_ 'assertZ an empty string should not fail'

assertZ 'a' &>/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertZ a non empty string should fail'


echo '------------ Testing assertN -------------'

assertN &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertN without params should fail'

assertZ ''
[ $? -ne $FAIL_ ] && err_ 'assertN an empty string should fail'

assertZ 'a' &>/dev/null
[ $? -ne $OK_ ] && err_ 'assertN a non empty string should not fail'



exit 0