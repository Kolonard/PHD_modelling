
% top level modelling parameters 
clear all
bdclose all
close all
clc

global timeStep timeDuration
    timeStep     = 0.1; % [sec]
    timeDuration = 1200; % [sec] // 20 minuts * 60 seconds
    
    velocityMax = 40;   %[m/sec] 
    altMax      = 1200; %[m]
% modelling sub parameters 
    ITERATIONS_COUNT = 10;

% variables
    IterationNumber       = 0;
%     timeToDisplay    = 1;
    corruptPSDError  = 0; % amplitude of pseudorange error
    corruptSatCount  = 0;
    corruptTimeStart = 0;
    corruptErrorType = 0;
    
    K_fastCircle_psd     = 0;
    K_fastCircle_psd_dot = 0;
    K_slowWindow         = 0;
    K_slowSensivity      = 0;
    
%get trajectory parameters

while (IterationNumber <= ITERATIONS_COUNT)
%    add variavitivity 
    tic
    fprintf('iteration %i begin\n',IterationNumber)
    if randi(2,1)  ==  2 % 50% cases with rotation
        dhdg =  deg2rad (randn(1) ./ 2.5); % random angle speed from -1.5 to 1.5 deg per sec
        dpth = 0; drll = 0;
    else
        dhdg = 0; dpth = 0; drll = 0;
    end
    
%set search parameters

    K_fastCircle_psd     = get_rndValue(3,0.1,7);
    K_fastCircle_psd_dot = K_fastCircle_psd;%get_rndValue(3,0.1,5);
    K_slowWindow         = get_rndValue(5,1,120);
    K_slowSensivity      = get_rndValue(0.98,0.01,1);
     
%set corruption    
    corruptErrorType = 0;%randi(3,1);
    if     corruptErrorType == 1
        %step
        corruptPSDError = randi(500) / 100;
    elseif corruptErrorType == 2
        %ramp
        corruptPSDError = randi(500) / 100;
    else
        %no error
        corruptPSDError = 0;
    end
    corruptSatCount  = randi(3);
    corruptTimeStart = timeDuration*0.1 + randi(timeDuration - timeDuration*0.4);
    
%new track file
    tracker;
    delete('Z:\track_normal.mat');
    cnt = 0; for ii = 1: 10000 cnt = cnt * ii; end; clear cnt ii;% fuck matlab   
    save('Z:\track_normal.mat');
    cnt = 0; for ii = 1: 10000 cnt = cnt * ii; end; clear cnt ii;% fuck matlab
    simout = sim('base_model_lqeH',timeDuration - 10);   
    cnt = 0; for ii = 1: 10000 cnt = cnt * ii; end; clear cnt ii; % fuck matlab
    bdclose all
%reset memspace for results
    res_falseAlarmCounter = 0;
    res_missDetection     = 0;
    res_passAlarm         = 0;
    
%searh Integrity Control signals
    for ii = 2:((timeDuration - 10) / timeStep )
        if ((intCtrl_status(ii) == 0) && (intCtrl_status(ii-1) == 1))
            if ( ii * timeStep < corruptTimeStart ) % time of event
                % False alarm (alarm before event)
                res_falseAlarmCounter = res_falseAlarmCounter + 1;
            elseif ( ii * timeStep > corruptTimeStart + 10 ) && (res_passAlarm == 0) %DO-229 hard criteria (10 seconds for alarm)
                %miss detection (no alarm in specified time)
                res_missDetection = res_missDetection + 1; 
            else 
                %alarm set in specifid time
                res_passAlarm = res_passAlarm + 1; 
            end
        end
    end
    
%prepear for iteration save
    start_position    = [lat(1,1), lon(1,1), alt(1,1)];
    start_velicity    = [Ve(1,1) , Vn(1,1) , Vh(1,1)];
    start_orientation = [hdg(1,1), pth(1,1), rll(1,1)];
    end_position      = [lat(1,1) + lat_err(end,1),...
                         lon(1,1) + lon_err(end,1),...
                         alt(1,1) + alt_err(end,1)];   
    end_velocity      = [Ve(1,1) + Ve_err(end,1),...
                         Vn(1,1) + Vn_err(end,1),...
                         Vh(1,1) + Vh_err(end,1)];
    end_orientation   = [hdg(1,1) + heading_err(end,1),...
                         pth(1,1) + pitch_err(end,1),...
                         rll(1,1) + roll_err(end,1)]; 
    
    varlist = {'start_position', 'start_position', 'start_orientation',...
               'end_position'  , 'end_velocity'  , 'end_orientation'  ,...
               'corruptPSDError', 'corruptSatCount', 'corruptTimeStart', 'corruptErrorType',...
               'K_fastCircle_psd', 'K_fastCircle_psd_dot','K_slowSensivity','K_slowWindow',...
               'timeDuration', 'timeInitial',...
               'IterationNumber',...
               'falseAlarmCounter', 'missDetection', 'passAlarm', 'intCtrl_status'};    
           

	fname = strcat('Z:\results\',string(datetime('now','Format',"yyyy-MM-dd-HH-mm-ss")),'.mat') ;
    save(fname,varlist{:});
   
    fprintf('time per one iteration %4.1f seconds\n\n',toc);
    IterationNumber = IterationNumber + 1;
    
    clearvars -except IterationNumber ITERATIONS_COUNT...
                      velocityMax altMax timeDuration timeStep
end

function value = get_rndValue(lowerLimit, step, upperLimit)
% return uniform disturbet value from 'lowerLimit' to 'upperLimit' with setp 'step'
    xVar = lowerLimit:step:upperLimit;
    value = xVar(randi([1,length(xVar)],1));
end