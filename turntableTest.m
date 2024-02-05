% This function runs the turntable through its paces, going back and 
% forth a few times, checking it doesn't skip an angle etc. 
% 
%
% Author: Enzo De Sena
% Date 3/2/2024
function turntableTest()
global turntableController;
if isempty(turntableController)
    error('Looks like there is no turntable controller in the workspace. Please call turntableConnect');
end

disp('Rotating back to zero before we can start.')

controller = turntableToZero(controller, 'clockwise');
disp('Doing some tests now...')

assert(turntableGetAngle(controller)==0);
controller = turntableTick(controller,'counterclockwise');
assert(turntableGetAngle(controller)==357.5);
controller = turntableTick(controller,'clockwise');
assert(turntableGetAngle(controller)==0);
controller = turntableTick(controller,'clockwise');
assert(turntableGetAngle(controller)==2.5);
controller = turntableTick(controller,'clockwise');
controller = turntableTick(controller,'clockwise');
assert(turntableGetAngle(controller)==7.5);
disp('All good so far. Will ask some questions in a second..');
controller = turntableToZero(controller, 'counterclockwise');
disp('Is the angle 0 deg? If yes, press enter. If not, please stop as there is something wrong');
pause
disp('Good. Let me go to 180 deg now.')

for n=1:72
    controller = turntableTick(controller, 'counterclockwise');
    disp(strcat('Current angle is:', num2str(turntableGetAngle(controller))));
end
assert(turntableGetAngle(controller)==180);
disp('Is the angle 180 deg? If yes, press enter. If not, please stop as there is something wrong');
pause
disp('Good. Let me continue back to 0 deg now.')


for n=1:72
    controller = turntableTick(controller, 'counterclockwise');
    disp(strcat('Current angle is:', num2str(turntableGetAngle(controller))));
end
assert(turntableGetAngle(controller)==0);
disp('Is the angle 0 deg? If yes, press enter. If not, please stop as there is something wrong');
pause
disp('Good. Let me go to 0 degrees, this time clockwise')

for n=1:144
    controller = turntableTick(controller, 'clockwise');
    disp(strcat('Current angle is:', num2str(turntableGetAngle(controller))));
end
assert(turntableGetAngle(controller)==0);
disp('Is the angle 0 deg? If yes, press enter. If not, please stop as there is something wrong');
pause
disp('Great. Looks like all is working as it should!')
