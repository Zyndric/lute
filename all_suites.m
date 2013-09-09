% Execute all test suites consecutively.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function all_suites(testdir)

    % guess current directory as testdir
    if nargin == 0, testdir = pwd; end

    % save path state and add testdir in order to find single_suite
    oldpath = path;
    addpath(testdir);

    % dynamically determine test suites
    testfiles = dir(fullfile(testdir, 'test_*.m'));
    [dummy suites] = cellfun(@fileparts, {testfiles.name}, 'UniformOutput', false);
    
    % execute test suites
    suite_infos = cellfun(@single_suite, suites);
    
    % output summary
    fprintf('Executed %d test cases in %d test suites.\n', ...
        sum([suite_infos.testcases]), ...
        numel(suite_infos));
    all_failures = sum([suite_infos.failures]) + sum([suite_infos.errors]);
    if all_failures == 0
        disp('All test cases successfull.')
    else
        plural = '';
        if all_failures > 1, plural = 's'; end
        fprintf('%d test case%s failed.\n', all_failures, plural);
    end
    fprintf('Execution time: %.2f s.\n', sum([suite_infos.time]));

    % restore old path
    path(oldpath);

    disp_error_details(suite_infos);


function disp_error_details(suite_infos)

    % collate all test case infos
    testcase_infos = [suite_infos.testcase_info];

    % filter failures/errors
    failures = testcase_infos([testcase_infos.fail]);
    errors = testcase_infos([testcase_infos.error]);

    if ~isempty(failures)
        fprintf('\n');
        disp('Failure details:');
        arrayfun(@disp_test_failure, failures);
    end
    if ~isempty(errors)
        fprintf('\n');
        disp('Error details:');
        arrayfun(@disp_test_errors, errors);
    end


function disp_test_failure(testcase_info)

    fprintf('Function %s reported failure: %s\n', testcase_info.name, testcase_info.message);


function disp_test_errors(testcase_info)
 
    fprintf('Function %s reported error: %s\n', testcase_info.name, testcase_info.message);

