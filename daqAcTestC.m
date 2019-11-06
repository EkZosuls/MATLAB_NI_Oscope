%never ending data collector
%Aleks Zosuls Boston University 2016
% Use NI DAQ to collect three channels of analog data
% and save it to disk. The files are broken into reasonable
% chunks to prevent large file issues.
% relies on fileSplitter.m and stopDAC.m

figure(88)
h = gca;
h.Color = 'black';

%% ni stuff%%%%%%%%%%%%%%%%%%%
v = daq.getVendors();
d = daq.getDevices();
s = daq.createSession('ni');
% this version has three input channels....
addAnalogInputChannel(s,'Dev2', 0, 'Voltage');
addAnalogInputChannel(s,'Dev2', 1, 'Voltage');
addAnalogInputChannel(s,'Dev2', 2, 'Voltage');
s.Rate = 1000;  %sample rate
s.IsContinuous = true;  %tell it to run until a stop method is called

%% make data handlers and listeners%%%%%%%%%
FS = fileSplitter(1000000);
FS.newFile;
%lh = addlistener(s,'DataAvailable', @(src,event) plot(event.TimeStamps, event.Data));
%lh = addlistener(s,'DataAvailable', @(src,event,runTimer) moogData(src, event, fileID, runTimer));
lh = addlistener(s,'DataAvailable', @(src,event) FS.accumulateData(event));
s.NotifyWhenDataAvailableExceeds = 2000;
prepare(s);

%% Create push button%%%%%%%%%%%%%
btn = uicontrol('Style', 'pushbutton', 'String', 'Stop DAC',...
    'Position', [20 20 50 20],...
    'Callback', @(src,eventdata)stopDAC(src,eventdata,s,lh,FS));
   % 'Callback', @(src,event)stop(s));

% run until the button gets pushed on the figure then save and clear
% listeners
s.startBackground();







