% wrap function call to assert error

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function expect_error(fun, id)

    if nargin < 2, id = ''; end

    tc = testcase_struct(func2str(fun));

    is_caught = false;
    err_struct = [];
    try
        tic;
        % evalc works on the local workspace
        tc.cmdout = evalc('fun()');
        tc.time = toc;
    catch err_struct
        tc.time = toc;
        is_caught = true;
    end

    if is_caught
        % if id is empty, the user wants any error, else only the specified
        if isempty(id) || isequal(id, err_struct.identifier)
        else
            % got another error, which we assume to be a proper error
            tc.error = true;
            tc.message = err_struct.getReport();
        end
    else
        % if no error caught, handle this as failed expectation, i.e. failure
        tc.fail = true;
        tc.message = 'Error expected, but none occurred.';
    end

    % add testcase
    testcase_collector(tc);
