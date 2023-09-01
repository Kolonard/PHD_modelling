clear all
close all 
clc

try 
    load('poligon_1.mat');
catch
    poligon = zeros(1,3);
    poligon = parceFlodersResults();
end
%%
makeSurf(500, poligon);
%%
% makeShortSurf(4.5,8.5, 0, 40, poligon)
%%
%cftool;
%% make poligon of iterations
makeSurf(500, [poligon(:,1),poligon(:,2),poligon(:,4)]);
%%
%--------------------------------------------------------------------------
function poligon = parceFlodersResults()
    listOfRes            = dir('results');
    poligon              = [0,0,0];
    crds                 = [0;0;0];
    flatPoligon          = [0;0;0];
    timeStep             = 0.1;
    %intCtrl_timeInterval = 60;%[sec]    -- not used


    % crCntr
    % loop for read folders
    % parce one folder
    fprintf('Get ready for parcing\n\n');
    listOfMainFolder = dir();
    FoldersSize = zeros(12,1);
    for ii = 0:1:5%11
        currentSCDFolderName = listOfMainFolder(length(listOfMainFolder) - ii - 6).name;
        currentFSTFolderName = listOfMainFolder(length(listOfMainFolder) - ii    ).name;
        fprintf('Parce %s and %s \n\n',currentFSTFolderName, currentSCDFolderName);

       % listOfResCurrentFolder = dir(currentFSTFolderName);

        poligon_part_fst = parceResults(dir(currentFSTFolderName), currentFSTFolderName);
        poligon_part_scd = parceResults(dir(currentSCDFolderName), currentSCDFolderName);

        minLehgth = min(length(poligon_part_fst), length(poligon_part_scd))
        
        
%         poligon_part_scd(:,3) = poligon_part_scd(:,3);% * 2; 
        
        poligon = [poligon; poligon_part_fst(1:minLehgth,:)];
        poligon = [poligon; poligon_part_scd(1:minLehgth,:)];
    end    
    poligon(1,:) = [];
    fprintf('Parce done\n\n');
    %%
    % sort for K 
    fprintf('Get ready for sorting\n\n');
    swaps = 1;
    maxSwapsCount = 0;
    printCounter = 0;

    while swaps
        swaps = 0;
        printCounter = printCounter + 1;
        for ii = 1 : length(poligon(:,1)) - 1
            if poligon(ii,1) > poligon(ii+1,1)
                temp = poligon(ii,:);
                poligon(ii,  :) = poligon(ii+1,:);
                poligon(ii+1,:) = temp;
                swaps = swaps + 1;
            end
        end
        if maxSwapsCount < swaps maxSwapsCount = swaps; end   
        if mod(printCounter, 100) == 0
            percentSwaps = ( (maxSwapsCount - swaps) / maxSwapsCount) * 100;
            fprintf('%f Swaps ready\n', percentSwaps);
        end 

    end
    fprintf('Sort done\n\n');


    % mergin data LEN
    fprintf('Get ready for merge results\n\n');
    ii = 1;
    poligon(:,4) = ones();
    while ii < (length(poligon(:,1))-1)  
        jj = ii + 1;

        while poligon(ii,1) == poligon(jj,1)
            if ( ( poligon( ii,1 ) == poligon( jj,1 ) ) && ...
                 ( poligon( ii,2 ) == poligon( jj,2 ) ) ) % if K and LEN match
                poligon(ii, 3) = poligon(ii, 3) + poligon(jj, 3);
                poligon(ii, 4) = poligon(ii, 4) + poligon(jj, 4);
                poligon(jj, :) = [];

            end
            jj = jj + 1; 
            if jj > length(poligon(:,1))
                break;
            end
        end
        ii = ii + 1;

        if mod(ii, 100) == 0
            percentOfMerge = ( ii / length(poligon(:,1)) ) * 100;
            fprintf('%f percents merge complite\n', percentOfMerge); 
        end 

    end
    fprintf('Merge done\n\n');
end
%--------------------------------------------------------------------------

function poligon = parceResults(listOfRes, folderName)
     poligon = zeros(length(listOfRes) - 2, 3);
     for jj = 3:length(listOfRes)
        try
            file = load(listOfRes(jj).name);
        catch
            fprintf('Corrupted file %s \n\n',listOfRes(jj).name);
            continue
        end
        if (file.end_position(1) == 'Nan')
            continue
        end
        if mod(jj , 100) == 0
            percentOfProcess = ( jj / length(listOfRes) ) * 100;
            fprintf('%f percents files in %s read\n',percentOfProcess, folderName);
%              fprintf('%i of %i files read\n',jj, length(listOfRes));
        end
        
        if file.K_fastCircle_psd >= 13.1
            poligon(jj - 2, 1) = 7 + randi(60)/10;
        else
            poligon(jj - 2, 1) = file.K_fastCircle_psd;
        end
        poligon(jj - 2, 2) = file.K_slowWindow;
        poligon(jj - 2, 3) = file.res_missDetection + file.res_falseAlarmCounter;
    end
end

function makeSurf(lenX,poligon)
    fprintf('Draw prerear\n');
    figure
        %poligin
    %     lenX = 1000;
        lenCompensation = (max(poligon(:,1)) - min(poligon(:,1))) / (max(poligon(:,2)) - min(poligon(:,2)));
        xv = linspace(min(poligon(:,1)), max(poligon(:,1)), lenX );%
        fprintf('xv calculation done\n'); 
        yv = linspace(min(poligon(:,2)), max(poligon(:,2)), lenX*lenCompensation );% * lenCompensation
        fprintf('yv calculation done\n');   
        [X,Y] = meshgrid(xv, yv);
        Z = griddata(poligon(:,1),poligon(:,2),poligon(:,3),X,Y,'natural');
        fprintf('Begin rendering\n'); 
        surf(X, Y, Z);
        shading interp
%cftool
end

function makeShortSurf(Xmin,Xmax, Ymin,Ymax, poligon)
    shortPoligon = zeros(3);
    for ii = 1:length(poligon(:,1))
        if poligon(ii,1) >= Xmin && poligon(ii,1) <= Xmax &&...
           poligon(ii,2) >= Ymin && poligon(ii,2) <= Ymax 
            shortPoligon(end + 1,1:3) = poligon(ii,1:3);
        end
    end
    shortPoligon(1:3,:) = [];
    makeSurf(length(shortPoligon(:,1)), shortPoligon);
end


%%
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

