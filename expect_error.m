% wrap function call to assert error

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function expect_error(fun)

    bCaught = false;
    try
        fun();
    catch
        bCaught = true;
    end

    % count testcases up
%    singleton_counter('testcase');
    
    if ~bCaught
        error('Error expected, but none occurred.');
    end
