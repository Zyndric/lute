% wrap function call to assert several output arguments

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function expect_from(varargin)

    % first argument is the function itself, rest are output arguments
    nargs = numel(varargin)-1;

    tc = testcase_struct(func2str(varargin{1}));
    
    actual = cell(1,nargs);
    try
        tic;
        % evalc works on the local workspace
        [tc.cmdout, actual{:}] = evalc('varargin{1}()');
        tc.time = toc;
    catch me
        tc.time = toc;
        tc.error = true;
        tc.message = me.getReport();
    end
    expected = varargin(2:end);
    
    if ~tc.error
        % check for equality with expected output
        equals = cellfun(@isequalwithtypes, actual, expected);
        if ~all(equals)
            tc.fail = true;
            tc.message = sprintf('Expected %s did not match actual %s on output arguments %s.', string(expected), string(actual), string(double(equals)));
        end
    end

    % add testcase
    testcase_collector(tc);

    
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


% Apparently, isqual() R2007b thinks [] and '' equal, which we would not expect.
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
