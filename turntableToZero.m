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
        error('Looks like there is no turntableController in the workspace. Please call turntableConnect');
    end
    
    successful = turntablePrivateStartMonitorStop(rotationDirection, ...
                                          turntableController.arduinoZeroPin, ...
                                          turntableController.zeroVoltageThreshold, ...
                                          0.25, 120);
    
    if successful
        turntableController.currentPresumedAngle = 0; % Resets currentPresumedAngle
    end
    
    %% Reset so that it aligns coming from a clockwise direction
    % The following commands will be unnecessary once code is added to act
    % on the system calibration.
    if strcmp(rotationDirection, 'counterclockwise')
        turntableTick('counterclockwise');
    end
    
    turntableTick('counterclockwise');
    turntableTick('clockwise');
