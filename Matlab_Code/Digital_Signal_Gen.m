%% Parameters
NBitsCommonShiftRegister = 288;
NBitsDBFULAtch = 216;
GS_BitsPerLED = 12;
GS_NLEDPerGroup = 8;
GS_NColorGroups = 3;
DBFU_BitsDC = 161;
DBFU_BitsBC = 24;
DBFU_BitsFC = 7;
DBFU_BitsUD = 17;

one_tick = [1 0];
delay = [0 0];

%% XBLNK
% TSU1 =  10 ns
% TSU2 = 150 ns
OFF_Time = zeros(1,NBitsCommonShiftRegister * 2); 
XBLNK = [OFF_Time delay one_tick];

%% GSLAT
% 30 MHz max rate
% TH1
% TWH1 > 30 ns
% TSU2
OFF_Time = zeros(1,NBitsCommonShiftRegister * 2); 
gslat = [OFF_Time one_tick];

%% GSSCK
gssck = [repmat(one_tick,1,NBitsCommonShiftRegister) delay delay];


%% GSCKR \ GSCKG \ GSCKB
% 33 MHz max rate
OFF_Time = zeros(1,NBitsCommonShiftRegister * 2); 
gsck = [OFF_Time delay delay repmat(one_tick,1,NBitsCommonShiftRegister)];

%% GSSIN
% Will only drive one LED on with 50% duty cycle. Will use R0.
gssin = zeros(GS_BitsPerLED, GS_NLEDPerGroup * GS_NColorGroups * 2);
gssin(:,24) = [1 0 0 0 0 0 0 0 0 0 0 0];
gssin = reshape(gssin,1,GS_BitsPerLED  * GS_NLEDPerGroup * GS_NColorGroups);

%% DCSCK
OFF_Time = zeros(1,NBitsDBFULAtch * 2); 
dcsck = [OFF_Time delay delay delay];

%% DCSIN
BitsDC = zeros(1,161); % 7 bits per LED = 7 x 3 * 8
BitsBC = [zeros(1,8) zeros(1,8) [1 0 0 0 0 0 0 0]]; % Brightness control. See Table 10
BitsFC = [0 0 0 0 1 1 1]; % Function control. See Table 11 and 12
BitsUD = zeros(1,16); % User defined data latch. See page 32 and Table 13


%% Timing Diagrams
figure(201); clf
%
h=subplot(7,1,1);
stairs(XBLNK,'r', 'LineWidth', 2)
title('XBLNK')
set(h,'XLim',[560 590])
grid

%
subplot(7,1,2)
stairs(gslat,'r', 'LineWidth', 2)
title('GSLAT')
set(gca,'XLim',[560 590])
grid

%
subplot(7,1,3)
stairs(gssck,'r', 'LineWidth', 2)
title('GSSCK')
set(gca,'XLim',[560 590])
grid

%
subplot(7,1,4)
stairs(gsck,'r', 'LineWidth', 2)
title('GSCKR,G,B')
set(gca,'XLim',[1100 1200])
grid

%
subplot(7,1,5)
stairs(gssin,'r', 'LineWidth', 2)
title('GSSIN')
set(gca,'XLim',[0 1160])

%
subplot(7,1,6)

title('DCSCK')


%
subplot(7,1,7)

title('DCSIN')


