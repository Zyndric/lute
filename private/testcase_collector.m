function return_tcoll = testcase_collector(cmd)

    if nargin < 1, cmd = ''; end

    % init persistent test collection structure
    persistent tcoll;
    if isempty(tcoll)
        % start with properly typed struct
        tcoll = testcase_struct;
    end

    % add testcase first if structure given
    if isstruct(cmd)
        % must be correctly typed structure
        assert(is_testcase_struct(cmd));
        tcoll(end+1) = cmd;
    end

    % return current collector state
    return_tcoll = tcoll;

    % if reset, do so after having set the return
    if ischar(cmd) && strcmpi('reset', cmd)
        tcoll = testcase_struct;
    end


% Check if all testcase_struct fields are in a given struct
function is_tcstruct = is_testcase_struct(tcstruct)

    is_tcstruct = all(isfield(tcstruct, fieldnames(testcase_struct)));
