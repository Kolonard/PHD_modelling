
% top level modelling parameters 
clear all
close all
clc

task.modelMode          = 'SELFGENERATE';% SELFGENERATE - generating trajectoty parameters in DO229 style
                                    % EXTERNALGENR - read trajectory
                                    % parameters from file
task.psdDistortionModel = 'REAL_STYLE';  % DO229STYLE - gaussian model with left&right sides
                                    % REAL_STYLE - gaussian model with ONLY right side

%check & create folders for modelling results
if checkFolder()
    error("Folders for resultats not exsisted and can't be created")
end
                                    
                                    

global timeStep timeDuration
    timeStep     = 0.1; % [sec]
    timeDuration = 1200; % [sec] // 20 minuts * 60 seconds
    
    velocityMax = 40;   %[m/sec] 
    altMax      = 1200; %[m]
% modelling sub parameters 
    ITERATIONS_COUNT = 0;
% variables
    IterationNumber  = 0;
% IC algorithm configuration
    intCtrl_timeInterval = 10;
    horizontalProtectionLevel = 16;%[m] %0.01 marine mile   

% Cnovert configuration
    if     task.psdDistortionModel == 'DO229STYLE'
                psdDistortionModel = 0;
    elseif task.psdDistortionModel == 'REAL_STYLE'
                psdDistortionModel = 1;
    else
                error('ERROR: wrong PSD model type (check DO229STYLE||REAL_STYLE)')
    end
    if     task.modelMode == 'SELFGENERATE'
                modelMode =  'SELFGENERATE';
    elseif task.modelMode == 'EXTERNALGENR'
                modelMode =  'EXTERNALGENR';
    else
                error('ERROR: wrong mode type (check SELFGENERATE||EXTERNALGENR)')
    end
   clear task
   
while 1
%check mode( 0 - self generated traj, 1 - extern traj )    
%    add variavitivity 
    tic
    fprintf('iteration %i begin\n',IterationNumber)
    if modelMode == 'SELFGENERATE'
        
        if randi(2,1)  ==  2 % 50% cases with rotation
            dhdg =  deg2rad (randn(1) ./ 2.5); % random angle speed from -1.5 to 1.5 deg per sec
            dpth = 0; drll = 0;
        else
            dhdg = 0; dpth = 0; drll = 0;
        end
    %set search parameters
        K_fastCircle_psd     = get_rndValue(1,0.1,7);
        K_fastCircle_psd_dot = K_fastCircle_psd;%get_rndValue(3,0.1,5);
        K_slowWindow         = get_rndValue(2,1,200);
        K_slowSensivity      = 0.98;    

        tracker; % generate new track file
        if checkTrack(lat, lon, alt)%check correct track parameters
            continue; 
        end 
%         delete('Z:\track_normal.mat');
%         save(  'Z:\track_normal.mat');
    elseif modelMode == 'EXTERNALGENR'
            
        K_fastCircle_psd     = 8;
        K_fastCircle_psd_dot = 20;
        K_slowWindow         = 10;
        K_slowSensivity      = 0.98;
        
        extData = load('RealFlight/SVOtoMSK.mat');
        
        acc = extData.tied_acc';
        grs = extData.tied_grs';
        
        hdg = extData.heading';
        pth = extData.pitch';
        rll = extData.roll';
        
        Ve = extData.lla_vel(:,2)';
        Vn = extData.lla_vel(:,1)';
        Vh = extData.lla_vel(:,3)';

        lat = extData.lla_pos(:,1)';
        lon = extData.lla_pos(:,2)';
        alt = extData.lla_pos(:,3)';
        
        timeStamp = extData.time';
        
        velocity = 0;
        velocityMax = max(Ve.^2 + Vn.^2 + Vh.^2);
        altMax = max(alt);
        timeInitial   = 0;
        timeDuration = max(extData.time);
        
        pnt = length(extData.time);
        dhdg = 0; dpth = 0; drll = 0;
        clear extData;
    else 
        error('wrong input parameter in  --modelmode--')
    end
%set corruption 
    corruptErrorType = 2;%randi(2,1);
    switch corruptErrorType
        case 1 %step
            corruptPSDError = randi(1200) / 100 + 8;
        case 2 %ramp
            corruptPSDError = 5;%randi(400) / 100 + 1.0;
        otherwise    
            corruptPSDError = 0;
    end
    corruptSatCount  = randi(3) + 2;
    corruptTimeStart = timeDuration*0.1 + randi(int32(timeDuration - timeDuration*0.4));
%final prepear to modelling
    delete('Z:\track_normal.mat');
    save(  'Z:\track_normal.mat');
%ask to simulink
    simout = sim('SimFiles/base_model_lqeH',timeDuration - 10);   

    result = checkResult(intCtrl_status, intCtrl_timeInterval,...
                         corruptTimeStart, corruptSatCount,...
                         crdErr, ... 
                         satVisibleCount, ...
                         horizontalProtectionLevel,...
                         timeStamp);

    res_falseAlarmCounter = result(3);
    res_missDetection     = result(2);
    res_passAlarm         = result(1);                 
%prepear for iteration save
    start_position        = [lat(1,1), lon(1,1), alt(1,1)];
    start_velicity        = [Ve(1,1) , Vn(1,1) , Vh(1,1)];
    start_orientation     = [hdg(1,1), pth(1,1), rll(1,1)];
    end_position          = [lat(1,1) + lat_err(end,1),...
                             lon(1,1) + lon_err(end,1),...
                             alt(1,1) + alt_err(end,1)];   
    end_velocity          = [Ve(1,1) + Ve_err(end,1),...
                             Vn(1,1) + Vn_err(end,1),...
                             Vh(1,1) + Vh_err(end,1)];
    end_orientation       = [hdg(1,1) + heading_err(end,1),...
                             pth(1,1) + pitch_err(end,1),...
                             rll(1,1) + roll_err(end,1)]; 
    
    varlist = {'start_position', 'start_position', 'start_orientation',...
               'end_position'  , 'end_velocity'  , 'end_orientation'  ,...
               'corruptPSDError', 'corruptSatCount', 'corruptTimeStart', 'corruptErrorType',...
               'K_fastCircle_psd', 'K_fastCircle_psd_dot','K_slowSensivity','K_slowWindow',...
               'timeDuration', 'timeInitial',...
               'IterationNumber',...
               'res_falseAlarmCounter', 'res_missDetection', 'res_passAlarm',...
               'intCtrl_status', 'intCtrl_timeInterval','horizontalProtectionLevel'...
               'crdErr','satVisibleCount','modelMode', 'psdDistortionModel'};    
           
    if isnan(end_position(1)) || crdErr(end) >= 10000
        clc;
        fprintf('Nan found in model\n\n');
        continue;
        %timeMark = datetime('now','Format',"yyyy-MM-dd-HH-mm-ss");
        %fname = strcat('bad_results\',string(timeMark),'.mat') ;
        %save(fname,varlist{:});
        %fname = strcat('bad_results\bad_traj',string(timeMark),'.mat') ;
        %copyfile 'Z:\track_normal.mat' 'bad_results\'
        %movefile('bad_results\track_normal.mat', fname);
    else    
        fname = strcat('results\',string(datetime('now','Format',"yyyy-MM-dd-HH-mm-ss")), string(randi(10000)),'.mat') ;
        save(fname,varlist{:});
    end
    fprintf('Time per iteration %4.1f seconds\n\n',toc);
    IterationNumber = IterationNumber + 1;
    
    clearvars -except IterationNumber ITERATIONS_COUNT intCtrl_timeInterval...
                      velocityMax altMax timeDuration timeStep ...
                      horizontalProtectionLevel modelMode...
                      psdDistortionModel
end

function value = get_rndValue(lowerLimit, step, upperLimit)
% return uniform disturbet value from 'lowerLimit' to 'upperLimit' with setp 'step'
    xVar  = lowerLimit:step:upperLimit;
    value = xVar(randi([1,length(xVar)],1));
end

function result = checkTrack(lat, lon, alt)
    result = 0;
    if find( lat >  1.5708 )  result = 1; end% 1.5708 rad = 90 deg
    if find( lat < -1.5708 )  result = 1; end
    if find( lon >= 6.2832 )  result = 1; end% 6.2832 rad = 360 deg
    if find( lon <  0      )  result = 1; end
    if find( alt < -10     )  result = 1; end
end
%--------------------------------------------------------------------------
function result = checkResult(intCtrl_status, intCtrl_timeInterval,...
                              corruptTimeStart, corruptSatCount,...
                              crdErr, ... 
                              satVisibleCount, ...
                              horizontalProtectionLevel,...
                              timeStamp)
    result = zeros(3,1); % pass, miss detect, false alert
    for ii = 1:length(intCtrl_status)
        %#1
        if intCtrl_status(ii)  == 0        &&...
           corruptTimeStart    >  timeStamp(ii) - timeStamp(1) &&...% curent time earlier corruptTimeStart
           satVisibleCount(ii) < 5
                result(1) = 1; %correct allert
                break; 
        end
        %#2
        if intCtrl_status(ii)  == 0        &&...
           corruptTimeStart    >  timeStamp(ii) - timeStamp(1) &&...
           satVisibleCount(ii) >= 5
                result(3) = 1; %false allert
                break;
        end    
        %#3
        if intCtrl_status(ii)  == 0         &&...
           corruptTimeStart    <= timeStamp(ii) - timeStamp(1) &&...
           crdErr(ii)          <= horizontalProtectionLevel
                result(1) = 1;
                break;%correct allert 
        end  
        %#4
        if intCtrl_status(ii)  == 0         &&...
           corruptTimeStart    <= timeStamp(ii) - timeStamp(1) &&...
           crdErr(ii)          >  horizontalProtectionLevel &&...
           corruptTimeStart + intCtrl_timeInterval > timeStamp(ii) % не выход за интервал
                result(1) = 1;
                break;%correct allert 
        end 
        %#5
        if intCtrl_status(ii)  == 0         &&...
           corruptTimeStart    <= timeStamp(ii) - timeStamp(1) &&...
           crdErr(ii)          >  horizontalProtectionLevel &&...
           corruptTimeStart + intCtrl_timeInterval <= timeStamp(ii) % выход за интервал
                result(3) = 1; 
                break;
        end
        %#6
        if (intCtrl_status(ii) == 1                           &&...
            corruptTimeStart   >   timeStamp(ii) - timeStamp(1)&&...
            crdErr(ii)         <=  horizontalProtectionLevel)
                continue;
        end
        %#7
        if intCtrl_status(ii)  == 1         &&...
           corruptTimeStart    >  timeStamp(ii) - timeStamp(1) &&...
           crdErr(ii)          >  horizontalProtectionLevel &&...
           corruptTimeStart + intCtrl_timeInterval >= timeStamp(ii)
                continue;
        end
        %#8
        if intCtrl_status(ii)  == 1         &&...
           corruptTimeStart    >   timeStamp(ii) - timeStamp(1) &&...
           crdErr(ii)          >  horizontalProtectionLevel &&...
           corruptTimeStart + intCtrl_timeInterval < timeStamp(ii)
                result(2) = 1; 
                break;
        end
        %#9
        if intCtrl_status(ii)  == 1         &&...
           corruptTimeStart    <=  timeStamp(ii) - timeStamp(1) &&...
           crdErr(ii)          <=  horizontalProtectionLevel
                continue;
        end
        %#10
        if intCtrl_status(ii)  == 1         &&...
           corruptTimeStart    <= timeStamp(ii) - timeStamp(1) &&...
           crdErr(ii)          >  horizontalProtectionLevel &&...
           corruptTimeStart + intCtrl_timeInterval >= timeStamp(ii)
                continue;
        end
        %#11
        if intCtrl_status(ii)  == 1         &&...
           corruptTimeStart    <= timeStamp(ii) - timeStamp(1) &&...
           crdErr(ii)          >  horizontalProtectionLevel &&...
           corruptTimeStart + intCtrl_timeInterval < timeStamp(ii)
                result(2) = 1; 
                break;
        end
    end
end

function result = checkFolder()
    result = 0;
    if not(isfolder('results'))
        [SUCCESS, ~ , ~ ] = mkdir('results');
        result = result + not(SUCCESS);
    end  
    if not(isfolder('bad_results'))
        [SUCCESS, ~ , ~ ] = mkdir('bad_results');
        result = result + not(SUCCESS);
    end
end


%--------------------------------------------------------------------------
%{
function result = checkResult(intCtrl_status, intCtrl_timeInterval,...
                              corruptTimeStart, corruptSatCount,...
                              satVisibleCount, ...
                              timeStep)
    
    result = zeros(3,1); % pass, miss detect, false alert
    for ii = 1:length(intCtrl_status)    
        if result(1) == 0 %catch first signal
            if intCtrl_status(ii) == 1 && ... % no integrity flag     #1
               corruptTimeStart > ii * timeStep &&... % corrupt disable
               satVisibleCount(ii) < 5 %not sats
                    result(2) = 1; % miss detection
                    result(1) = 1;
            end
            if intCtrl_status(ii) == 1 && ... % no integrity flag     #2 
               corruptTimeStart <= ii * timeStep &&... % corrupt enable
               satVisibleCount(ii) - corruptSatCount < 5 &&...%not sats
               corruptTimeStart + intCtrl_timeInterval < ii * timeStep % break interval
                    result(2) = 1; % miss detection
                    result(1) = 1;
            end
            if intCtrl_status(ii) == 0 && ... % integrity flag        #3
               corruptTimeStart > ii * timeStep &&... % corrupt disable
               satVisibleCount(ii) < 5% no sats     
                    result(1) = 1; %pass
            end
            if intCtrl_status(ii) == 0 && ... % integrity flag        #4
               corruptTimeStart > ii * timeStep &&... % corrupt disable
                satVisibleCount(ii) >= 5% no sats     
                    result(3) = 1; %false alert               
                    result(1) = 1;
            end
            if intCtrl_status(ii) == 0 && ... % integrity flag        #5
               corruptTimeStart <= ii * timeStep &&... % corrupt enable
               satVisibleCount(ii) - corruptSatCount >= 5% enought sats     
                    result(3) = 1; %false alert
                    result(1) = 1;
            end
            if intCtrl_status(ii) == 0 && ... % integrity flag        #6
               corruptTimeStart <= ii * timeStep &&... % corrupt enable
               satVisibleCount(ii) - corruptSatCount < 5 &&...  % no sats 
               corruptTimeStart  + intCtrl_timeInterval <= ii * timeStep %break interval
                    result(2) = 1; %miss detect
                    result(1) = 1;
            end
            if intCtrl_status(ii) == 0 && ... % integrity flag        #7
               corruptTimeStart <= ii * timeStep &&... % corrupt enable
               satVisibleCount(ii) - corruptSatCount < 5 &&...  % no sats 
               corruptTimeStart  + intCtrl_timeInterval > ii * timeStep %in interval
                    result(1) = 1;%    pass                                    
            end
        end
    end
end
%}

