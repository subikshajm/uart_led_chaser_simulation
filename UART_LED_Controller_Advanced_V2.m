% UART_LED_Controller_Advanced_V2.m
clc; clear;

% === Simulated GPIO Registers ===
global REG;
REG.GPIO_ODR = zeros(1, 8);  % Output Data Register for 8 LEDs
REG.STATUS = 0;              % 0 = idle, 1 = command received
REG.STATE = "IDLE";          % FSM state
%%
% 
% $$e^{\pi i} + 1 = 0$$
% 

% Pattern & log
custom_pattern = [];
command_log = {};

% === START ===
disp("=== UART LED CONTROLLER (FSM, MATLAB Simulation) ===");
disp("Type a command: BLINK, CHASE, ALT, ON, OFF, RECORD, REPLAY, EDITOR, STATUS, DUMP, EXIT");
%%
% 
%   for x = 1:10
%       disp(x)
%   end
% 

while true
    uart_input = input("UART > ", 's');
    UART_RX = strtrim(upper(uart_input));

    if isempty(UART_RX)
        continue;
    end

    REG.STATUS = 1; flashStatusLED();
    fprintf("[UART] Received: %s\n", UART_RX);
    command_log{end+1} = UART_RX;

    switch UART_RX
        case "BLINK";       blinkLEDs(REG, 3);
        case "CHASE";       chaser(REG, 2);
        case "ALT";         alternateLEDs(REG, 4);
        case "ON";          REG.GPIO_ODR(:) = 1; displayLEDs(REG.GPIO_ODR);
        case "OFF";         REG.GPIO_ODR(:) = 0; displayLEDs(REG.GPIO_ODR);
        case "STATUS";      disp("LED State:"); displayLEDs(REG.GPIO_ODR);
        case "RECORD";      custom_pattern = recordPattern();
        case "REPLAY";      replayPattern(custom_pattern);
        case "EDITOR";      custom_pattern = patternEditor(custom_pattern);
        case "DUMP";        memoryDump(REG, command_log);
        case "EXIT";        disp("[EXIT] Goodbye."); break;
        otherwise;          disp("[ERROR] Invalid command.");
    end

    REG.STATUS = 0;
end

%% === FUNCTION DEFINITIONS ===

function blinkLEDs(REG, reps)
    for i = 1:reps
        REG.GPIO_ODR(:) = 1; displayLEDs(REG.GPIO_ODR); pause(0.3);
        REG.GPIO_ODR(:) = 0; displayLEDs(REG.GPIO_ODR); pause(0.3);
    end
end

function chaser(REG, loops)
    for k = 1:loops
        for i = 1:8
            REG.GPIO_ODR(:) = 0;
            REG.GPIO_ODR(i) = 1;
            displayLEDs(REG.GPIO_ODR); pause(0.2);
        end
    end
end

function alternateLEDs(REG, reps)
    for i = 1:reps
        REG.GPIO_ODR = repmat([1 0],1,4); displayLEDs(REG.GPIO_ODR); pause(0.3);
        REG.GPIO_ODR = repmat([0 1],1,4); displayLEDs(REG.GPIO_ODR); pause(0.3);
    end
end

function displayLEDs(led_array)
    state = sprintf("[%d] ", led_array);
    disp("LEDs: " + state);
end

function flashStatusLED()
    fprintf("[STATUS LED] ON\n"); pause(0.05);
    fprintf("[STATUS LED] OFF\n");
end

function pattern = recordPattern()
    pattern = [];
    disp("[RECORDING] Enter 8-bit LED patterns. Type END to finish.");
    while true
        p = input("Pattern > ", 's');
        if strcmpi(p, "END"), break;
        elseif length(p) == 8 && all(ismember(p, '01'))
            pattern(end+1, :) = double(p) - '0';
        else
            disp("Invalid. Use 8-bit binary like 10101010.");
        end
    end
end

function replayPattern(pattern)
    global REG;
    if isempty(pattern)
        disp("[ERROR] No pattern recorded.");
        return;
    end
    disp("[REPLAY] Playing back pattern...");
    for i = 1:size(pattern,1)
        REG.GPIO_ODR = pattern(i,:);
        displayLEDs(REG.GPIO_ODR);
        pause(0.25);
    end
end

function edited = patternEditor(existing)
    if isempty(existing)
        disp("[EDITOR] No pattern loaded. Start with RECORD.");
        edited = [];
        return;
    end
    disp("[EDITOR] Editing current pattern.");
    for i = 1:size(existing,1)
        fprintf("Line %d: [%s]\n", i, num2str(existing(i,:)));
    end
    disp("Type: REPLACE <line> <8-bit>, DELETE <line>, APPEND <8-bit>, END");

    edited = existing;
    while true
        cmd = input("EDIT > ", 's');
        tokens = split(cmd);
        if strcmpi(tokens{1}, "END")
            break;
        elseif strcmpi(tokens{1}, "REPLACE") && numel(tokens) == 3
            idx = str2double(tokens{2});
            bin = tokens{3};
            if idx >=1 && idx <= size(edited,1) && length(bin)==8 && all(ismember(bin, '01'))
                edited(idx,:) = double(bin) - '0';
            else
                disp("[ERROR] Invalid replace.");
            end
        elseif strcmpi(tokens{1}, "DELETE") && numel(tokens) == 2
            idx = str2double(tokens{2});
            if idx >=1 && idx <= size(edited,1)
                edited(idx,:) = [];
            else
                disp("[ERROR] Invalid delete.");
            end
        elseif strcmpi(tokens{1}, "APPEND") && numel(tokens) == 2
            bin = tokens{2};
            if length(bin)==8 && all(ismember(bin, '01'))
                edited(end+1,:) = double(bin) - '0';
            else
                disp("[ERROR] Invalid append.");
            end
        else
            disp("[ERROR] Unknown EDIT command.");
        end
    end
end

function memoryDump(REG, log)
    disp("=== MEMORY DUMP ===");
    disp("GPIO_ODR: "); disp(REG.GPIO_ODR);
    disp("Command History:");
    for i = 1:numel(log)
        fprintf("%02d: %s\n", i, log{i});
    end
end
