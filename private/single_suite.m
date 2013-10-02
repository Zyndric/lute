% Execute a single test suite.
% Give the suite name as first argument.
% You may give any number of directories as following arguments that will be
% temporarily added to the path.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function suite_info = single_suite(name, paths)

    if nargin < 2, paths = {}; end

    % init proper suite_info structure
    suite_info = struct(...
        'name', name, ...
        'testcase_info', testcase_struct(), ...
        'testcases', 0, ...
        'failures', 0, ...
        'errors', 0, ...
        'time', 0, ...
        'stdouts', {{}} ...
        );

    % save path state and add any dependency dirs the user specified
    oldpath = path;
    if ~isempty(paths)
        addpath(paths{:});
    end

    % reset suite information
    testcase_collector('reset');

    % prevent expect_* from disping
    suppress_output(true);
    
    suite_fail = false;
    try
        % standard output will show on the MATLAB console in order to let the
        % user debug
        eval(name);
    catch err
        % there was an error in the users test function but outside any
        % expect_* call
        suite_fail = true;

        % add testcase for user to examine the error
        testcase_collector(testcase_struct( ...
            name, ...   % test case name
            false, ...  % is not a failure
            true, ...   % but an error
            err.getReport()));
    end

    % allow expect_* disping again
    suppress_output(false);

    % collect suite information
    suite_info.testcase_info = testcase_collector('reset');
    suite_info.testcases = numel(suite_info.testcase_info);
    suite_info.failures = sum(double([suite_info.testcase_info.fail]));
    suite_info.errors = sum(double([suite_info.testcase_info.error]));
    suite_info.time = sum(double([suite_info.testcase_info.time]));
    suite_info.suite_fail = suite_fail;

    % output summary
    outstring = sprintf('%24s:%3d tests run', name, suite_info.testcases);
    all_failures = suite_info.failures + suite_info.errors;
    if all_failures > 0
        plural = '';
        if all_failures > 1, plural = 's'; end
        outstring = [outstring sprintf(',%3d test%s failed', all_failures, plural)];
    end
    if suite_fail
        outstring = [outstring sprintf(', suite contains errors')];
    end
    disp(outstring);

    % restore old path
    path(oldpath);

