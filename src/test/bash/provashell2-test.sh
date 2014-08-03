#!/bin/bash

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
	echo '------------------- setup --------------------'
}

#@After
tearDown() {
	echo '------------------- after --------------------'
}

#@Test
foo1() {
	echo '------------------- foo1 ---------------------'
}

fooNotRunning() {
	echo foo2
}

#@Test
foo3 () {
	echo '------------------- foo3 ---------------------'
}

#@Test
foo4 () {
	echo '------------------- foo4 ---------------------'
}

#@Test
function foo5 {
	echo '------------------- foo5 ---------------------'
}


echo '----------- Running tests functions ----------'

. classes/provashell