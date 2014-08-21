#!/usr/bin/env bash

# load without running any tests
PS_SKIP_ALL=1 . classes/provashell

OK_=0
ERR_=1
FAIL_=3
PARAMS_=4
BADTEST_=5


echo '------------- Testing assertTrue -------------'

assertTrue &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertTrue without params should fail' && exit 1 

assertTrue '' &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertTrue with empty test should fail' && exit 1

assertTrue '[ 0 -eq 0 ]'
[ $? -ne $OK_ ] && echo 'assertTrue a true statement should not fail' && exit 1

assertTrue '[ 0 -eq 1 ]' &>/dev/null
[ $? -ne $FAIL_ ] && echo 'assertTrue a false statement should fail' && exit 1

assertTrue 'message' '[ 0 -eq 0 ]'
[ $? -ne $OK_ ] && echo 'assertTrue a true statement with a message should not fail' && exit 1

m_=$(assertTrue 'message' '[ 0 -eq 1 ]')
[ "$m_" != 'message' ] && echo 'assertTrue a false statement should fail with message' && exit 1


echo '------------ Testing assertFalse -------------'

assertFalse &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertFalse without params should fail' && exit 1 

assertFalse '' &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertFalse with empty test should fail' && exit 1

assertFalse '[ 0 -eq 1 ]'
[ $? -ne $OK_ ] && echo 'assertFalse a false statement should not fail' && exit 1

assertFalse '[ 0 -eq 0 ]' &>/dev/null
[ $? -ne $FAIL_ ] && echo 'assertFalse a true statement should fail' && exit 1

assertFalse 'message' '[ 0 -eq 1 ]'
[ $? -ne $OK_ ] && echo 'assertFalse a false statement with a message should not fail' && exit 1

m_=$(assertFalse 'message' '[ 0 -eq 0 ]')
[ "$m_" != 'message' ] && echo 'assertFalse a true statement should fail with message' && exit 1


echo '-------------- Testing assertEq --------------'

assertEq &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertEq without params should fail' && exit 1 

assertEq 0 &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertEq with only one param should fail' && exit 1 

assertEq 0 0
[ $? -ne $OK_ ] && echo 'assertEq two identical numbers should not fail' && exit 1

assertEq 1 01
[ $? -ne $OK_ ] && echo 'assertEq two identical numbers should not fail' && exit 1

assertEq 0 1 &>/dev/null
[ $? -ne $FAIL_ ] && echo 'assertEq two different numbers should fail' && exit 1

assertEq 'message' 0 0
[ $? -ne $OK_ ] && echo 'assertEq two identical numbers with a message should not fail' && exit 1

m_=$(assertEq 'message' 0 1)
[ "$m_" != 'message' ] && echo 'assertEq two different numbers should fail with message' && exit 1


echo '------------ Testing assertNe ------------'

assertNe &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertNe without params should fail' && exit 1 

assertNe 0 &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertNe with only one param should fail' && exit 1 

assertNe 1 01 &>/dev/null
[ $? -ne $FAIL_ ] && echo 'assertNe two identical numbers should fail' && exit 1

assertNe 0 0 &>/dev/null
[ $? -ne $FAIL_ ] && echo 'assertNe two identical numbers should fail' && exit 1

assertNe 0 1
[ $? -ne $OK_ ] && echo 'assertNe two different numbers should not fail' && exit 1

assertNe 'message' 0 1
[ $? -ne $OK_ ] && echo 'assertNe two different numbers with a message should not fail' && exit 1

m_=$(assertNe 'message' 0 0)
[ "$m_" != 'message' ] && echo 'assertNe two identical numbers should fail with message' && exit 1


echo '------------ Testing assertEquals ------------'

assertEquals &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertEquals without params should fail' && exit 1 

assertEquals aa aa
[ $? -ne $OK_ ] && echo 'assertEquals two identical strings should not fail' && exit 1

assertEquals aa ab &>/dev/null
[ $? -ne $FAIL_ ] && echo 'assertEquals two different strings should fail' && exit 1

assertEquals 'message' aa aa
[ $? -ne $OK_ ] && echo 'assertEquals two identical strings with a message should not fail' && exit 1

m_=$(assertEquals 'message' aa ab)
[ "$m_" != 'message' ] && echo 'assertEquals two different strings should fail with message' && exit 1

exit 0

