% turntableCalibrate Turntable calibration
% 
% turntableCalibrate() calculates certain values for the turntable, e.g.
% what is the voltage when the step sensor ticks to the next angle, or 
% how many voltage-up reading we get when going from one angle to the next.
% TODO: This function currently works, but its output is not used by the 
% other functions, so there is no difference if you run it or not.  
% 
% Author: Enzo De Sena
% Date 6/2/2024
function turntableCalibrate()
    global turntableController;
    if isempty(turntableController)
        error('Looks like there is no turntable controller in the workspace. Please call turntableConnect');
    end


function runStepCalibration()
    global turntableController;
    clockwiseGroupLength = runStepCalibrationDirection('clockwise');
    counterclockwiseGroupLength = runStepCalibrationDirection('counterclockwise');
    turntableController.averageStepSensorGroupLength = (clockwiseGroupLength+counterclockwiseGroupLength)/2;
    disp(['Average length of groups above threshold: ', num2str(turntableController.averageStepSensorGroupLength)]);


function averageSensorGroupLength = runStepCalibrationDirection(direction)
    global turntableController;
    turntablePrivateStart(direction);
    N = 400;
    voltage = nan(1, N);
    for n=1:N
        voltage(n) = readVoltage(turntableController.arduinoObj, turntableController.arduinoStepPin);
    end
    turntablePrivateStop(turntableController);
    stem(1:N, voltage);
    xlabel('Measurement index')
    ylabel('Step sensor [V]')
    averageSensorGroupLength = calculateAverageLengthOfGroups(voltage, turntableController.stepVoltageThreshold);




function runZeroCalibration()
    global turntableController;
    turntableToZero('clockwise');
    turntableTick('clockwise');
    
    N = 400;
    voltage = nan(1, N);
    currentDirection = 'counterclockwise';
    turntablePrivateStart(currentDirection);
    nLastAboveThreshold = nan;
    for n=1:N
        voltage(n) = readVoltage(turntableController.arduinoObj, turntableController.arduinoZeroPin);
        if voltage(n) > turntableController.zeroVoltageThreshold
            nLastAboveThreshold = n;
        end
        if (n-nLastAboveThreshold) > 30
            nLastAboveThreshold = nan;
            turntablePrivateStop(turntableController);
            if strcmp(currentDirection, 'counterclockwise')
                currentDirection = 'clockwise';
            else
                currentDirection = 'counterclockwise';
            end
            turntablePrivateStart(currentDirection);
        end
    end
    
    turntablePrivateStop();
    stem(1:N, voltage);
    xlabel('Measurement index')
    ylabel('Zero sensor [V]')
    turntableController.averageZeroSensorGroupLength = calculateAverageLengthOfGroups(voltage, turntableController.zeroVoltageThreshold);
    disp(['Average length of groups above threshold: ', num2str(turntableController.averageZeroSensorGroupLength)]);


function averageLength = calculateAverageLengthOfGroups(signal, threshold)
    % Find where signal is above the threshold
    aboveThreshold = signal > threshold;
    
    % Find the start and end of each group
    diffAboveThreshold = diff([0, aboveThreshold, 0]);
    starts = find(diffAboveThreshold == 1);
    ends = find(diffAboveThreshold == -1) - 1;
    
    % Calculate the lengths of the groups
    groupLengths = ends - starts + 1;
    
    % Calculate the average length of the groups
    averageLength = mean(groupLengths);