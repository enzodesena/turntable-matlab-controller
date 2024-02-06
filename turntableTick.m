% turntableTick Turntable tick function
% 
% turntableTick(DIRECTION) Ticks the turnatable 
% by 2.5 degrees (either direction). Stops after 5 seconds if it hasn't 
% reached the next tick. Do not close the program while this function is 
% running, or else, the turntable will continue rotating.
% IMPORTANT NOTE: until the calibration work is completed, you should only
% really use this function as "clockwise". 
% 
% DIRECTION can either be 'clockwise' or 'counterclockwise'.
%
% Author: Enzo De Sena
% Date 3/2/2024
function turntableTick(rotationDirection)
    global turntableController;
    if isempty(turntableController)
        error('Looks like there is no turntable controller in the workspace. Please call turntableConnect');
    end
    
    successfull = turntablePrivateStartMonitorStop(rotationDirection, ...
                                           turntableController.arduinoStepPin, ...
                                           turntableController.stepVoltageThreshold, ...
                                           0.25, 5);
    
    if successfull
        %% Update current presumed angle
        if strcmp(rotationDirection, 'clockwise')
            turntableController.currentPresumedAngle = turntableController.currentPresumedAngle + 2.5;
        else
            turntableController.currentPresumedAngle = turntableController.currentPresumedAngle - 2.5;
        end
    end
