%FEVAL_TESTCASE Evaluate and record a testcase function.
%   FEVAL_TESTCASE(tc_func, specific_eval_func, nargs) evaluates function
%   tc_func, and buffers its console output, its errors, if any, and its return
%   arguments, if any. Prefills a testcase struct with items time, cmdout and
%   name. Then calls specific_eval_func with these information to fill the
%   testcase struct specific to the expect_* function that delegated its
%   evaluation to feval_testcase. The specific code needs to be given as
%   function, because feval_testcase eventually records the completed testcase
%   and outputs its result, if not suppressed. Input argument nargs must give
%   the number of return values that tc_func is going to produce.
%
%   tc = SPECIFIC_EVAL_FUNC(partial_tc, err_struct, return_args) is the
%   signature that specific_eval_func must conform to.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function feval_testcase(tc_func, specific_eval_func, nargs)

    if nargin < 3, nargs = 0; end

    % init testcase struct with function name
    tc = testcase_struct(func2str(tc_func));
    
    return_args = cell(1,nargs);
    err_struct = [];
    try
        tic;
        % evalc works on the local workspace
        % sometimes, if the eval cmd does not output any text, tc.cmdout may in
        % fact not only be empty, but even not assigned at all, which, in this
        % case doesn't matter, because we initialized it earlier. Feels like a
        % bug, though.
        [tc.cmdout, return_args{:}] = evalc('tc_func()');
        tc.time = toc;
    catch err_struct
        % err_struct will thus be a non-empty structure when calling
        % specific_eval_func later.
        tc.time = toc;
    end
    
    % let parent implementation fill tc specifically
    tc = specific_eval_func(tc, err_struct, return_args);

    % add testcase
    testcase_collector(tc);

    if ~suppress_output()
        print_testcase(tc);
    end

