clear all
close all 
clc


listOfRes   = dir('Stage_3_1');
poligon     = [0;0;0];
crds        = [0;0;0];
flatPoligon = [0;0;0];
% crCntr
for ii = 3:length(listOfRes)
    try
        file = load(listOfRes(ii).name);
    catch
        fprintf('Corrupted file %s \n\n',listOfRes(ii).name);
    end
    
    if file.end_position(1) ~= 'Nan'% check for bad model files
        poligon(ii - 2,1) = file.K_fastCircle_psd;
        poligon(ii - 2,2) = file.K_slowWindow;
        
        poligon(ii - 2,3) = file.res_falseAlarmCounter + ...
                            file.res_missDetection;
%         if poligon(ii - 2,3) > 3
%             poligon(ii - 2,3) = 3;
%         end
        
        corruptErrorType( ii - 2 )  = file.corruptErrorType;
        if corruptErrorType(ii - 2) == 1
              corruptPSDError_step( ii-2 )   = file.corruptPSDError;
        elseif corruptErrorType(    ii - 2 ) == 2
              corruptPSDError_ramp( ii-2 )   = file.corruptPSDError;
        end
        corruptSatCount(  ii - 2 )  = file.corruptSatCount;
        
        crds(:,ii-2) = file.start_position;
        
    else       
    end
end


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
% mergin data LEN
ii = 1;
while ii <= length(poligon(:,1))  
    jj = ii;
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

XX = 0;
YY = 0;
cnt = length(3:0.1:7) + length(5:1:120);
% ZZ = nan*ones(cnt,1);
for ii = 1:length(poligon(:,1))
    if (isempty(find( XX == poligon(ii,1) )))
        XX(length(XX) + 1) = poligon(ii,1);
    end
    if (isempty(find( YY == poligon(ii,2) )))
        YY(length(YY) + 1) = poligon(ii,2);
    end
    
end
XX(1) = [];
YY(1) = [];
ZZ(1) = 0;%-1 .* ones(length(poligon(:,1)),1);
myBar = -1.*ones(length(XX), length(YY),1);
% 
% calculations for poligon
    lenCompensation = 0.05;%(max(poligon(:,1)) - min(poligon(:,1))) / max(poligon(:,2));
    xv = linspace(min(poligon(:,1)), max(poligon(:,1)), 100);
    yv = linspace(min(poligon(:,2)), max(poligon(:,2)), 100* lenCompensation);% * lenCompensation
    [X,Y] = meshgrid(xv, yv);
    Z = griddata(poligon(:,1),poligon(:,2),poligon(:,3),X,Y,'natural');
    
    
    pos = 1;
    for ii = 1:length(poligon(:,3))
        if poligon(ii,3) == 0
            flatPoligon(pos, 1) = poligon(ii,1); 
            flatPoligon(pos, 2) = poligon(ii,2); 
            flatPoligon(pos, 3) = poligon(ii,3);
            pos = pos + 1;
        end
    end
% %     
figure
    %poligin
    lenCompensation = 0.1;%(max(poligon(:,1)) - min(poligon(:,1))) / (max(poligon(:,2)) - min(poligon(:,2)));
    xv = linspace(min(poligon(:,1)), max(poligon(:,1)), length(XX));
    yv = linspace(min(poligon(:,2)), max(poligon(:,2)), length(YY));% * lenCompensation
    [X,Y] = meshgrid(xv, yv);
%     for ii = 1:length(poligon(:,3))
%         if poligon(ii,3) ~= 0 
%             poligon(ii,3) = log(poligon(ii,3)); 
%         end
%     end
    Z = griddata(poligon(:,1),poligon(:,2),poligon(:,3),X,Y,'natural');
    surf(X, Y, Z);
% mesh(X,Y,Z)
%cftool

%-------------------------------------------------------------------------    
% oo = ones(length(poligon(:,1)),length(poligon(:,1)));
% figure
%     bar3(oo)
% for ii = 1:length(poligon(:,1))
%     for jj = 1:length(poligon(:,1))
%         oo(ii,jj) = poligon(:,3)
%     end
% end
% figure
%     bar3(poligon(:,1),poligon(:,3),poligon(:,2))
%     
    
    
    
% figure    
%     plot(flatPoligon(:,1),flatPoligon(:,2),'o',...
%     'LineWidth',1,...
%     'MarkerSize',20,...
%     'MarkerEdgeColor','b',...
%     'MarkerFaceColor','b')
%  plot(flatPoligon(:,1),flatPoligon(:,2), 'LineWidth',5);
% 'MarkerSize',20,...
% 'MarkerEdgeColor','b',...
% 'MarkerFaceColor','b')    

% figure
%     hold on
%     legend('poligon(:,1)');
%     histogram(poligon(:,1));
%     hold off
% figure
%     hold on
%     legend('poligon(:,2)');
%     histogram(poligon(:,2));
%     hold off    
    
% % figure
% %     hold on
% %     legend('corruptErrorType');
% %     histogram(corruptErrorType);
% %     hold off
% figure
%     hold on
%     legend('corruptPSDError_step');
%     histogram(corruptPSDError_step);
%     hold off
% figure
%     hold on
%     legend('corruptPSDError_ramp');
%     histogram(corruptPSDError_ramp);
%     hold off
% figure
%     hold on
%     legend('corruptSatCount');
%     histogram(corruptSatCount);
%     hold off