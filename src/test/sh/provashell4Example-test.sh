#!/usr/bin/env bash


countAs() {

	c=$(printf %s "$1" | sed 's/[^a]*//g' | tr -d '\n' | wc -m)
	return "$c"

}


#@Test
countAsNormally() {

	countAs 'a'
	assertEq "Does not count one 'a' in a string with only one 'a'" 1 $?

	countAs 'b'
	assertEq "Does not count zero a's in a string with no a's" 0 $?

	countAs 'aaa'
	assertEq "Does not count three straight a's when they are there" 3 $?

	countAs 'abab'
	assertEq "Does not count two a's in a string when they are there" 2 $?

}

#set -x

#@Test
countAsEdgeCases() {
	
	countAs ''
	assertEq 'Does not count empty string correctly' 0 $?
	
}


. classes/provashell
#set +x
