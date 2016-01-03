## provashell

### Bash (and shell) unit testing for the masses

_provashell_ is a simple bash unit testing library that employs annotations and
is completely self-contained on one file. It should work on most POSIX shells as
any bash-specific functionality has been avoided (it has been tested on bash, 
dash and zsh).


## Getting Started

Usage is relatively straightfoward (using latest release version):

```Shell
curl -O 'https://raw.githubusercontent.com/danigiri/provashell/provashell-2.2.0/src/main/sh/provashell'
cat > test.sh <<EOF
#!/bin/bash
#@Test
foo1() {
	assertTrue `[ 0 -eq 0 ]; echo $?`
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

Downloading the script itself is enough as _provashell_ has no dependencies 
(example downloads the 2.2.0 release).
```Shell
curl -O 'https://raw.githubusercontent.com/danigiri/provashell/provashell-2.2.0/src/main/sh/provashell'
```

### Using git

Just clone the repository and you are ready to go, the script itself is in
`src/main/bash/provashell`

```Shell
git clone https://github.com/danigiri/provashell.git
ls -l src/main/bash/provashell
```

You can work on the `master` itself as in the previous example or pick the release of your choosing with
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
		assertTrue `echo 0`
		assertEq 'Zeroes should be equal' 0 0
	}

	fooTestNotRunning() {
		assertTrue `[ 0 -eq 0 ]; echo $?`
	}

	. provashell
``` 


## API Reference

The following annotations are defined:

####	#@BeforeScript
Runs the function once before any tests are run. 
	
####	#@AfterScript
Runs the function once after all tests are run.
	
####	#@Before
Runs the function before each test is run.
	
####	#@After
Runs the function after each test is run.

The last function annotated as such is the one used in every case (for instance,
if two `@BeforeScript` functions are declared, only the last one will be used.
	 
####	#@Test
Identifies the function as a test and it is run once by provashell, note that 
test order in the script is respected.

The following assertions are defined:

####	assertTrue ['message'] <expression expected to be true>
	
Checks if the content equals true (that is, `0`), otherwise it prints 
`message` to STDOUT. To evaluate an expression or command, this shortcut can be 
used: `assertTrue $(command; echo $?)` or even custom test expressions such as: 
`assertTrue $([ 0 -eq 0 ]; echo $?)` which comes in handy if the test expression
in question is not provided in _provashell_. Note that if no message argument is
passed a default one will be output.
	
####	assertFalse ['message'] <expression expected to be false>
	
Equivalent to `assertTrue` but expecting the expression to evaluate to false.
	
####	asserEq ['message'] <expected number> <actual number>
	
Assertion testing the equality of two numbers using the `-eq` test.

####	assertNe ['message'] <not expected number> <actual number>
	
Assertion testing the inequality of two numbers using the `-ne` test. Not 
terribly useful in most tests but here we go.

####	assertEquals ['message'] <'expected string'> <'actual string'>
	
Assertion testing the equality of two strings using `=`

####	assertNotEquals ['message'] <'expected string'> <'actual string'>
	
Assertion testing the inequality of two strings using `!=`

####	assertZ ['message'] <'string expected to be empty'>
	
Assertion checking if the input string is empty (using `-z`).

####	assertN ['message'] <'string expected to be nonempty'>
	
Assertion checking if the input string is not empty (anything that gets `-z` to
be false).

### Helper assertion functions

These are complimentary asserts that are completely optional and just provided
for convenience.

####	assertPing ['message'] <'IP or DNS entry'>
	
Ping the specified address with a single packet with default timeout. Will fail
if the IP cannot be reached or the DNS entry does not resolve. This test 
currently attaches to the default network interface.

####	assertTCPConnect ['message'] <'IP or DNS entry'> \<port\>
	
Connect to the specified address and port using netcat -z (zero I/O flag). 
Will fail if the IP cannot be reached or the DNS entry does not resolve. This 
test currently attaches to the default network interface.

####	assertDNSLookup ['message'] <'DNS server IP'> <'DNS entry'>
	
Try to resolve the DNS entry using the specified DNS server. 
Will fail if the nameserver cannot be reached or the DNS entry does not resolve
using that specified nameserver. This test currently attaches to the default 
network interface.

####	assertPublicDNSLookup ['message'] <'DNS entry'>
	
Try to resolve the DNS entry using a public DNS server (namely google's). 
Will fail if the google nameserver cannot be reached or the DNS entry does not 
resolve corectly. This test currently attaches to the default network interface.


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


The following utility methods are also available:

####	startSkippingTests
	
Prevents assertions from being cheked. This means that the test expressions 
themselves will not be evaluated at all. Input checking _will still be done_ so
clear errors such as are not passing any input to tests are not masked by 
skipping.

####	stopSkippingTests

Behaviour is back to assertions being checked.

####	isSkippingTests

Returns `0` if _provashell_ is skipping tests 

### Environment variables

These environment variables modify the behaviour of _provashell_ if they are 
defined with any nonempty value:

####	PS_VERBOSE=<whatever>

Adds some diagnostics messages to output, such as test functions being executed.

####	PS_TRACE=<whatever>

Adds even more diagnostics messages to output. For instance it outputs which
assertions are actually being executed.

####	PS_QUIET=<whatever>

Supresses _provashell_'s normal output (for now the end message stating how 
many tests have been ran). Overrides `PS_VERBOSE` and `PS_TRACE`.


####	PS_EXIT_ON_FAIL=<whatever>

If a test fails it will exit with (3). Useful to stop execution of build 
pipelines.

####	PS_FAILS_TO_STDERR=<whatever>

Failure messages are output to STDERR instead of STDOUT (which is the default).

####	PS_NET_TIMEOUT=<seconds>

Number of seconds of timeout for network asserts (default is 1 second).


## A note on security

_provashell_ previously used `eval` for added flexibility and to support
running expressions directly. Which meant that if expressions included 
user-supplied input there was a very real security risk. Now the library 
does not run `eval` anymore so it should now be much more secure (yay!). 
You should check the source code in any case and see for yourself.

The only code actually ran by the testing library is the set of setup functions 
(@BeforeScript, @AfterScript, @Before, @After and the @Test's themselves) as
expected. If these functions include user-supplied input then use at your own
risk.

## Contributing

Absolutely welcome! Just do a pull request :)

## Release notes

2.2.0 - Added network timeout environment variable and assert trace support
2.1.1 - Fixed an assertN, assertZ bug where the assertion did not work when having a message (thx to @jroimartin)

## License

Copyright 2016 Daniel Giribet <dani - calidos.cat>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
