% turntableConnect Turntable connect function
% 
% turntableConnect() Connects the turntable via the 
% Arduino Uno. If you use this version, you will be prompted with a list
% of serial ports available to Matlab. This creates a global CONTROLLER 
% variable. 
% 
% turntableConnect(SERIALPORT) Connects the turntable to SERIALPORT via the 
% Arduino Uno. This creates a global CONTROLLER variable. 
% 
% SERIALPORT is the serial port of the Arduino Uno, 
% e.g. /dev/tty.usbmodem11101 for Mac.
% 
% Author: Enzo De Sena
% Date 3/2/2024
function turntableConnect(serialPort)
    global turntableController;
    
    %% Open Arduino connection
    if nargin == 0
        serialPorts = serialportlist("available");
        if isempty(serialPorts)
            error('It looks like there are not available serial ports. If you already connected, clear the turntableController variable');
        end
        for n=1:length(serialPorts)
            disp(strcat(num2str(n), ': ', serialPorts{n}));
        end
        serialPortNum = input('Above is a list of serial ports. Which one is connected to the Arduino Uno? ');
        serialPort = serialPorts{serialPortNum};
    end
    disp(strcat('Trying to connect to serial port: ', serialPort));
    turntableController.arduinoObj = arduino(serialPort, 'Uno');
    disp('Turntable connected. A global variable has been created. To disconnect, run `turntableDisconnect`.');
    
    %% Test motor is connected
    disp('Checking that the motor is connected..')
    turntablePrivateStart('clockwise');
    currentDrawn = false;
    for n=1:20 % Try a few times
        current = readVoltage(turntableController.arduinoObj, 'A0');
        if current > 0.01
            currentDrawn = true;
            break
        end
    end
    turntablePrivateStop();
    if not(currentDrawn)
        turntableDisconnect(); 
        error('No current is being drawn by the motor. Are you sure the turntable cable is connected?')
    end
    disp('Motor is drawing current, so ok. The turntable is now ready to be used.');
    disp('If you would like to keep track of the angle, you can .')


    %% Initialise struct fields
    % This is done at the end because at this point we are sure that the
    % turntable is connected and working. If we did it in the beginning, we
    % would have created a non-empty turntableController struct, which 
    % would have tripped up the other functions into believing that 
    % the turntable is available.
    turntableController.currentPresumedAngle = nan; % Initialises to nan since we don't know where the turntable is
    turntableController.arduinoStepPin = 'A3';
    turntableController.arduinoZeroPin = 'A4';
    turntableController.averageStepSensorGroupLength = 4;
    turntableController.stepVoltageThreshold = 0.2; 
    turntableController.zeroVoltageThreshold = 0.5;
    turntableController.averageZeroSensorGroupLength = 4; % This is not currently used
