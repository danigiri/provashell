# PROVASHELL - Shell unit testing for the masses

#  Copyright 2014 Daniel Giribet <dani - calidos.cat>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# CONSTANTS
PASSED_=0
ERR_=1
NOTPASSED_=3
ERR_PARAMS_=4
ERR_TESTNOTVALID_=5

# ENVIRONMENT VARIABLES

SKIPPING_=


# INTERNAL HELPER FUNCTIONS

################################################################################
# Display message on STDERR
echoerr_() { echo "$@" 1>&2; }


################################################################################
# echo the annotated <file> <annotation name>
findAnnotatedFunctions_() {

	local file_="$1"
	local annotation_="#$2$"
	local functions_=()

	# list all functions, remove the annotations themselves, remove the grep separator '--'
	# and delete '() {' so we're only left with the function names
	# also handle 'function foo }' style declaration
	grep --after-context=1 "$annotation_" "$file_" | \
	grep -v "$annotation_" | \
	grep -v -- '--'| \
	sed -E 's/\s*\(\)\s*//g' | sed 's/{//g' | \
	sed -E 's/function[\ \t]//g'
}


assert_() {


	#TODO: handle skipping
	[ -n "$SKIPPING_" ] && return 0

	local expectingTrue_="$1"
	local test_="$2"

	if [ -z "$test_" ]; then
		return $ERR_TESTNOTVALID_
	fi

	local evaluatedToTrue_=
	local eval_="if $test_; then evaluatedToTrue_=true; else evaluatedToTrue_='false'; fi"
	eval "$eval_"
	if [ "$evaluatedToTrue_" == 'true' ]; then
		if [ "$expectingTrue_" == 'false' ]; then
			return $NOTPASSED_		
		fi
	else 
		if [ "$expectingTrue_" = 'true' ]; then
			return $NOTPASSED_		
		fi	
	fi
	
	return $PASSED_
	
}


printTestResults_() {

	local result_=$1
	local testName_="$2"
	local message_="$3"
	if [ $result_ -eq $ERR_TESTNOTVALID_ ]; then
		echoerr_ "$testName_: Empty test statement"
	elif [ $result_ -eq $NOTPASSED_ ]; then
		echo "$message_"
	elif [ $result_ -eq $ERR_ ]; then
		echoerr_ "$testName_: Unknown problem running test with parameters: '$@'"
	fi

}


################################################################################ 
startSkippingTests() {
	SKIPPING__=1
}


################################################################################
stopSkippingTests() {
	SKIPPING__=
}


################################################################################ 
assertTrue() {
	
	local test_=''
	local message_=''
	
	if [ $# -eq 1 ]; then
		test_="$1"
		message_="assertTrue failed: '$test_' evaluates to false"
	elif [ $# -eq 2 ]; then
		message_="$1"
		test_="$2"
	else
		echoerr_ "assertTrue: Wrong number of parameters '$#'"
		return $ERR_PARAMS_
	fi
	
	assert_ 'true' "$test_"
	local result_=$?
	printTestResults_ $result_ 'assertTrue' "$message_"

	return $result_
	
}


################################################################################ 
assertFalse() {

	local test_=''
	local message_=''
	
	if [ $# -eq 1 ]; then
		test_="$1"
		message_="assertFalse failed: '$test_' evaluates to true"
	elif [ $# -eq 2 ]; then
		message_="$1"
		test_="$2"
	else
		echoerr_ "assertFalse: Wrong number of parameters '$#'"
		return $ERR_PARAMS_
	fi
	
	assert_ 'false' "$test_"
	local result_=$?
	printTestResults_ $result_ 'assertFalse' "$message_"

	return $result_
	
}


################################################################################ 
# expected actual [ message ]
assertEq() {

	local test_=''
	local message_=''
	
	if [ $# -eq 2 ]; then
		test_="[ $1 -eq $2 ]"
		message_="assertEq failed: expecting $1 and got $2"
	elif [ $# -eq 3 ]; then
		message_="$1"
		test_="[ $2 -eq $3 ]"
	else
		echoerr_ "assertEq: Wrong number of parameters '$#'"
		return $ERR_PARAMS_
	fi
	
	assert_ 'true' "$test_"
	local result_=$?
	printTestResults_ $result_ 'assertEq' "$message_"

	return $result_
	
}


################################################################################ 
assertEquals() {

	local test_=''
	local message_=''
	
	if [ $# -eq 2 ]; then
		test_="[ '$1' == '$2' ]"
		message_="assertEquals failed: expecting $1 and got $2"
	elif [ $# -eq 3 ]; then
		message_="$1"
		test_="[ '$2' == '$3' ]"
	else
		echoerr_ "assertEquals: Wrong number of parameters '$#'"
		return $ERR_PARAMS_
	fi
	
	assert_ 'true' "$test_"
	local result_=$?
	printTestResults_ $result_ 'assertEquals' "$message_"

	return $result_
	

}

#assertEquals() {
#
#}


