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
    
    % TODO: dynamically determine test suites
    suites = { ...
        'test_common_basepath', ...
        'test_dirset', ...
        'test_fileset', ...
        'test_fullfilec', ...
        'test_relpath', ...
        };

    % execute test suites
    suite_infos = cellfun(@single_suite, suites);
    
    % output summary
    fprintf('Executed %d test cases in %d test suites.\n', ...
        sum([suite_infos.testcases]), ...
        numel(suite_infos));
    failures = sum([suite_infos.failures]);
    errors = sum([suite_infos.errors]);
    if failures == 0 && errors == 0
        disp('All suites successfull.')
    else
        if failures ~= 0
            fprintf('%d test suites failed.\n', failures);
        end
        if errors ~= 0
            fprintf('%d test suites had errors.\n', errors);
        end
    end
    fprintf('Execution time: %.2f s.\n', sum([suite_infos.time]));

    % restore old path
    path(oldpath);
