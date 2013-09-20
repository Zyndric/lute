function print_testcase(tc)

    if isempty(tc.name), tc.name = '(empty)'; end
    if length(tc.name) > 40, tc.name = [tc.name(1:36) ' ...']; end

    runstring = sprintf('Testcase %-40s (%0.4f s)', tc.name, tc.time);

    failed = tc.fail || tc.error;
    if failed
        result = ' FAILED';
    else
        result = ' OK';
    end

    disp([runstring, result]);
    
    if failed
        disp('--> Message with stack trace:');
        disp(indent(tc.message));
    end


function outstr = indent(instr)

    newline = sprintf('\n');
    indent_string = '    ';

    lines = tokenize_lines(instr);
    % wrap indent string in {} lest strcat eats its whitespace
    indented_lines = strcat({indent_string}, lines);
    outstr = strjoin(indented_lines, newline);


function lines = tokenize_lines(str)

    first = @(c) c{1};
    % setting delimiter to \n lets textscan tokenize lines, also empty lines
    % setting whitespace to '' prevents textscan from eating leading whitesp.
    lines = first(textscan(str, '%s', 'Delimiter', '\n', 'Whitespace', ''));


function str = strjoin(strcell, delim)

    str = [sprintf(['%s' delim], strcell{1:end-1}) strcell{end}];

