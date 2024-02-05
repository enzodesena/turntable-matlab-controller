function successful = turntableStartAndMonitor(rotationDirection, pinToMonitor, threshold, minimumNumSec, maxNumSec)
    global turntableController;
    if isempty(turntableController)
        error('Looks like there is no turntable controller in the workspace. Please call turntableConnect.');
    end
    
    %% Start rotating
    turntableStart(rotationDirection);
    
    %% Check if reached next tick
    previousVoltage = 0; % Take the average between two readings (for robustness)
    tic;
    while true
        secondsSinceStartedRotation = toc;
        voltage = readVoltage(turntableController.arduinoObj, pinToMonitor);
        if secondsSinceStartedRotation > minimumNumSec
            % Since the turntable may have started rotating while sitting
            % on an angle tag, it ignores the first half second (presumably 
            % it can't rotate 2.5 degrees in less than that)
            if (voltage + previousVoltage)/2 > threshold
                successful = true;
                break
            end
            previousVoltage = voltage;
        end
        if secondsSinceStartedRotation > maxNumSec
            warning('This is taking too long. Stopping..')
            successful = false;
            break
        end
    end
    
    %% Stop turntable
    turntableStop()