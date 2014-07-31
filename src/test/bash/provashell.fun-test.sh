#!/bin/bash

. classes/provashell.fun

OK_=0
ERR_=1
FAIL_=3
PARAMS_=4
BADTEST_=5


echo 'Testing assertTrue'

assertTrue
[ $? -ne $PARAMS_ ] && echo 'assertTrue without params should fail' && exit 1 

assertTrue ''
[ $? -ne $BADTEST_ ] && echo 'assertTrue with empty test should fail' && exit 1

assertTrue '[ 0 -eq 0 ]'
[ $? -ne $OK_ ] && echo 'assertTrue a true statement should not fail' && exit 1

assertTrue '[ 0 -eq 1 ]'
[ $? -ne $FAIL_ ] && echo 'assertTrue a false statement should fail' && exit 1

assertTrue 'message' '[ 0 -eq 0 ]'
[ $? -ne $OK_ ] && echo 'assertTrue a true statement with a message should not fail' && exit 1

m_=$(assertTrue 'message' '[ 0 -eq 1 ]')
[ "$m_" != 'message' ] && echo 'assertTrue a false statement should fail with message' && exit 1


echo 'Testing assertFalse'

assertFalse
[ $? -ne $PARAMS_ ] && echo 'assertFalse without params should fail' && exit 1 

assertFalse ''
[ $? -ne $BADTEST_ ] && echo 'assertFalse with empty test should fail' && exit 1

assertFalse '[ 0 -eq 1 ]'
[ $? -ne $OK_ ] && echo 'assertFalse a false statement should not fail' && exit 1

assertFalse '[ 0 -eq 0 ]'
[ $? -ne $FAIL_ ] && echo 'assertFalse a true statement should fail' && exit 1

assertFalse 'message' '[ 0 -eq 1 ]'
[ $? -ne $OK_ ] && echo 'assertFalse a false statement with a message should not fail' && exit 1

m_=$(assertFalse 'message' '[ 0 -eq 0 ]')
[ "$m_" != 'message' ] && echo 'assertFalse a true statement should fail with message' && exit 1


echo 'Testing assertEq'

assertEq
[ $? -ne $PARAMS_ ] && echo 'assertEq without params should fail' && exit 1 

assertEq 0 0
[ $? -ne $OK_ ] && echo 'assertEq two identical elements should not fail' && exit 1

assertEq 0 1
[ $? -ne $FAIL_ ] && echo 'assertEq two different elements should fail' && exit 1

assertEq 'message' 0 0
[ $? -ne $OK_ ] && echo 'assertEq two identical elements with a message should not fail' && exit 1


set -x
set +x

#m_=$(assertEq 'message' 0 1)
#[ "$m_" != 'message' ] && echo 'assertEq two different elements should fail with message' && exit 1

