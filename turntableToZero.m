% turntableToZero Turntable to zero function
% 
% EXITSTATUS = turntableToZero(DIRECTION) Starts rotating the 
% turntable until it reaches zero. It stops if it still hasn't reached it 
% after 2 minutes. Once successfully finised, this function resets 
% currentPresumedAngle. 
% 
% DIRECTION can either be 'clockwise' or 'counterclockwise'.
% EXITSTATUS is 1 if the turntable successfully reached the 0 degrees 
% location, and is 0 otherwise.
% 
%
% Author: Enzo De Sena
% Date 3/2/2024
function exitStatus = turntableToZero(rotationDirection)
    global turntableController;
    if isempty(turntableController)
        error('Looks like there is no turntableController in the workspace. Please call turntableConnect');
    end
    
    if nargin == 0
        rotationDirection = 'clockwise';
    end

    exitStatus = turntablePrivateStartMonitorStop(rotationDirection, ...
                                          turntableController.arduinoZeroPin, ...
                                          turntableController.zeroVoltageThreshold, ...
                                          0.25, 120);
    
    if exitStatus
        turntableController.currentPresumedAngle = 0; % Resets currentPresumedAngle
    end
    
    %% Reset so that it aligns coming from a clockwise direction
    % The following commands will be unnecessary once code is added to act
    % on the system calibration.
    if strcmp(rotationDirection, 'counterclockwise')
        turntableTick('counterclockwise', true); % The true tels the function to ignore the counterclockwise warning.
    end
    
    turntableTick('counterclockwise', true);
    exitStatus = turntableTick('clockwise');
