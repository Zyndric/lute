function tcstruct = testcase_struct(name, bFail, bError, message, cmdout, time)

    % without arguments, produce correctly typed, but empty structure
    if nargin == 0
        name = {};
        bFail = {};
        bError = {};
        message = {};
        cmdout = {};
        time = {};
    else
        if nargin < 2, bFail = false; end
        if nargin < 3, bError = false; end
        if nargin < 4, message = ''; end
        if nargin < 5, cmdout = ''; end
        if nargin < 6, time = 0; end
    end

    tcstruct = struct(...
        'name', name, ...
        'fail', bFail, ...
        'error', bError, ...
        'message', message, ...
        'cmdout', cmdout, ...
        'time', time ...
        );
