%--------------------------------------------------------------------------
%Description & licensing
%Calculate array of basic trajectory parameters
%--------------------------------------------------------------------------
% clc; clear;
%constants
% global timeStep timeDuration
%     timeStep     = 0.1; % [sec]
%     timeDuration = 1200; % [sec] // 20 minuts * 60 seconds

% altMax   = 1200;%  [m]

%PZ-90.11 parameters
global beta beta1 q ge a e2
    beta  = double(0.0053171);
    beta1 = double(71*10^-7);
    q     = double(0.00346775);
    ge    = double(9.78049);
    a     = double(6378136);
    e2    = double(0.0066943662); 

%--------------------------------------------------------------------------
%variables
    lat = zeros(1, timeDuration / timeStep ); 
    lon = zeros(1, timeDuration / timeStep ); 
    alt = zeros(1, timeDuration / timeStep ); %(lat [deg]    , lon [deg] , alt [m, MSL])
    hdg = zeros(1, timeDuration / timeStep ); 
    pth = zeros(1, timeDuration / timeStep );  
    rll = zeros(1, timeDuration / timeStep );  %(heading [deg], pitch[deg], roll[deg]   )
    Ve  = zeros(1, timeDuration / timeStep );
    Vn  = zeros(1, timeDuration / timeStep );
    Vh  = zeros(1, timeDuration / timeStep );
    
    grs = zeros(3, timeDuration / timeStep + 1);%[0,0,0]; %(X[deg per sec], Y[deg per sec], Z[deg per sec])
    acc = zeros(3, timeDuration / timeStep + 1); %(X[m / sec^2 ] , Y[m / sec^2 ] , Z[m / sec^2 ] )
%     % ang       = [0,0,0]; %(heading [deg] , pitch[deg]    , roll[deg]     )
    pnt       = 1; %[cnt] use for indexing
    timeStamp = 0; %[sec]
%     velocity  = 0;
%     U = 0; Un = 0; Uh = 0;
    
%--------------------------------------------------------------------------
%initial conditions
    lat = deg2rad( get_rndValue(0, 3, 90) );
    lonStep = 360 / ( 360 / min([3/cos(lat),360]) );
    lon = deg2rad( get_rndValue(0, lonStep, 360) );
    alt = get_rndValue(0, 1, altMax);
    %
    timeInitial = get_rndValue(0, 300, 43200); %step 5 minutesв in UTC 00:00:00 - 12:00:00 
    %
    %
    hdg = deg2rad(get_rndValue(0,1,360));
    pth = deg2rad(get_rndValue(0,0.01,0.5));
    rll = deg2rad(get_rndValue(0,1,0));
    %
    velocity = get_rndValue(0,1,velocityMax);
    Vh(pnt) = velocity * sin(deg2rad (pth(pnt)));
    Vhor = sqrt(velocity^2 - Vh(pnt).^2); 
    Vn(pnt) = Vhor * cos(deg2rad (hdg(pnt)));
    Ve(pnt) = Vhor * sin(deg2rad (hdg(pnt)));
    
    
    
%--------------------------------------------------------------------------
%main
    timeStamp(pnt) = timeInitial;
    %todo: add new profiles for angle change
%     dhdg = 0; dpth = 0; drll = 0;
    
    while (timeStamp(pnt) <= timeDuration + timeInitial)
    %recalck new angle
        hdg(pnt + 1) = hdg(pnt) + dhdg*timeStep; 
        pth(pnt + 1) = pth(pnt) + dpth*timeStep; 
        rll(pnt + 1) = rll(pnt) + drll*timeStep;
    %take new velocity proections
        Vh(pnt + 1) = velocity * sin(deg2rad (pth(pnt + 1)));
        Vhor = sqrt(velocity^2 - Vh(pnt + 1).^2); 
        Vn(pnt + 1) = Vhor * cos(deg2rad (hdg(pnt + 1)));
        Ve(pnt + 1) = Vhor * sin(deg2rad (hdg(pnt + 1)));
        
%         Vn(pnt + 1) = velocity * cos(deg2rad (hdg(pnt + 1)));
%         Ve(pnt + 1) = velocity * sin(deg2rad (hdg(pnt + 1)));
%         Vh(pnt + 1) = velocity * 0;
        
    %earth radiuces
        ro_1 = a*(1-e2)/(1-e2*sin(lat(pnt))^2)^(3/2) + alt(pnt);% (rm + h)
        ro_2 = a*(1-e2*sin(lat(pnt))^2)^(-1/2) + alt(pnt);% (rn + h)
    %earth angular velocity
        U =  deg2rad (360 / (23 * 3600 + 56 * 60  + 4.09));
        Un = U*cos(lat(pnt));
        Uh = U*sin(lat(pnt));
   %some calculations
        Omega_E = -Vn(pnt + 1)/ro_1; 
        Omega_N =  Ve(pnt + 1)/ro_2;
        Omega_H = (Ve(pnt + 1)/ro_2)*tan(lat(pnt));   
        
        matr_Omega = zeros(3,3);
        matr_U     = zeros(3,3);
        matr_Omega = [ 0,        Omega_H, -Omega_N;...
                      -Omega_H,  0,        Omega_E;...
                       Omega_N, -Omega_E,  0];
        matr_U     = [ 0,  Uh, -Un;...
                      -Uh, 0,   0;...
                       Un, 0,   0];
        future_matDirCos  = get_matDirCos(hdg(pnt + 1),pth(pnt + 1),rll(pnt + 1));
        current_matDirCos = get_matDirCos(hdg(pnt),    pth(pnt)    ,rll(pnt)    );
        
   %velocity differentcial
        dVn = ( Vn(pnt + 1) - Vn(pnt) ) / timeStep;
        dVe = ( Ve(pnt + 1) - Ve(pnt) ) / timeStep;
        dVh = ( Vh(pnt + 1) - Vh(pnt) ) / timeStep;
        dV  = [dVe, dVn, dVh];
   %calculate accseleration on tk+1 point
        n_GCS = dV' + get_GravityAcc(lat(pnt), alt(pnt))' - (matr_Omega + 2*matr_U)*[Ve(pnt + 1);Vn(pnt + 1);Vh(pnt + 1)];
        acc(:, pnt) = future_matDirCos' * n_GCS;
   %calculate coordinats on tk+1 point     
        dLat    = -Omega_E;
        dLon    =  Omega_N/cos(lat(pnt));
        lat(pnt + 1) = lat(pnt) + dLat*timeStep;%;   + ((dV(2)/ro_1)*timeStep^2)/2 ;
        lon(pnt + 1) = lon(pnt) + dLon*timeStep;%;   + ((dV(1)/ro_2)*timeStep^2)/2;
        alt(pnt + 1) = alt(pnt) + Vh(pnt)*timeStep;%; + ((dV(3)*timeStep^2))/2;
     
    %calculate gyros   
        
        diff_matDirCos = (future_matDirCos - current_matDirCos) / timeStep;
        Omega_gyro = zeros(3,3);
        Omega_GCS = [  0            ,  (Omega_H + Uh),  (Omega_N + Un);
                      (Omega_H + Uh),  0             , -(Omega_E)     ;
                     -(Omega_N + Un),  (Omega_E)     ,  0            ];
        Omega_gyro = future_matDirCos \ (diff_matDirCos + Omega_GCS*future_matDirCos);      
        grs(:, pnt) = [Omega_gyro(3,2),Omega_gyro(1,3),Omega_gyro(2,1)];
    %new time stamp    
    
        timeStamp(pnt + 1) = timeStamp(pnt) + timeStep;
        pnt = pnt + 1;
    end 
    
    
clear dVe dVn dVh dV Vhor
clear dLon dLat lonStep
clear U Uh Un ro_1 ro_2
clear Omega_E Omega_N Omega_H Omega_GCS
clear n_GCS
clear matr_Omega matr_U Omega_gyro
clear future_matDirCos current_matDirCos d_matDirCos diff_matDirCos
clear beta beta1 q ge a e2 


Ve        = Ve(1:timeDuration / timeStep + 1);
Vn        = Vn(1:timeDuration / timeStep + 1);
Vh        = Vh(1:timeDuration / timeStep + 1);
lat       = lat(1:timeDuration / timeStep + 1);
lon       = lon(1:timeDuration / timeStep + 1);
alt       = alt(1:timeDuration / timeStep + 1);
hdg       = hdg(1:timeDuration / timeStep + 1);
pth       = pth(1:timeDuration / timeStep + 1);
rll       = rll(1:timeDuration / timeStep + 1);
timeStamp = timeStamp(1:timeDuration / timeStep + 1);
acc       = acc(:,1:timeDuration / timeStep + 1);
grs       = grs(:,1:timeDuration / timeStep + 1);
% if length(Ve) > timeDuration / timeStep + 1
%     while (length(Ve) >= timeDuration / timeStep + 1)
%         clear Ve(end) Vn(end) Vh(end)
%     end
% end
% clear dhdg dpth drll


function matDirCos = get_matDirCos(psi,theta,gamma)
%return matrix [3,3] matrix of directional cosines in the modified Poisson equation
%input [heading, pitch, roll]
    matDirCos = [sin(psi)*cos(theta), -sin(psi)*sin(theta)*cos(gamma)+cos(psi)*sin(gamma),  sin(psi)*sin(theta)*sin(gamma) + cos(psi)*cos(gamma);
                 cos(psi)*cos(theta), -cos(psi)*sin(theta)*cos(gamma)-sin(psi)*sin(gamma),  cos(psi)*sin(theta)*sin(gamma) - sin(psi)*cos(gamma);
                 sin(theta)         ,  cos(theta)*cos(gamma)                             , -cos(theta)*sin(gamma)                               ];
end
    
    
function acc_grv = get_GravityAcc(lat_mem, alt_mem)
%return array of acc in GCS
    global beta beta1 q ge a e2 
    acc_grv = zeros(3,1);
    
    U =  deg2rad (360 / (23 * 3600 + 56 * 60  + 4.09));
    ro_2 = a*(1-e2*sin(lat_mem)^2)^(-1/2) + alt_mem;% (rn + h)
    r_lon = cos(lat_mem)*ro_2;
%centripetal acceleration from Chekhov's book    
    centr_acc =[- sin(lat_mem)*r_lon*(U)^2;...
                  cos(lat_mem)*r_lon*(U)^2;...
                  0];
    g0 = ge*(1 + beta*sin(lat_mem)^2 + beta1*sin(2*lat_mem)^2);
    gn = g0*sin(2*lat_mem)*(alt_mem/a)*((e2)/a - 2*q);
    gh = g0 + (alt_mem/a)*((3*alt_mem/a) - 2*q*ge*cos(lat_mem)^2 + ...
                 (e2)*(3*sin(lat_mem)^2 - 1) - q*(1+6*sin(lat_mem)^2));
    acc_e = 0  - centr_acc(3);
    acc_n = gn - centr_acc(1);
    acc_h = gh - centr_acc(2);
    
    
    acc_grv = [acc_e, acc_n, acc_h];
end
%==========================================================================
function value = get_rndValue(lowerLimit, step, upperLimit)
% return uniform disturbet value from 'lowerLimit' to 'upperLimit' with setp 'step'
    xVar = lowerLimit:step:upperLimit;
    value = xVar(randi([1,length(xVar)],1));
end
%--------------------------------------------------------------------------

