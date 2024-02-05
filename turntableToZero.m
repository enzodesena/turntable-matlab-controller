% turntableToZero Turntable to zero function
% 
% CONTROLLER = turntableToZero(CONTROLLER, DIRECTION) Starts rotating the 
% turntable until it reaches zero. It stops if it still hasn't reached it 
% after 2 minutes. Once successfully finised, this function resets 
% currentPresumedAngle. 
% 
% DIRECTION can either be 'clockwise' or 'counterclockwise'.
%
% Author: Enzo De Sena
% Date 3/2/2024
function turntableToZero(rotationDirection)
global turntableController;
if isempty(turntableController)
    error('Looks like there is no turntable turntableController in the workspace. Please call turntableConnect');
end

successful = turntableStartAndMonitor(rotationDirection, ...
                                      turntableController.arduinoZeroPin, ...
                                      turntableController.zeroVoltageThreshold, ...
                                      0.25, 120);

if successful
    turntableController.currentPresumedAngle = 0; % Resets currentPresumedAngle
end
