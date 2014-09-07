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


echo '-------------- Testing assertEq --------------'

assertEq &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertEq without params should fail' 

assertEq 0 &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertEq with only one param should fail' 

assertEq 0 0
[ $? -ne $OK_ ] && err_ 'assertEq two identical numbers should not fail'

assertEq 1 01
[ $? -ne $OK_ ] && err_ 'assertEq two identical numbers should not fail'

assertEq 0 1 &>/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertEq two different numbers should fail'

assertEq 'message' 0 0
[ $? -ne $OK_ ] && err_ 'assertEq two identical numbers with a message should not fail'

m_=$(assertEq 'message' 0 1)
[ "$m_" != 'message' ] && err_ 'assertEq two different numbers should fail with message'


echo '------------ Testing assertNe ------------'

assertNe &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertNe without params should fail'

assertNe 0 &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertNe with only one param should fail'

assertNe 1 01 &>/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertNe two identical numbers should fail'

assertNe 0 0 &>/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertNe two identical numbers should fail'

assertNe 0 1
[ $? -ne $OK_ ] && err_ 'assertNe two different numbers should not fail'

assertNe 'message' 0 1
[ $? -ne $OK_ ] && err_ 'assertNe two different numbers with a message should not fail'

m_=$(assertNe 'message' 0 0)
[ "$m_" != 'message' ] && err_ 'assertNe two identical numbers should fail with message'


echo '------------ Testing assertEquals ------------'

assertEquals &>/dev/null
[ $? -ne $PARAMS_ ] && err_ 'assertEquals without params should fail'

assertEquals aa aa
[ $? -ne $OK_ ] && err_ 'assertEquals two identical strings should not fail'

assertEquals aa ab &>/dev/null
[ $? -ne $FAIL_ ] && err_ 'assertEquals two different strings should fail'

assertEquals 'message' aa aa
[ $? -ne $OK_ ] && err_ 'assertEquals two identical strings with a message should not fail'

m_=$(assertEquals 'message' aa ab)
[ "$m_" != 'message' ] && err_ 'assertEquals two different strings should fail with message'

exit 0