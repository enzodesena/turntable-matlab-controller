% turntablePrivateStartAndMonitor Turntable start and monitor function 
% (private function)
% 
% turntablePrivateStartAndMonitor(DIRECTION, PINTOMONITOR, THRESHOLD, 
% MINIMUMNUMSEC, MAXNUMSEC) Starts rotating the 
% turntable while monitoring a certain voltage pin on the Arduino. The
% turntable will stop if the average of two readings on PINTOMONITOR is 
% above THRESHOLD (in volts). 
% 
% DIRECTION can either be 'clockwise' or 'counterclockwise'.
% PINTOMONITOR is the pin to be monitored on the Arduino (e.g. 'A3')
% THRESHOLD is the threshold (in volts) above which the turntable will be 
% stopped.
% MINIMUMNUMSEC is the duration before which values above the threshold are
% ignored; this is included such that in case the turntable is already
% transitioning through an angle it will not stop immediately.
% MAXNUMSEC is the duration after which the turntable will give up on
% continuing to rotate.
%
%
% Author: Enzo De Sena
% Date 3/2/2024
function successful = turntablePrivateStartAndMonitor(rotationDirection, pinToMonitor, threshold, minimumNumSec, maxNumSec)
    global turntableController;
    if isempty(turntableController)
        error('Looks like there is no turntable controller in the workspace. Please call turntableConnect.');
    end
    
    %% Start rotating
    turntablePrivateStart(rotationDirection);
    
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
    turntablePrivateStop()