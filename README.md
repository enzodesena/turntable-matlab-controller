# IoSR Turntable Matlab Controller

This small piece of software is meant to control one of the IoSR turntables (an old Outline turntable) without need of the Outline control unit. We replaced that with an Arduino with a Motor Shield, and some simple circuitery. This implementation uses Matlab and the Matlab-Arduino package.

## Install

First, you need to install the Matlab-Arduino package, either using [Mathworks download link](https://uk.mathworks.com/matlabcentral/fileexchange/47522-matlab-support-package-for-arduino-hardware). Alternatively, and perhaps more simply, type `arduino` in the Matlab shell, and you should be asked whether you want to install it. Then download this package wherever you want, possibly [adding it to your search path](https://uk.mathworks.com/help/matlab/matlab_env/add-remove-or-reorder-folders-on-the-search-path.html) if you like. 

Note: the current Matlab/Arduino interface only runs on Intel processors (or emulators). So, if you have a Mac with Apple Silicon, you can only use Matlab R2022a or earlier, since versions after that run natively on Apple Silicon and do not use Rosetta. 

## Usage

Typical usage is to run:
```Matlab
turntableConnect(); % This connects Matlab to the Arduino.
turntableToZero();  % This rotates the turntable to zero degrees
turntableTick();    % This ticks the turntable by 2.5 degrees clockwise
disp(['The turntable is currently at ', num2str(turntableGetAngle()), ' degrees']); % Shows the current angle
turntableDisconnect(); % Disconnects the arduino
```

You can take a look at the help of each function for more information.

This package uses a global struct called `turntableController`, which contains the state of the turntable and the Arduino object. Although global variables are not  great in terms of good coding practice, in this case perphaps it is ok since this is likely a singleton (I doubt anyone would ever use more than one turntable with this piece of software) and that it makes its API quite a bit simpler (instead of passing back and forth input/output variables). 

## License

This is on an MIT license (not that someone would care! :-)). 
