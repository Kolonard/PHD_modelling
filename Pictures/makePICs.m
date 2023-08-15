%Scripts to make pics using
clc
clear
close all
%-Define basic parameters
    plot = PloterClass();
%--task configuration
    task.closeAll = 0;
%--Path
    SavePath = 'PICS\';
    if ~isfolder(SavePath)
        mkdir(SavePath);
    end
%--Load data for render pictures
    data = load ('SVOtoMSK_100hz_fix.mat');

    %% Plots of base trajectory in 2 dimentions
% plain coordinats
% makeCrdPlot(   ax1, ay1, ax2, ay2, nameTitle, labX, labY, path, namePlot, leg1, leg2)
plot.makeCrdPlot(   rad2deg(data.lla_pos(:,2)), rad2deg(data.lla_pos(:,1)),"", ...
                    "Широта, [градус]", "Долгота, [градус]", ...
                    SavePath, "REF_TRAJECTORY")
plot.makeSinglePlot(data.time, data.lla_pos(:,3),"", ...
                    "Время, [с]", "Высота, [м]", SavePath, "REF_ALTITUDE");
plot.makeNrdPlot_3D(rad2deg(data.lla_pos(:,1)), rad2deg(data.lla_pos(:,2)),...
                   data.lla_pos(:,3), "", "Долгота, [градус]", "Широта, [градус]",...
                   "Высота, [м]",SavePath, "REF_3D_TRAJECTORY")  

velocityModule = sqrt(data.lla_vel(:,1).^2 + data.lla_vel(:,2).^2 + data.lla_vel(:,3).^2 );
plot.makeSinglePlot(data.time, velocityModule,"", ...
                    "Время, [с]", "Модуль вектора скорости, [м/с]", SavePath, "REF_VELMOD");

%%
if task.closeAll
    close all
end