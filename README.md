lute
====

Light-weight Unit Test Evaluator for MATLAB.

Lute treats each call to one of its expect_* functions as test case. This seems
a little awkward at first, but allows easy, boilerplate-free testing in MATLAB.

A Lute test suite is a single MATLAB function or script file called test_*.m.
Therein, make your initialization, call a succession of expect_*, and that's it.
Execute your suite by using single_suite(), or all suites in a directory by
using all_suites(). These functions will give you an overview as well as details
about any errors or failures. Standard output will not show on the MATLAB
console, but will be collected for later display.

Lute happily omits these features:
  - explicit test case names
  - nasty test source parsing in order to get a handle on subfunctions
  - jUnit XML generation


Existing functions
------------------

- all_suites    Execute all test suites consecutively.
- single_suite  Execute a single test suite.

- expect_from   Wrap function call to assert several output arguments.
- expect_error  Wrap function call to assert error.


Mutual dependencies
-------------------

These dependencies exist:

- expect_error --> testcase_struct
  expect_from
  testcase_collector
  single_suite
- expect_error --> testcase_collector
  expect_from
  single_suite
- all_suites --> single_suite


TODO
----

- handle testsuite errors outside expect_* calls cleverly
- improve report of error and failure details
- display some rendition of the function string as test case name
- calculate the file and line where a failed expect_* call was made from