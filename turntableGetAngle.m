% turntableGetAngle Turntable get angle function
% 
% ANGLE = turntableGetAngle() Returns the current presumed angle. 
% This is `presumed` because it is calculated by keeping track of how many 
% calls have been made (one way or the other) to turntableTick. 
% The only case where we actually know where the turntable actually is, 
% is after having called turntableRotateToZero. 
% This function 
% 
% ANGLE is the current presumed angle (wrapped between 0 and 357.5 deg).
% Returns nan in case turntableRotateToZero hasn't been called yet. 
%
% Author: Enzo De Sena
% Date 3/2/2024
function angle = turntableGetAngle()
    global turntableController;
    if isempty(turntableController)
        error('Looks like there is no turntable controller in the workspace. Please call turntableConnect');
    end
    
    angle = wrapAngle(turntableController.currentPresumedAngle);
    end
    
    function angleInDegrees = wrapAngle(angle)
    angleInDegrees = mod(angle, 360);
    if angleInDegrees < 0
        angleInDegrees = angleInDegrees + 360;
    end
    end