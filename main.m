
% top level modelling parameters 
clear all
clc

global timeStep timeDuration
    timeStep     = 0.1; % [sec]
    timeDuration = 1200; % [sec] // 20 minuts * 60 seconds
    
    velocityMax = 40;   %[m/sec] 
    altMax      = 1200; %[m]
% modelling sub parameters 
    ITERATIONS_COUNT = 0;

% variables
    iterations       = 0;
    timeToDisplay    = 1;
    corruptPSDError  = 0; % amplitude of pseudorange error
    corruptSatCount  = 0;
    corruptTimeStart = 0;
    corruptErrorType = 0;
    
    K_fastCircle_psd     = 0;
    K_fastCircle_psd_dot = 0;
    K_slowWindow         = 0;
    K_slowSensivity      = 0;
    
%get trajectory parameters

while (iterations <= ITERATIONS_COUNT)
%    add variavitivity 
    tic
    fprintf('iteration %i begin\n',iterations)
    if randi(2,1)  ==  2 % 50% cases with rotation
        dhdg =  deg2rad (randn(1) ./ 2.5); % random angle speed from -1.5 to 1.5 deg per sec
        dpth = 0; drll = 0;
    else
        dhdg = 0; dpth = 0; drll = 0;
    end
    
%set search parameters

    K_fastCircle_psd     = get_rndValue(3,0.1,5);
    K_fastCircle_psd_dot = get_rndValue(3,0.1,5);
    K_slowWindow         = get_rndValue(5,1,120);
    K_slowSensivity      = 0.4;
    
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
    save('Z:\track_normal.mat');
    
    sim('base_model_lqeH',timeDuration - 10);   

    
    
    varlist = {'lat(1)',  'lat(end)','lon(1)', 'lon(end)','alt(1)', 'alt(end)',...
               'velocity','Ve(end)', 'Vn(1)',  'Vn(end)', 'Vh(1)',  'Vh(end)',...
               'corruptPSDError', 'corruptSatCount', 'corruptTimeStart', 'corruptErrorType',...
               };    
           

	fname = strcat('projjectile',string(datetime('now','Format',"yyyy-MM-dd-HH-mm-ss")),'.mat') ;
    save(fname,varlist{:});
   
    fprintf('time per one iteration %4.1f seconds\n\n',toc);
    iterations = iterations + 1;
    
    clearvars -except iterations ITERATIONS_COUNT timeToDisplay...
                      velocityMax altMax timeDuration timeStep
end

function value = get_rndValue(lowerLimit, step, upperLimit)
% return uniform disturbet value from 'lowerLimit' to 'upperLimit' with setp 'step'
    xVar = lowerLimit:step:upperLimit;
    value = xVar(randi([1,length(xVar)],1));
end