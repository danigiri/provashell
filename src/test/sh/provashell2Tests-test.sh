#!/usr/bin/env bash

#@BeforeScript
init() {
	echo 'onetimeSetUp ---------------------------------'
}

#@AfterScript
end() {
	echo 'onetimeTearDown ------------------------------'
}

#@Before
setUp() {
	echo '------------------- before -------------------'
}

#@After
tearDown() {
	echo '------------------- after --------------------'
}

#@Test
foo1() {
	echo '------------------- foo1 ---------------------'
	assertTrue `[ 0 -eq 0 ]; echo $?`
}

fooNotRunning() {
	assertTrue `[ 0 -eq 0 ]; echo $?`
}

#@Test
foo3 () {
	echo '------------------- foo3 ---------------------'
	assertTrue `[ 0 -eq 0 ]; echo $?`
}

#@Test
foo4 () {
	echo '------------------- foo4 ---------------------'
	assertTrue `[ 0 -eq 0 ]; echo $?`
}

# Also works on bash-style declaration
#@Test
function foo5 {
	echo '------------------- foo5 ---------------------'
	assertTrue `[ 0 -eq 0 ]; echo $?`;
}

#@Test
foo6() {
	echo '------------------- foo6 ---------------------'
	startSkippingTests
	assertTrue `[ 0 -eq 0 ]; echo $?`
	stopSkippingTests
}


echo '----------- Running tests functions ----------'

. classes/provashell

assertEq "Got wrong number of tests ($PS_TESTS instead of 5)" 5 "$PS_TESTS"
assertEq "Got wrong number of asserts ($PS_ASSERTS instead of 4)" 4 "$PS_ASSERTS"
