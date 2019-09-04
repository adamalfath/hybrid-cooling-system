% ----------------------------------------------------------
% HYBRID COOLING SYSTEM
% Adam Alfath, 2018
% 
% Komponen : GUI (Display Only)
% IDE      : MathWorks MATLAB R2017a
% ----------------------------------------------------------

%% INITIALIZATION & LOGGING
clc; clear all; close all;
filepath='D:\Google Drive\03. PROJECT & RESEARCH\13. Thermal & Fluid Physics\Data\Spray Result\Raw Data\F1DC80\Raw\2018-MAY-20_21-39-07_DATA_OUTPUT_USER=ADAM.XLSX';
data=xlsread(filepath);
tx=data([1:500],1); Th=data([1:500],2); Tc=data([1:500],3); Tw=data([1:500],4); V=data([1:500],5);
I=data([1:500],6); P=data([1:500],7); TC=data([1:500],8); PC=data([1:500],9); RHC=data([1:500],10);
TE=data([1:500],11); PE=data([1:500],12); RHE=data([1:500],13); t=seconds(tx);

fig=figure('Name','Spray System Logger GUI','NumberTitle','Off');
drawnow;
warning('Off');
jFig=get(handle(fig),'JavaFrame'); 
jFig.setMaximized(true);
    
    
    subplot(3,3,[1:2,4:5]);
    plot(datenum(t),Th,'r','linewidth',1); hold on;
    plot(datenum(t),Tw,'k','linewidth',1); hold on;
    plot(datenum(t),Tc,'b','linewidth',1); hold off;
    datetick('x','MM:SS','keeplimits');
    title('Object Temperature','FontSize',12);
    xlabel('Time (mm:ss)');
    ylabel('Temperature (\circC)');
    legend({'T_{substrate}','T_{water}','T_{cold}'},'FontSize',8);
    grid on;
    ylim([0,70]);
    
    subplot(3,3,[3,6],'YTick',[],'XTick',[],'YColor','w','XColor','w');
    title('Real-time Data','FontSize',12,'Visible','On');
    info=['Data               = ',num2str(500)];
    text(0.01,1.00,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Elapsed Time       = ',datestr(t(500),'HH:MM:SS:FFF')];
    text(0.01,0.96,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Spray Frequency    = 1Hz'];
    text(0.01,0.92,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Duty Cycle         = 80%'];
    text(0.01,0.88,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    
    info=['Temp. Substrate    = ',num2str(Th(500),6),'\circC'];
    text(0.01,0.80,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Temp. Cold Side    = ',num2str(Tc(500),6),'\circC'];
    text(0.01,0.76,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Temp. Water        = ',num2str(Tw(500),6),'\circC'];
    text(0.01,0.72,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    
    info=['Chb. Temperature   = ',num2str(TC(500),6),'\circC'];
    text(0.01,0.64,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Chb. Abs. Pressure = ',num2str(PC(500),6),'kPa'];
    text(0.01,0.60,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Chb. Rel. Humidity = ',num2str(RHC(500),6),'%'];
    text(0.01,0.56,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Env. Temperature   = ',num2str(TE(500),6),'\circC'];
    text(0.01,0.52,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Env. Abs. Pressure = ',num2str(PE(500),6),'kPa'];
    text(0.01,0.48,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Env. Rel. Humidity = ',num2str(RHE(500),6),'%'];
    text(0.01,0.44,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    
    info=['TEC Voltage        = ',num2str(V(500),6),'V'];
    text(0.01,0.36,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['TEC Current        = ',num2str(I(500),6),'A'];
    text(0.01,0.32,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['TEC Power          = ',num2str(P(500),6),'W'];
    text(0.01,0.28,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    
    subplot(3,3,7);
    plot(datenum(t),TC,'r','linewidth',1); hold on;
    plot(datenum(t),TE,'k','linewidth',1); hold off;
    datetick('x','MM:SS','keepticks');
    title('Ambient Temperature','FontSize',12);
    xlabel('Time (mm:ss)');
    ylabel('Temperature (\circC)');
    legend({'T_{chb}','T_{env}'},'FontSize',8);
    grid on;
    
    subplot(3,3,8);
    plot(datenum(t),PC,'r','linewidth',1); hold on;
    plot(datenum(t),PE,'k','linewidth',1); hold off;
    datetick('x','MM:SS','keepticks');
    title('Absolute Pressure','FontSize',12);
    xlabel('Time (mm:ss)');
    ylabel('Pressure (kPa)');
    legend({'P_{chb}','P_{env}'},'FontSize',8);
    grid on;
    
    subplot(3,3,9);
    plot(datenum(t),RHC,'r','linewidth',1); hold on;
    plot(datenum(t),RHE,'k','linewidth',1); hold off;
    datetick('x','MM:SS','keepticks');
    title('Relative Humidity','FontSize',12);
    xlabel('Time (mm:ss)');
    ylabel('RH (%)');
    legend({'RH_{chb}','RH_{env}'},'FontSize',8);
    grid on;


%% RESULT DISPLAY

clc; clear all; close all;
filepath='D:\Google Drive\03. PROJECT & RESEARCH\13. Thermal & Fluid Physics\Data\Spray Result\Raw Data\F1DC80\Raw\2018-MAY-20_21-39-07_DATA_OUTPUT_USER=ADAM.XLSX';
data=xlsread(filepath);
tx=data(:,1); Th=data(:,2); Tc=data(:,3); Tw=data(:,4); V=data(:,5); I=data(:,6); P=data(:,7);
TC=data(:,8); PC=data(:,9); RHC=data(:,10); TE=data(:,11); PE=data(:,12); RHE=data(:,13);
t=seconds(tx);

fig=figure('Name','Spray System Logger GUI','NumberTitle','Off');
drawnow;
warning('Off');
jFig=get(handle(fig),'JavaFrame'); 
jFig.setMaximized(true);

subplot(3,3,[1:2,4:5]);
plot(datenum(t),Th,'r','linewidth',1); hold on;
plot(datenum(t),Tw,'k','linewidth',1); hold on;
plot(datenum(t),Tc,'b','linewidth',1); hold off;
datetick('x','MM:SS','keepticks');
title('Plot Temperature','FontSize',20);
xlabel('Time (mm:ss)');
ylabel('Temperature (\circC)');
legend('T_{substrate}','T_{water}','T_{cold}');
grid on;
ylim([0,70]);
xlim([min(datenum(t)) max(datenum(t))]);

subplot(3,3,[3,6],'YTick',[],'XTick',[],'YColor','w','XColor','w');
title('Information','FontSize',20,'Visible','On');
info=['GENERAL'];
text(0.01,1.00,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['User           = ADAM'];
text(0.01,0.96,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Date           = 20 May 2018'];
text(0.01,0.92,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Data Acquired  = 1612'];
text(0.01,0.88,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Duration       = 00:30:29:660'];
text(0.01,0.84,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Frequency      = 1 Hz'];
text(0.01,0.80,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Duty Cycle     = 80 %'];
text(0.01,0.76,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['INITIAL WORKING CONDITION'];
text(0.01,0.68,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Time           = 21:08:36:861'];
text(0.01,0.64,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Temperature    = 27.57\circC'];
text(0.01,0.60,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Abs. Pressure  = 9288.28kPa'];
text(0.01,0.56,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Rel. Humidity  = 68.6504%'];
text(0.01,0.52,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['FINAL WORKING CONDITION'];
text(0.01,0.44,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Time           = 21:39:07:544'];
text(0.01,0.40,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Temperature    = 28.66\circC'];
text(0.01,0.36,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Abs. Pressure  = 9288.22kPa'];
text(0.01,0.32,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Rel. Humidity  = 68.6504%'];
text(0.01,0.28,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');

subplot(3,3,7);
plot(datenum(t),TC,'r','linewidth',1); hold on;
plot(datenum(t),TE,'k','linewidth',1); hold off;
datetick('x','MM:SS','keepticks');
title('Ambient Temperature','FontSize',12);
xlabel('Time (mm:ss)');
ylabel('Temperature (\circC)');
legend({'T_{chb}','T_{env}'},'FontSize',8);
grid on;
xlim([min(datenum(t)) max(datenum(t))]);

subplot(3,3,8);
plot(datenum(t),PC,'r','linewidth',1); hold on;
plot(datenum(t),PE,'k','linewidth',1); hold off;
datetick('x','MM:SS','keepticks');
title('Absolute Pressure','FontSize',12);
xlabel('Time (mm:ss)');
ylabel('Pressure (kPa)');
legend({'P_{chb}','P_{env}'},'FontSize',8);
grid on;
xlim([min(datenum(t)) max(datenum(t))]);

subplot(3,3,9);
plot(datenum(t),RHC,'r','linewidth',1); hold on;
plot(datenum(t),RHE,'k','linewidth',1); hold off;
datetick('x','MM:SS','keepticks');
title('Relative Humidity','FontSize',12);
xlabel('Time (mm:ss)');
ylabel('RH (%)');
legend({'RH_{chb}','RH_{env}'},'FontSize',8);
grid on;
xlim([min(datenum(t)) max(datenum(t))]);
