#!/bin/bash

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
[ $? -ne $BADTEST_ ] && echo 'assertTrue with empty test should fail' && exit 1

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
[ $? -ne $BADTEST_ ] && echo 'assertFalse with empty test should fail' && exit 1

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

assertEq 0 0
[ $? -ne $OK_ ] && echo 'assertEq two identical elements should not fail' && exit 1

assertEq 0 1 &>/dev/null
[ $? -ne $FAIL_ ] && echo 'assertEq two different elements should fail' && exit 1

assertEq 'message' 0 0
[ $? -ne $OK_ ] && echo 'assertEq two identical elements with a message should not fail' && exit 1

m_=$(assertEq 'message' 0 1)
[ "$m_" != 'message' ] && echo 'assertEq two different elements should fail with message' && exit 1


echo '------------ Testing assertEquals ------------'

assertEquals &>/dev/null
[ $? -ne $PARAMS_ ] && echo 'assertEquals without params should fail' && exit 1 

assertEquals aa aa
[ $? -ne $OK_ ] && echo 'assertEquals two identical elements should not fail' && exit 1

assertEquals aa ab &>/dev/null
[ $? -ne $FAIL_ ] && echo 'assertEquals two different elements should fail' && exit 1

assertEquals 'message' aa aa
[ $? -ne $OK_ ] && echo 'assertEquals two identical elements with a message should not fail' && exit 1

m_=$(assertEquals 'message' aa ab)
[ "$m_" != 'message' ] && echo 'assertEquals two different elements should fail with message' && exit 1

exit 0

