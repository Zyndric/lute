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

    % switch off stub warnings
    oldwarnstate = warning('off', 'MATLAB:dispatcher:nameConflict');
    
    % save path state and add any dependency dirs the user specified
    oldpath = path;
    if ~isempty(paths)
        addpath(paths{:});
    end

    % reset suite information
    testcase_collector('reset');
    
    try
        % TODO: catch standard output and return some other way
        eval(name);
    catch err
        disp(err.getReport());
    end

    suite_info.testcase_info = testcase_collector('reset');
    suite_info.testcases = numel(suite_info.testcase_info);
    suite_info.failures = sum(double([suite_info.testcase_info.fail]));
    suite_info.errors = sum(double([suite_info.testcase_info.error]));
    suite_info.time = sum(double([suite_info.testcase_info.time]));

    outstring = sprintf('%24s:%3d tests run', name, suite_info.testcases);
    all_failures = suite_info.failures + suite_info.errors;
    if all_failures > 0
        plural = '';
        if all_failures > 1, plural = 's'; end
        outstring = [outstring sprintf(',%3d test%s failed', all_failures, plural)];
    end
    disp(outstring);

    % restore old path
    path(oldpath);

    % restore warn state
    warning(oldwarnstate);
