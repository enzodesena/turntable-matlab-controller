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
    turntableStart(direction);
    N = 400;
    voltage = nan(1, N);
    for n=1:N
        voltage(n) = readVoltage(turntableController.arduinoObj, turntableController.arduinoStepPin);
    end
    turntableStop(turntableController);
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
    turntableStart(currentDirection);
    nLastAboveThreshold = nan;
    for n=1:N
        voltage(n) = readVoltage(turntableController.arduinoObj, turntableController.arduinoZeroPin);
        if voltage(n) > turntableController.zeroVoltageThreshold
            nLastAboveThreshold = n;
        end
        if (n-nLastAboveThreshold) > 30
            nLastAboveThreshold = nan;
            turntableStop(turntableController);
            if strcmp(currentDirection, 'counterclockwise')
                currentDirection = 'clockwise';
            else
                currentDirection = 'counterclockwise';
            end
            turntableStart(currentDirection);
        end
    end
    
    turntableStop();
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