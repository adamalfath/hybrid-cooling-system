% ----------------------------------------------------------
% HYBRID COOLING SYSTEM
% Adam Alfath, 2018
% 
% Komponen : GUI
% IDE      : MathWorks MATLAB R2017a
% ----------------------------------------------------------

%% INITIALIZATION & LOGGING
clc; clear all; close all;

% User name (1-word)
user='ADAM';   

% Spray Pulse Frequency (Hz)
SF=1; 

% Spray Duty Cycle (%)
SDC=10;                     

% Set Current (A)
ISET=0.2;

if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

%Jalur Data dari Mikrokontroler 1 (Main Unit)
uc1=serial('COM5');
set(uc1,'FlowControl','none');
set(uc1,'BaudRate',9600);
set(uc1,'Parity','none');
set(uc1,'DataBits',8);
set(uc1,'StopBit',1);

%Jalur Data dari Mikrokontroler 2 (Thermocouple DAQ)
uc2=serial('COM8');
set(uc2,'FlowControl','none');
set(uc2,'BaudRate',9600);
set(uc2,'Parity','none');
set(uc2,'DataBits',8);
set(uc2,'StopBit',1);

fopen(uc1);
fopen(uc2);
fprintf('[1] IDLE\n');
while 1
    a=fscanf(uc1,'%s');
    if strcmp(a,'SET_ON')==1
        fprintf(uc2,'%s','SET_ON');
        break
    end
end
fprintf('[2] START\n');

fig=figure('Name','Spray System Logger GUI','NumberTitle','Off');
drawnow;
warning('Off');
jFig=get(handle(fig),'JavaFrame'); 
jFig.setMaximized(true);

n=1;
startTime=datetime('now');

% Data Format uC1 (Parsing)
% [0]Twater;[1]Voltage;[2]Current;[3]Tchamber;[4]RHchamber;[5]Pchamber;[6]Tenv;[7]RHenv;[8]Penv;

% Data Format uC2 (Parsing)
% [0]Tcold;[1]Thot;

% Data Format Gabungan
% [0]Tcold;[1]Thot;[2]Twater;[3]Voltage;[4]Current;[5]Tchamber;[6]RHchamber;[7]Pchamber;
% [8]Tenv;[9]RHenv;[10]Penv;

while 1
    a=fscanf(uc1);
    data=strsplit(a,';');
    flushinput(uc2);
    b=fscanf(uc2);
    datb=strsplit(b,';');
    
    Tc(n)=str2double(datb(1,1));                    % [0]Tcold
    Th(n)=str2double(datb(1,2));                    % [1]Thot
    Tw(n)=str2double(data(1,1));                    % [2]Twater
    V(n)=str2double(data(1,2));                     % [3]Voltage
    I(n)=str2double(data(1,3));                     % [4]Current
    TC(n)=str2double(data(1,4));                    % [5]Tchamber
    RHC(n)=str2double(data(1,5));                   % [6]RHchamber
    PC(n)=str2double(data(1,6));                    % [7]Pchamber
    TE(n)=str2double(data(1,7));                    % [8]Tenv
    RHE(n)=str2double(data(1,8));                   % [9]RHenv
    PE(n)=str2double(data(1,9));                    % [10]Penv
    t(n)=datetime('now')-startTime;
    P(n)=I(n)*V(n);
    
    drawnow;
    clf;
    
    subplot(3,3,[1:2,4:5]);
    plot(datenum(t),Th,'r','linewidth',2); hold on;
    plot(datenum(t),Tw,'k','linewidth',2); hold on;
    plot(datenum(t),Tc,'b','linewidth',2); hold off;
    datetick('x','MM:SS','keeplimits');
    title('Object Temperature','FontSize',12);
    xlabel('Time (mm:ss)');
    ylabel('Temperature (\circC)');
    legend('T_{substrate}','T_{water}','T_{cold}','FontSize',8);
    grid on;
    ylim([0,70]);
    
    subplot(3,3,[3,6],'YTick',[],'XTick',[],'YColor','w','XColor','w');
    title('Real-time Data','FontSize',12,'Visible','On');
    info=['Data               = ',num2str(n)];
    text(0.01,1.00,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Elapsed Time       = ',datestr(t(n),'HH:MM:SS:FFF')];
    text(0.01,0.96,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Spray Frequency    = ',num2str(SF,2),'Hz'];
    text(0.01,0.92,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Duty Cycle         = ',num2str(SDC,2),'%'];
    text(0.01,0.88,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    
    info=['Temp. Substrate    = ',num2str(Th(n),6),'\circC'];
    text(0.01,0.80,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Temp. Cold Side    = ',num2str(Tc(n),6),'\circC'];
    text(0.01,0.76,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Temp. Water        = ',num2str(Tw(n),6),'\circC'];
    text(0.01,0.72,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    
    info=['Chb. Temperature   = ',num2str(TC(n),6),'\circC'];
    text(0.01,0.64,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Chb. Abs. Pressure = ',num2str(PC(n),6),'kPa'];
    text(0.01,0.60,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Chb. Rel. Humidity = ',num2str(RHC(n),6),'%'];
    text(0.01,0.56,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Env. Temperature   = ',num2str(TE(n),6),'\circC'];
    text(0.01,0.52,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Env. Abs. Pressure = ',num2str(PE(n),6),'kPa'];
    text(0.01,0.48,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['Env. Rel. Humidity = ',num2str(RHE(n),6),'%'];
    text(0.01,0.44,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    
    info=['TEC Voltage        = ',num2str(V(n),6),'V'];
    text(0.01,0.36,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['TEC Current        = ',num2str(I(n),6),'A'];
    text(0.01,0.32,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    info=['TEC Power          = ',num2str(P(n),6),'W'];
    text(0.01,0.28,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
    
    subplot(3,3,7);
    plot(datenum(t),TC,'r','linewidth',2); hold on;
    plot(datenum(t),TE,'k','linewidth',2); hold off;
    datetick('x','MM:SS','keeplimits');
    title('Ambient Temperature','FontSize',12);
    xlabel('Time (mm:ss)');
    ylabel('Temperature (\circC)');
    legend({'T_{chb}','T_{env}'},'FontSize',8);
    grid on;
    
    subplot(3,3,8);
    plot(datenum(t),PC,'r','linewidth',2); hold on;
    plot(datenum(t),PE,'k','linewidth',2); hold off;
    datetick('x','MM:SS','keeplimits');
    title('Absolute Pressure','FontSize',12);
    xlabel('Time (mm:ss)');
    ylabel('Pressure (kPa)');
    legend({'P_{chb}','P_{env}'},'FontSize',8);
    grid on;
    
    subplot(3,3,9);
    plot(datenum(t),RHC,'r','linewidth',2); hold on;
    plot(datenum(t),RHE,'k','linewidth',2); hold off;
    datetick('x','MM:SS','keeplimits');
    title('Relative Humidity','FontSize',12);
    xlabel('Time (mm:ss)');
    ylabel('RH (%)');
    legend({'RH_{chb}','RH_{env}'},'FontSize',8);
    grid on;
    
    if ~ishghandle(fig)
        break;
    end
    n=n+1;
end 

endTime=datetime('now');

fprintf('[3] PROCESSING\n');
fprintf(uc2,'%s','SET_OFF');
fprintf('    -Total Data   = %d\n    -Elapsed Time = %s\n',n,datestr(max(t),'HH:MM:SS:FFF'));
fclose(uc1);
fclose(uc2);
close;

if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

%% RESULT OUTPUT
info=[datestr(endTime,'yyyy-mmm-dd_HH-MM-SS'),'_DATA_OUTPUT_USER=',user,'.xlsx'];
out1=array2table([seconds(t'),Th',Tc',Tw',V',I',P',TC',PC',RHC',TE',PE',RHE'], ...
    'VariableNames',{'Time_s','TempSubstrate_degC','TempCold_degC','TempWater_degC', ...
    'TECVoltage_V','TECCurrent_A','TECPower_W','ChamberTemp_degC', ...
    'ChamberAbsPres_kPa','ChamberHumid_pctRH','EnvTemp_degC','EnvAbsPres_kPa','EnvHumid_pctRH'});

writetable(out1,upper(info));
fprintf('    -Output File  = %s\n',upper(info));

info=[datestr(endTime,'yyyy-mmm-dd_HH-MM-SS'),'_DATA_INFO_USER=',user,'.txt'];
out2=fopen(upper(info),'w');
fprintf(out2,'========================================================\r\n');
fprintf(out2,'=================== DATA INFORMATION ===================\r\n');
fprintf(out2,'========================================================\r\n\r\n');
fprintf(out2,'GENERAL\r\n');
fprintf(out2,'USER           = %s\r\n',user);
fprintf(out2,'DATE           = %s\r\n',datestr(startTime,'dd mmmm yyyy'));
fprintf(out2,'DATA ACQUIRED  = %d\r\n',n);
fprintf(out2,'DURATION       = %s\r\n',datestr(max(t),'HH:MM:SS:FFF'));
fprintf(out2,'FREQUENCY      = %d Hz\r\n',SF);
fprintf(out2,'DUTY CYCLE     = %d %%\r\n',SDC);
fprintf(out2,'SET CURRENT    = %d A\r\n\r\n',ISET);
fprintf(out2,'INITIAL WORKING CONDITION\r\n');
fprintf(out2,'TIME           = %s\r\n',datestr(startTime,'HH:MM:SS:FFF'));
fprintf(out2,'TEMPERATURE    = %s degC\r\n',num2str(TE(1),6));
fprintf(out2,'PRESSURE       = %s kPa\r\n',num2str(PE(1),6));
fprintf(out2,'REL. HUMIDITY  = %s %%\r\n\r\n',num2str(RHE(1),6));
fprintf(out2,'FINAL WORKING CONDITION\r\n');
fprintf(out2,'TIME           = %s\r\n',datestr(endTime,'HH:MM:SS:FFF'));
fprintf(out2,'TEMPERATURE    = %s degC\r\n',num2str(TE(end),6));
fprintf(out2,'PRESSURE       = %s kPa\r\n',num2str(PE(end),6));
fprintf(out2,'REL. HUMIDITY  = %s %%\r\n\r\n',num2str(RHE(1),6));
fclose(out2);
fprintf('                    %s\n',upper(info));

%% RESULT DISPLAY
fig=figure('Name','Spray System Logger GUI','NumberTitle','Off');
drawnow;
warning('Off');
jFig=get(handle(fig),'JavaFrame'); 
jFig.setMaximized(true);

subplot(3,3,[1:2,4:5]);
plot(datenum(t),Th,'r','linewidth',2); hold on;
plot(datenum(t),Tw,'k','linewidth',2); hold on;
plot(datenum(t),Tc,'b','linewidth',2); hold off;
datetick('x','MM:SS','keepticks');
title('Plot Temperature','FontSize',20);
xlabel('Time (mm:ss)');
ylabel('Temperature (\circC)');
legend('T_{substrate}','T_{water}','T_{cold}');
grid on;
ylim([0,70]);

subplot(3,3,[3,6],'YTick',[],'XTick',[],'YColor','w','XColor','w');
title('Information','FontSize',20,'Visible','On');
info=['GENERAL'];
text(0.01,1.00,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['User           = ',user];
text(0.01,0.96,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Date           = ',datestr(startTime,'dd mmmm yyyy')];
text(0.01,0.92,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Data Acquired  = ',num2str(n)];
text(0.01,0.88,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Duration       = ',datestr(max(t),'HH:MM:SS:FFF')];
text(0.01,0.84,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Frequency      = ',num2str(SF),'Hz'];
text(0.01,0.80,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Duty Cycle     = ',num2str(SDC),'%'];
text(0.01,0.76,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['INITIAL WORKING CONDITION'];
text(0.01,0.68,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Time           = ',datestr(startTime,'HH:MM:SS:FFF')];
text(0.01,0.64,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Temperature    = ',num2str(TE(1),6),'\circC'];
text(0.01,0.60,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Abs. Pressure  = ',num2str(PE(1),6),'kPa'];
text(0.01,0.56,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Rel. Humidity  = ',num2str(RHE(1),6),'%'];
text(0.01,0.52,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['FINAL WORKING CONDITION'];
text(0.01,0.44,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Time           = ',datestr(endTime,'HH:MM:SS:FFF')];
text(0.01,0.40,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Temperature    = ',num2str(TE(end),6),'\circC'];
text(0.01,0.36,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Abs. Pressure  = ',num2str(PE(end),6),'kPa'];
text(0.01,0.32,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');
info=['Rel. Humidity  = ',num2str(RHE(end),6),'%'];
text(0.01,0.28,info,'FontSize',9,'VerticalAlignment','Top','FontName','FixedWidth');

subplot(3,3,7);
plot(datenum(t),TC,'r','linewidth',2); hold on;
plot(datenum(t),TE,'k','linewidth',2); hold off;
datetick('x','MM:SS','keepticks');
title('Ambient Temperature','FontSize',12);
xlabel('Time (mm:ss)');
ylabel('Temperature (\circC)');
legend({'T_{chb}','T_{env}'},'FontSize',8);
grid on;

subplot(3,3,8);
plot(datenum(t),PC,'r','linewidth',2); hold on;
plot(datenum(t),PE,'k','linewidth',2); hold off;
datetick('x','MM:SS','keepticks');
title('Absolute Pressure','FontSize',12);
xlabel('Time (mm:ss)');
ylabel('Pressure (kPa)');
legend({'P_{chb}','P_{env}'},'FontSize',8);
grid on;

subplot(3,3,9);
plot(datenum(t),RHC,'r','linewidth',2); hold on;
plot(datenum(t),RHE,'k','linewidth',2); hold off;
datetick('x','MM:SS','keepticks');
title('Relative Humidity','FontSize',12);
xlabel('Time (mm:ss)');
ylabel('RH (%)');
legend({'RH_{chb}','RH_{env}'},'FontSize',8);
grid on;

fprintf('[4] END\n');