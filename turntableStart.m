% turntableStart Turntable start function
% 
% turntableStart(DIRECTION) Starts rotating the 
% turntable. You should not run this function directly. 
% Use turntableTick or turntableRotateToZero instead.
% 
% DIRECTION can either be 'clockwise' or 'counterclockwise'.
%
% Author: Enzo De Sena
% Date 3/2/2024
function turntableStart(direction)
    assert(strcmp(direction, 'clockwise') || strcmp(direction, 'counterclockwise'));
    global turntableController;
    if isempty(turntableController)
        error('Looks like there is no turntable controller in the workspace. Please call turntableConnect');
    end
    
    if strcmp(direction, 'counterclockwise')
        writeDigitalPin(turntableController.arduinoObj, 'D12', 1);
    else
        writeDigitalPin(turntableController.arduinoObj, 'D12', 0);
    end
    
    writeDigitalPin(turntableController.arduinoObj, 'D9', 0); % Disengage the Brake for Channel A
    %writeDigitalPin(turntableController.arduinoObj, 'D3', 1); % Spins the motor on Channel A at full speed
    
    writePWMVoltage(turntableController.arduinoObj, 'D3', 4); % Can be used to control rotation speed (min 0, max 5)
