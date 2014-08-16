#!/usr/bin/env bash

#@BeforeScript
init() {
	echo 'Preparation function: this just runs one time before all tests'
}

#@AfterScript
end() {
	echo 'Cleanup function: this just runs one time after all tests'
}

#@Before
setUp() {
	echo 'Runs before each test'
}

#@After
tearDown() {
	echo 'Runs after each test'
}

#@Test
foo() {
	assertTrue '[ 0 -eq 0 ]'
	assertEq 'Zeroes should be equal' 0 0
}

fooNotRunning() {
	assertTrue '[ 0 -eq 0 ]'
}

. classes/provashell
