clear all
close all 
clc


listOfRes            = dir('results');
poligon              = [0,0,0];
crds                 = [0;0;0];
flatPoligon          = [0;0;0];
timeStep             = 0.1;
intCtrl_timeInterval = 10;%[sec]


% crCntr
for jj = 3:length(listOfRes)
    try
        file = load(listOfRes(jj).name);
    catch
        fprintf('Corrupted file %s \n\n',listOfRes(jj).name);
    end
    if (file.end_position(1) == 'Nan')
        continue
    end
    
    if mod(jj , 1000) == 0
         fprintf('%i of %i files read\n\n',jj, length(listOfRes));
    end

    
    poligon(jj - 2, 1) = file.K_fastCircle_psd;
    poligon(jj - 2, 2) = file.K_slowWindow;
    poligon(jj - 2, 3) = file.res_missDetection + file.res_falseAlarmCounter;
end
fprintf('Parce done');

% sort for K
swaps = 1;
while swaps
    swaps = 0;
    for ii = 1 : length(poligon(:,1)) - 1
        if poligon(ii,1) > poligon(ii+1,1)
            temp = poligon(ii,:);
            poligon(ii,  :) = poligon(ii+1,:);
            poligon(ii+1,:) = temp;
            swaps = swaps + 1;
        end
    end
end

fprintf('Sort done\n\n');

% mergin data LEN
ii = 1;
while ii <= length(poligon(:,1))  
    jj = ii + 1;
    while jj <= length(poligon(:,1))
        if ( ( poligon( ii,1 ) == poligon( jj,1 ) ) && ...
             ( poligon( ii,2 ) == poligon( jj,2 ) ) ) % if K and LEN match
            poligon(ii, 3) = poligon(ii, 3) + poligon(jj, 3);
            poligon(jj, :) = [];
        end
        jj = jj + 1; 
    end
    ii = ii + 1;
end
fprintf('Merge done\n\n');
% 
% XX = 0;
% YY = 0;
% cnt = length(3:0.1:7) + length(5:1:120);
% ZZ = nan*ones(cnt,1);
% for ii = 1:length(poligon(:,1))
%     if (isempty(find( XX == poligon(ii,1) )))
%         XX(length(XX) + 1) = poligon(ii,1);
%     end
%     if (isempty(find( YY == poligon(ii,2) )))
%         YY(length(YY) + 1) = poligon(ii,2);
%     end
%     
% end
% XX(1) = [];
% YY(1) = [];
% ZZ(1) = 0;%-1 .* ones(length(poligon(:,1)),1);








% 
% % % % % % % % calculations for poligon
% % % % % % %     lenCompensation = 0.05;%(max(poligon(:,1)) - min(poligon(:,1))) / max(poligon(:,2));
% % % % % % %     xv = linspace(min(poligon(:,1)), max(poligon(:,1)), 100);
% % % % % % %     yv = linspace(min(poligon(:,2)), max(poligon(:,2)), 100* lenCompensation);% * lenCompensation
% % % % % % %     [X,Y] = meshgrid(xv, yv);
% % % % % % %     Z = griddata(poligon(:,1),poligon(:,2),poligon(:,3),X,Y,'natural');
% % % % % % %     
% % % % % % %     
% % % % % % %     pos = 1;
% % % % % % %     for ii = 1:length(poligon(:,3))
% % % % % % %         if poligon(ii,3) == 0
% % % % % % %             flatPoligon(pos, 1) = poligon(ii,1); 
% % % % % % %             flatPoligon(pos, 2) = poligon(ii,2); 
% % % % % % %             flatPoligon(pos, 3) = poligon(ii,3);
% % % % % % %             pos = pos + 1;
% % % % % % %         end
% % % % % % %     end
% % 
fprintf('Draw prerear\n');
figure
    %poligin
    lenCompensation = 0.1;%(max(poligon(:,1)) - min(poligon(:,1))) / (max(poligon(:,2)) - min(poligon(:,2)));
    xv = linspace(min(poligon(:,1)), max(poligon(:,1)), 50 );%
    yv = linspace(min(poligon(:,2)), max(poligon(:,2)), 50 );% * lenCompensation
    [X,Y] = meshgrid(xv, yv);

    Z = griddata(poligon(:,1),poligon(:,2),poligon(:,3),X,Y,'natural');
    
%     surf(peaks(20))

    surf(X, Y, Z);
%     colormap summer
    shading interp
%     mesh(poligon(:,1),poligon(:,2),poligon(:,3))
%cftool













%{
    for ii = 1:length(file.intCtrl_status)
       
        if file.pass == 0 %catch first signal
%             file.satVisibleCount(ii) = min(file.satVisibleCount(ii), 8);
            if file.intCtrl_status(ii) == 1 && ... % no integrity flag     #1
               file.corruptTimeStart > ii * timeStep %&&... % corrupt disable
               file.satVisibleCount(ii) < 5 %not sats
                    poligon(end,3) = 1; % miss detection
                    file.pass = 1;
            end
            if file.intCtrl_status(ii) == 1 && ... % no integrity flag     #2 
               file.corruptTimeStart <= ii * timeStep &&... % corrupt enable
               ...%file.satVisibleCount(ii) - file.corruptSatCount < 5 &&...%not sats
               file.corruptTimeStart + intCtrl_timeInterval < ii * timeStep % break interval
                    poligon(end,3) = 1; % miss detection
                    file.pass = 1;
            end
            if file.intCtrl_status(ii) == 0 && ... % integrity flag        #3
               file.corruptTimeStart > ii * timeStep &&... % corrupt disable
               file.satVisibleCount(ii) < 5% no sats     
                    file.pass = 1; %pass
            end
            if file.intCtrl_status(ii) == 0 && ... % integrity flag        #4
               file.corruptTimeStart > ii * timeStep &&... % corrupt disable
                file.satVisibleCount(ii) >= 5% no sats     
                    poligon(end,3) = 1; %false alert               
                    file.pass = 1;
            end
%             if file.intCtrl_status(ii) == 0 && ... % integrity flag      #4
%                file.corruptTimeStart > ii * timeStep &&... % corrupt disable
%                file.satVisibleCount(ii) >= 5% sats norm
%                     add_poligon_point(poligon); %false alert
%                     file.pass = 1;
%             end
            if file.intCtrl_status(ii) == 0 && ... % integrity flag        #5
               file.corruptTimeStart <= ii * timeStep %&&... % corrupt enable
                file.satVisibleCount(ii) - file.corruptSatCount >= 5% enought sats     
                    poligon(end,3) = 1; %false alert
                    file.pass = 1;
            end
            if file.intCtrl_status(ii) == 0 && ... % integrity flag        #6
               file.corruptTimeStart <= ii * timeStep &&... % corrupt enable
               file.satVisibleCount(ii) - file.corruptSatCount < 5 &&...  % no sats 
               file.corruptTimeStart  + intCtrl_timeInterval <= ii * timeStep %break interval
                    poligon(end,3) = 1; %miss detect
                    file.pass = 1;
            end
            if file.intCtrl_status(ii) == 0 && ... % integrity flag        #7
               file.corruptTimeStart <= ii * timeStep &&... % corrupt enable
               file.satVisibleCount(ii) - file.corruptSatCount < 5 &&...  % no sats 
               file.corruptTimeStart  + intCtrl_timeInterval > ii * timeStep %in interval
                    file.pass = 1;%    pass                                    
            end
        end
        
    end
%}
