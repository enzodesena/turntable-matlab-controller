% turntableControlUI Turntable UI control
% 
% turntableControlUI() opens a small user interface to control the
% turntable. If the turntable object hasn't been created yet it calls 
% turntableConnect(). A few buttons have been removed to ensure the
% turntable is used correctly. 
%
% Author: Enzo De Sena
% Date 6/2/2024
function turntableControlUI
    global turntableController;
    if isempty(turntableController)
        turntableConnect();
    end

    % Create a figure for the UI
    fig = figure('Name', 'Turntable Control', 'Position', [100, 100, 350, 250]);

    % Button for ticking clockwise
    uicontrol('Style', 'pushbutton', 'String', 'Tick CW', ...
        'Position', [50, 175, 100, 40], 'Callback', @tickCW);

    % Button for ticking counterclockwise
    % Commenting this one out since it still does not work (needs
    % calibration procedure)
%     uicontrol('Style', 'pushbutton', 'String', 'Tick CCW', ...
%         'Position', [200, 175, 100, 40], 'Callback', @tickCCW);

    % Button to return to zero clockwise
    uicontrol('Style', 'pushbutton', 'String', 'Go to 0 deg (CW)', ...
        'Position', [50, 125, 100, 40], 'Callback', @resetCW);

    % Button to return to zero counterclockwise
    uicontrol('Style', 'pushbutton', 'String', 'Go to 0 deg (CCW)', ...
        'Position', [200, 125, 100, 40], 'Callback', @resetCCW);

%     % Button to start rotation clockwise
%     uicontrol('Style', 'pushbutton', 'String', 'Start CW', ...
%         'Position', [50, 75, 100, 40], 'Callback', @startRotateCW);
% 
%     % Button to start rotation counterclockwise
%     uicontrol('Style', 'pushbutton', 'String', 'Start CCW', ...
%         'Position', [200, 75, 100, 40], 'Callback', @startRotateCCW);
% 
%     % Button to stop rotation
%     uicontrol('Style', 'pushbutton', 'String', 'Stop', ...
%         'Position', [125, 25, 100, 40], 'Callback', @stopRotate);

    % Text field for displaying the current angle
    angleDisplay = uicontrol('Style', 'text', 'String', 'Angle: 0', ...
        'Position', [125, 225, 100, 20], 'BackgroundColor', 'white');

    % Update the display initially
    updateAngleDisplay();

    % Callback function for ticking clockwise
    function tickCW(~, ~)
        turntableTick('clockwise');
        updateAngleDisplay();
        % Here, you would add the code to command the turntable to tick CW
    end

    % Callback function for ticking counterclockwise
    function tickCCW(~, ~)
        turntableTick('counterclockwise');
        updateAngleDisplay();
        % Here, you would add the code to command the turntable to tick CW
    end

    % Callback function to reset to zero clockwise
    function resetCW(~, ~)
        turntableToZero('clockwise');
        updateAngleDisplay();
    end

    % Callback function to reset to zero counterclockwise
    function resetCCW(~, ~)
        turntableToZero('counterclockwise');
        updateAngleDisplay();
    end

    % Callback function to start rotation clockwise
    function startRotateCW(~, ~)
        turntablePrivateStart('clockwise');
        updateAngleDisplay();
    end

    % Callback function to start rotation counterclockwise
    function startRotateCCW(~, ~)
        turntablePrivateStart('counterclockwise');
    end

    % Callback function to stop rotation
    function stopRotate(~, ~)
        turntablePrivateStop();
    end

    % Function to update the angle display
    function updateAngleDisplay
        set(angleDisplay, 'String', ['Angle: ' num2str(turntableGetAngle())]);
    end
end
