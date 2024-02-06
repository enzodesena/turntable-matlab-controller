% This function runs the turntable through its paces, going back and 
% forth a few times, checking it doesn't skip an angle etc. 
%
% Author: Enzo De Sena
% Date 3/2/2024
function turntableTest()
    global turntableController;
    if isempty(turntableController)
        error('Looks like there is no turntable controller in the workspace. Please call turntableConnect');
    end
    
    disp('Rotating back to zero before we can start.')
    
    turntableToZero('clockwise');
    disp('Doing some tests now...')
    
    assert(turntableGetAngle()==0);
    turntableTick('counterclockwise');
    assert(turntableGetAngle()==357.5);
    turntableTick('clockwise');
    assert(turntableGetAngle()==0);
    turntableTick('clockwise');
    assert(turntableGetAngle()==2.5);
    turntableTick('clockwise');
    turntableTick('clockwise');
    assert(turntableGetAngle()==7.5);
    disp('All good so far. Will ask some questions in a second..');
    turntableToZero('counterclockwise');
    disp('Is the angle 0 deg? If yes, press enter. If not, please stop as there is something wrong');
    pause
    disp('Good. Let me go to 180 deg now.')
    
    for n=1:72
        turntableTick('clockwise');
        disp(strcat('Current angle is:', num2str(turntableGetAngle())));
    end
    assert(turntableGetAngle()==180);
    disp('Is the angle 180 deg? If yes, press enter. If not, please stop as there is something wrong');
    pause
    disp('Good. Let me continue back to 0 deg now.')
    
    
    for n=1:72
        turntableTick('clockwise');
        disp(strcat('Current angle is:', num2str(turntableGetAngle())));
    end
    assert(turntableGetAngle()==0);
    disp('Is the angle 0 deg? If yes, press enter. If not, please stop as there is something wrong');
    pause
    disp('Good. Let me go to 0 degrees, this time clockwise')
    
    for n=1:144
        turntableTick('clockwise');
        disp(strcat('Current angle is:', num2str(turntableGetAngle())));
    end
    assert(turntableGetAngle()==0);
    disp('Is the angle 0 deg? If yes, press enter. If not, please stop as there is something wrong');
    pause
    disp('Great. Looks like all is working as it should!')
