%EXPECT_ERROR Check a function's error.
%   EXPECT_ERROR(F) calls function F and checks that it results in a proper
%   MATLAB error. If calling F does not yield an error, the testcase fails.
%
%   EXPECT_ERROR(F, ID) does the same, but checks that the error being thrown is
%   exactly of id ID. Other errors count as testcase error. An error id must
%   contain a colon, e.g. 'MATLAB:arbitraryError'.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function expect_error(func, id)

    if nargin < 2, id = ''; end

    eval_error_id = @(tc, err, retargs) eval_error(tc, err, retargs, id);

    feval_testcase(func, eval_error_id, 0);


% specific evaluator for expected errors
function tc = eval_error(tc, err_struct, return_args, id)

    if isempty(err_struct)
        % if no error caught, handle this as failed expectation, i.e. failure
        tc.fail = true;
        tc.message = 'Error expected, but none occurred.';
    else
        % if id is empty, the user wants any error, else only the specified
        if ~isempty(id) && ~isequal(id, err_struct.identifier)
            % got another error, which we assume to be a proper error
            tc.error = true;
            tc.message = err_struct.getReport();
        end
    end

