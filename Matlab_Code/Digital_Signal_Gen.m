%%
% Notes:
% I will use Timer1 on the ATMEGA 328 chip. This timer has 16-bit resolution.
% 1. The timer's prescaler is set to 8, which provides a 0.5 us timer period.
% 2. The timer is set to Clear Counter on Compare Match mode (CTC).
% 3. The compare conidition is 2000 ticks, at which point an interrupt is generated.
% 4. This interrupt updates the state of a set of digital outputs.
% 5. With the current settings a state update occurs every 1ms.
% 6. Clock signals (GSSCK, GSCKR\B\G, DCSK) must have twice the number of
% samples as their data signals (GSSIN, DCSIN).
% 7. The GSSCK signal must be delayed from the GSSIN signal by at least
% 50ns.


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

ON_tick = [1 1];
one_tick = [1 0];
inv_one_tick = [0 1];
OFF_tick = [0 0];

%% GSSIN
% Will only drive one LED on with 50% duty cycle. Will use R0.
gssin = zeros(GS_BitsPerLED, GS_NLEDPerGroup * GS_NColorGroups); % Create a matrix with 12 x 24 values
gssin(:,24) = [1 0 0 0 0 0 0 0 0 0 0 0];
gssin = reshape(gssin, 1, GS_BitsPerLED  * GS_NLEDPerGroup * GS_NColorGroups);
gssin = [reshape(repmat(gssin,2,1),1,NBitsCommonShiftRegister * 2) OFF_tick OFF_tick];

%% GSSCK
gssck = [repmat(inv_one_tick,1,NBitsCommonShiftRegister) OFF_tick OFF_tick];

%% GSLAT
% 30 MHz max rate
% TH1
% TWH1 > 30 ns
% TSU2
OFF_Time = repmat(OFF_tick,1,NBitsCommonShiftRegister); 
gslat = [OFF_Time one_tick OFF_tick];

%% XBLNK
% TSU1 =  10 ns
% TSU2 = 150 ns
OFF_Time = repmat(OFF_tick,1,NBitsCommonShiftRegister);
XBLNK = [OFF_Time OFF_tick repmat(ON_tick,1,NBitsCommonShiftRegister) OFF_tick OFF_tick]; % 3 OFF_tick to pad. This makes it the same length as GSSCK.

%% GSCKR \ GSCKG \ GSCKB
% 33 MHz max rate
% TSU3 > 40 ns
OFF_Time = repmat(OFF_tick,1,NBitsCommonShiftRegister);
gsck = [OFF_Time OFF_tick 0 repmat(one_tick,1,NBitsCommonShiftRegister) OFF_tick OFF_tick];


%% DCSIN
BitsDC = zeros(1,168); % 7 bits per LED = 7 * 3 * 8
BitsBC = [zeros(1,8) zeros(1,8) [1 0 0 0 0 0 0 0]]; % Brightness control. See Table 10
BitsFC = [0 0 0 0 1 1 1]; % Function control. See Table 11 and 12
BitsUD = zeros(1,17); % User defined data latch. See page 32 and Table 13
dcsin = [BitsDC BitsBC BitsFC BitsUD];
dcsin = reshape(repmat(dcsin,2,1),1,NBitsDBFULAtch * 2);

%% DCSCK
dcsck = [repmat(inv_one_tick,1,NBitsDBFULAtch)];


%% Timing Diagrams
figure(201); clf
handles=zeros(1,7);
%
handles(1)=subplot(7,1,1);
stairs(gssin,'r', 'LineWidth', 2)
title('GSSIN')
grid

%
handles(2)=subplot(7,1,2);
stairs(gssck,'r', 'LineWidth', 2)
title('GSSCK')
grid

%
handles(3)=subplot(7,1,3);
stairs(gslat,'r', 'LineWidth', 2)
title('GSLAT')
grid

%
handles(4)=subplot(7,1,4);
stairs(XBLNK,'r', 'LineWidth', 2)
title('XBLNK')
grid

%
handles(5)=subplot(7,1,5);
stairs(gsck,'r', 'LineWidth', 2)
title('GSCKR,G,B')
grid

%
handles(6)=subplot(7,1,6);
stairs(dcsin,'r', 'LineWidth', 2)
% set(handles(ii),'XLim',[1 432])
title('DCSIN')
grid

%
handles(7)=subplot(7,1,7);
stairs(dcsck,'r', 'LineWidth', 2)
% set(handles(ii),'XLim',[500 600])
title('DCSCK')
grid

%
for ii=1:5
   set(handles(ii),'XLim',[500 600]) 
end

for ii=4:5
    set(handles(ii),'XLim',[1100 1180]) 
end

for ii=4:5
    set(handles(ii),'XLim',[550 650]) 
end
