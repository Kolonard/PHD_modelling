listOfRes = dir('results');
poligon = [0;0;0];


for ii = 3:length(listOfRes)
    file = load(listOfRes(ii).name);
    
    if file.end_position(1) ~= 'Nan'% check for bad model files
        poligon(ii - 2,1) = file.K_fastCircle_psd;
        poligon(ii - 2,2) = file.K_slowWindow;
        poligon(ii - 2,3) = file.res_falseAlarmCounter + ...
                            file.res_missDetection;
    else
        
        
    end

end

hist(curse)

% xv = linspace(min(poligon(:,2)), max(poligon(:,2)), 20);
% yv = linspace(min(poligon(:,3)), max(poligon(:,3)), 20);
% [X,Y] = meshgrid(xv, yv);
% Z = griddata(poligon(:,2),poligon(:,3),poligon(:,1),X,Y);
% surf(X, Y, Z);
% %surf
% % stem3(poligon(:,2), poligon(:,3), poligon(:,1));


