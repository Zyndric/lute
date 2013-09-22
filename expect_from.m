%EXPECT_FROM Check a function's return values.
%   EXPECT_FROM(F, A) calls function F and checks that its output value equals
%   A.
%
%   EXPECT_FROM(F, A1, A2, ...) does the same, but with any number of output
%   arguments. The function F must at least return as many arguments as you give
%   with A1, A2, ..., lest MATLAB will issue a 'Too many output arguments'
%   error.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function expect_from(func, varargin)

    % inject varargin values into eval function call
    eval_equals_with_expected = @(tc, err, actual) eval_equals(tc, err, actual, varargin);

    feval_testcase(func, eval_equals_with_expected, numel(varargin));
    
  
% specific evaluator for expected output
function tc = eval_equals(tc, err_struct, actual, expected)

    if isempty(err_struct)
        % check for equality with expected output
        equals = cellfun(@isequalwithtypes, actual, expected);
        if ~all(equals)
            tc.fail = true;
            tc.message = sprintf( ...
                'Expected %s did not match actual %s on output argument position %s.', ...
                string(expected), string(actual), string(double(equals)));
        end
    else
        tc.error = true;
        tc.message = err_struct.getReport();
    end
    
    
function str = string(value)

    if iscell(value)
        item_strings = cellfun(@string, value, 'UniformOutput', false);
        str = ['{' strjoin(item_strings, ',') '}'];
    elseif isstruct(value)
    else
        str = mat2str(value);
    end
    
    
function result = strjoin(stringcell, separator)

    if isempty(stringcell), result = ''; return; end
    result = [sprintf(['%s' separator], stringcell{1:end-1}), stringcell{end}];


% Apparently, isqual() R2007b considers char and numerics equals, particularly
% [] and '', which we do not want.
% Therefore, handle string and non-string return arguments as inequal. Does not
% consider nesting further than one cell array level.
% Does not compromise double/int comparison.
function equal = isequalwithtypes(a, b)

    % char type is equal if both are char, or both are not
    equal_char_type = @(a, b) ~xor(ischar(a), ischar(b));
    
    % work all() along all elements of multi-dimensional matrices by linearizing
    allall = @(a) all(a(:));

    if iscell(a) && iscell(b)
        % if this is a cell array, all its elements must be of equal char type
        equal = isequal(a, b) && allall(cellfun(equal_char_type, a, b));
    elseif ~equal_char_type(a, b)
        equal = false;
    else
        equal = isequal(a, b);
    end

