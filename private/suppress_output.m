function return_flag = suppress_output(input_flag)

    if nargin < 1, cmd = ''; end

    % init persistent flag with default false
    persistent suppress_flag;
    if isempty(suppress_flag)
        suppress_flag = false;
    end

    % set only if input_flag given
    if nargin >= 1
        suppress_flag = input_flag;
    end

    % return current flag state
    return_flag = suppress_flag;

