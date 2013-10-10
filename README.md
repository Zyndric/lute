lute
====

Light-weight Unit Test Evaluator for MATLAB.

Lute treats each call to one of its expect_* functions as test case. This seems
a little awkward at first, but allows easy, boilerplate-free testing in MATLAB.
A Lute test suite is a single MATLAB function or script file called test_*.m.
Therein, make your initialization, call a succession of expect_*, and that's it.

Execute your suite by calling it directly, e.g. >> test_myfun.
Execute all suites in a directory by using all_suites().
These functions will give you an overview as well as details
about any errors or failures. Standard output will not show on the MATLAB
console, but will be collected for later display. If a test suite has an error
outside an expect_* call, the execution flow will be interrupted. Go fix your
setup code.

Lute happily omits these features:
  - explicit test case names
  - nasty test source parsing in order to get a handle on subfunctions
  - jUnit XML generation


Existing functions
------------------

- all_suites    Execute all test suites consecutively.
- expect_from   Wrap function call to assert several output arguments.
- expect_error  Wrap function call to assert error.


Mutual dependencies
-------------------

These dependencies exist:

                   expect_error --> |
                   expect_from  --> | testcase_collector --> testcase_struct
    all_suites --> single_suite --> |


TODO
----

- calculate the file and line where a failed expect_* call was made from
- Fix: all_suites fails when no test cases are found
- Fix: if expect_from is called with arguments, but the function returns less
  arguments, a difficult to understand error message results
- Test lute itself
