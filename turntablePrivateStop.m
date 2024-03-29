% turntablePrivateStop Turntable stop function (private function)
% 
% turntablePrivateStop() Stops rotating the turntable. 
% You should not run this function directly. 
% Use turntableTick or turntableRotateToZero instead.
% 
% Author: Enzo De Sena
% Date 3/2/2024
function turntablePrivateStop()
    global turntableController;
    
    writeDigitalPin(turntableController.arduinoObj, 'D3', 0); % Stop rotation
    pause(0.5) % Pause to let the turntable settle