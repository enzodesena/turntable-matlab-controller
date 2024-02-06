% turntableTick Turntable tick function
% 
% EXITSTATUS = turntableTick(DIRECTION) Ticks the turnatable 
% by 2.5 degrees (either direction). Stops after 5 seconds if it hasn't 
% reached the next tick. Do not close the program while this function is 
% running, or else, the turntable will continue rotating.
% IMPORTANT NOTE: until the calibration work is completed, you should only
% really call this function using "clockwise". 
% 
% DIRECTION can either be 'clockwise' or 'counterclockwise'.
% EXITSTATUS is 1 if the turntable successfully reached a point where the 
% monitored pin went above the threshold, and is 0 otherwise.
%
% Author: Enzo De Sena
% Date 3/2/2024
function exitStatus = turntableTick(rotationDirection)
    global turntableController;
    if isempty(turntableController)
        error('Looks like there is no turntable controller in the workspace. Please call turntableConnect');
    end
    
    if nargin == 0
        rotationDirection = 'clockwise';
    end

    exitStatus = turntablePrivateStartMonitorStop(rotationDirection, ...
                                           turntableController.arduinoStepPin, ...
                                           turntableController.stepVoltageThreshold, ...
                                           0.25, 5);
    
    if exitStatus
        %% Update current presumed angle
        if strcmp(rotationDirection, 'clockwise')
            turntableController.currentPresumedAngle = turntableController.currentPresumedAngle + 2.5;
        else
            turntableController.currentPresumedAngle = turntableController.currentPresumedAngle - 2.5;
        end
    end
