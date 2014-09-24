## provashell

### Bash (and shell) unit testing for the masses

_provashell_ is a simple bash unit testing library that employs annotations and
is completely self-contained on one file. It should work on most if not all
POSIX shells as  bash-specific functionality has been avoided.


## Getting Started

Usage is relatively straightfoward (using master version):

```Shell
curl -sO 'https://raw.githubusercontent.com/danigiri/provashell/provashell-1.0.0/src/main/bash/provashell'
cat > test.sh <<EOF
#!/bin/bash
#@Test
foo1() {
    assertTrue '[ 0 -eq 0 ]'
    assertEq 0 0
    assertEquals foo foo
}

. ./provashell
EOF
chmod a+x test.sh
./test.sh
```


## Motivation

I was looking for an Apache2.0-licensed shell testing library that was 
relatively simple and had no complex dependencies. Could not find anything so I 
just cooked something together. There are of course plenty of great shell 
testing libraries [out there!](http://stackoverflow.com/questions/1339416/unit-testing-bash-scripts)


## Installation

There are three ways to get the script:

### The quick n' dirty

Downloading the script itself is enough as _provashell_ has no dependencies (example downloads the 1.0.0 release).
```Shell
curl -O 'https://raw.githubusercontent.com/danigiri/provashell/provashell-1.0.0/src/main/bash/provashell'
```

### Using git

Just clone the repository and you are ready to go, the script itself is in
`src/main/bash/provashell`

```Shell
git clone https://github.com/danigiri/provashell.git
ls -l src/main/bash/provashell
```

You can work on the `master` itself or pick the release of your choosing with
`git tag -l` 

### Building a deployable rpm using Maven

This runs _provashell_'s tests and creates a rpm that that installs the script 
on `/opt/provashell/provashell` though the RPM itself is relocatable. The rpm
file can be found at `target/rpm/provashell/RPMS/noarch/provashell`. 
To just run the tests and not build the RPM do `mvn test`.

Example of building `master`:
```Shell
git clone https://github.com/danigiri/provashell.git
mvn package
find target/rpm -name '*.rpm' -exec rpm -ilv -qp '{}' \;
```
This method requires Java and [Apache Maven!](http://maven.apache.org) to be 
installed, as well as the `rpmbuild` tool (which can be found in the `rpm-build` 
package on CentOS or similar packages in other distributions).



## Usage

_provashell_ employs annotations to run the tests, preparation and cleanup 
functions. Annotations are linkes like `#@Annotation`, without any spaces or tabs before 
the comment or in the annotation itself. The annotation line must come just
before the affected function, with no extra lines in between.

A sample test script looks like this:

```Shell
	#!/bin/bash

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

	fooTestNotRunning() {
		assertTrue '[ 0 -eq 0 ]'
	}

	. provashell
``` 


## API Reference

The following annotations are defined:

####	#@BeforeScript
Runs the function once before any tests are run
	
####	#@AfterScript
Runs the function once after all tests are run
	
####	#@Before
Runs the function before each test is run
	
####	#@After
Runs the function after each test is run
	 
####	#@Test
Identifies the function as a test and it is run once by provashell, note that 
test order in the script is respected 	

The following assertions are defined:

####	assertTrue ['message'] <'expression expected to be true'>
	
Checks if the expression evaluates to true, otherwise it prints `message` to 
STDERR (or a default one if no message is passed). The expression must be a 
shell test one, usually `test`, `[ ]`, extended test `[[ ]]` in the case of bash
or testable constructs such as `(( ))` or `let`. Therefore, calls such as
`assertTrue "[ -e $file ]"` or `assertTrue 'Message' "test -z '$v'"` are valid
whereas `assertTrue '0 -eq 0' is not. If no message argument is passed a
default one will be used if the assertion does not validate correctly.
	
####	assertFalse ['message'] <'expression expected to be false'>
	
Equivalent to `assertTrue` but expecting the expression to evaluate to false.
	
####	asserEq ['message'] <expected number> <actual number>
	
Assertion testing the equality of two numbers using the `-eq` test.

####	assertNe ['message'] <not expected number> <actual number>
	
Assertion testing the inequality of two numbers using the `-ne` test. Not 
terribly useful in most tests but here we go.

####	assertEquals ['message'] <'expected string'> <'actual string'>
	
Assertion testing the equality of two strings using `=`

####	assertZ ['message'] <'string expected to be empty'>
	
Assertion checking if the input string is empty (using `-z`).

####	assertN ['message'] <'string expected to be nonempty'>
	
Assertion checking if the input string is not empty (anything that gets `-z` to
be false).
	
	
	
The following utility methods are also available:

####	startSkippingTests
	
Prevents assertions from being cheked. This means that the test expressions 
themselves will not be evaluated at all. Input checking _will still be done_ so
clear errors such as are not passing any input to tests are not masked by 
skipping.

####	stopSkippingTests

Behaviour is back to assertions being checked.


### Environment variables

Two environment variables modify the behaviour of _provashell_ if they are 
defined with any value

####	export PS_VERBOSE=1

Adds extra diagnostics messages to output. For instance it outputs which
assertions are actually being executed.

####	export PS_QUIET=1

Supresses _provashell_'s normal output (for now the end message stating how 
many tests have been ran). Overrides `PS_VERBOSE`.


### Assert function return codes

The following codes are returned by assertion functions:

####	0
	
Assertion evaluated as expected (ie. the expression was expected to be true and
it was).

####	1

General problem with the test.

####	3

Assertion did not evaluate as expected (ie. the expression was expected to be 
true and it evaluated to false).

####	4

Incorrect number of parameters passed to the assertion (empty strings like `''`
are considered correct input parameters).

####	5

The expression passed to the assertion was not a valid expression.


## Contributing

Absolutely welcome! Just do a pull request :)


## License

Copyright 2014 Daniel Giribet <dani - calidos.cat>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
