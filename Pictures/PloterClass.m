classdef PloterClass
    methods
%--------------------------------------------------------------------------
%make one gra
          function makeSinglePlot(obj,timeLine, data, nameTitle, labX, labY, path, namePlot)%, leg)
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            hold on
                p = plot(timeLine, data,'b');
                p(1).LineWidth = 2;
                grid on
                axp = get(gca,'Position');
                xs=axp(1);
                xe=axp(1)+axp(3)+0.04;
                ys=axp(2);
                ye=axp(2)+axp(4)+0.05;
                annotation('arrow', [xs xe],[ys ys]);
                annotation('arrow', [xs xs],[ys ye]);
                set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
        %         title(nameTitle);
                xlabel(labX);
                ylabel(labY);
        %         legend(leg);
            hold off
            saveas(gcf, path + namePlot + ".png");
        end
%--------------------------------------------------------------------------
        function makeCrdPlot(obj,ax1, ay1, nameTitle, labX, labY, path, namePlot)%, leg1, leg2
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            hold on
                p = plot(ay1, ax1,'b');
                p(1).LineWidth = 2;
                grid on
                axp = get(gca,'Position');
                xs=axp(1);
                xe=axp(1)+axp(3)+0.04;
                ys=axp(2);
                ye=axp(2)+axp(4)+0.05;
                annotation('arrow', [xs xe],[ys ys]);
                annotation('arrow', [xs xs],[ys ye]);
                set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
        %        title(nameTitle);
                xlabel(labX);
                ylabel(labY);
        %        legend(leg1,leg2);
            hold off
            saveas(gcf, path + namePlot + ".png");
        end
%--------------------------------------------------------------------------
        function makeNrdPlot_3D(obj,ax1, ay1, az1,nameTitle, labX, labY, labZ, path, namePlot)
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            p = plot3(ay1, ax1, az1, 'b');
            p(1).LineWidth = 2;
            grid on
            axp = get(gca,'Position');
            xs=axp(1);
            xe=axp(1)+axp(3)+0.04;
            ys=axp(2);
            ye=axp(2)+axp(4)+0.05;
            annotation('arrow', [xs+0.34 xe],[ys ys+0.172]); %right side
            annotation('arrow', [xs + 0.332 xe - 0.89],[ys ys+0.253]); %left side
            annotation('arrow', [xs xs],[ys + 0.2 ye - 0.15]);%vertical
            set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
    %        title(nameTitle);
            xlabel(labX);
            ylabel(labY);
            zlabel(labZ);
     %        legend(leg1,leg2);
            saveas(gcf, path + namePlot + ".png");
        end
%--------------------------------------------------------------------------        
        function makeQuadroPlotMan(obj,ax1,ay1,ax2,ay2,ax3,ay3,ax4,ay4,...
                                   nameTitle, labX, labY, path, namePlot, ...
                                   leg1, leg2, leg3,leg4)
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            hold on
                p = plot(ax1, ay1, 'r' , ax2, ay2, 'b',ax3, ay3,'g',ax4, ay4, 'c');
                p(1).LineWidth = 2;
                p(2).LineWidth = 2;
                p(3).LineWidth = 2;
                p(4).LineWidth = 2;
                grid on
                axp = get(gca,'Position');
                xs=axp(1);
                xe=axp(1)+axp(3)+0.04;
                ys=axp(2);
                ye=axp(2)+axp(4)+0.05;
                annotation('arrow', [xs xe],[ys ys]);
                annotation('arrow', [xs xs],[ys ye]);
                set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
        %        title(nameTitle);
                xlabel(labX);
                ylabel(labY);
                legend(leg1, leg2, leg3,leg4);
            hold off
            saveas(gcf, path + namePlot + ".png");
        end 
%--------------------------------------------------------------------------
        function makeFiftoPlot(obj,ax1, ay1, ax2, ay2, ax3, ay3, ax4, ay4, ax5, ay5, nameTitle, labX, labY, path, namePlot, ...
                    leg1, leg2, leg3, leg4, leg5)
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            hold on
                p  = plot(ay1, ax1,'g');
                p2 = plot(ay2, ax2,'r');
                p3 = plot(ay3, ax3,'b');
                p4 = plot(ay4, ax4,'r');
                p5 = plot(ay5, ax5,'b');

                p.LineWidth  = 2;
                p2.LineWidth = 2;
                p3.LineWidth = 2;
                p4.LineWidth = 2;
                p5.LineWidth = 2;

                grid on
                axp = get(gca,'Position');
                xs=axp(1);
                xe=axp(1)+axp(3)+0.04;
                ys=axp(2);
                ye=axp(2)+axp(4)+0.05;
                annotation('arrow', [xs xe],[ys ys]);
                annotation('arrow', [xs xs],[ys ye]);
                set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
        %         title(nameTitle);
                xlabel(labX);
                ylabel(labY);
                legend(leg1, leg2, leg3, leg4, leg5);
            hold off
            saveas(gcf, path + namePlot + ".png");
        end 
%--------------------------------------------------------------------------
        function makeDoublePlot(obj,timeLine, data_SPAN, data_MKNS, nameTitle, labX, labY, path, namePlot,...
                                leg1, leg2)
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            hold on
                p = plot(timeLine, data_MKNS,'r',timeLine, data_SPAN,'b');
                p(1).LineWidth = 2;
                p(2).LineWidth = 2;
                grid on
                axp = get(gca,'Position');
                xs=axp(1);
                xe=axp(1)+axp(3)+0.04;
                ys=axp(2);
                ye=axp(2)+axp(4)+0.05;
                annotation('arrow', [xs xe],[ys ys]);
                annotation('arrow', [xs xs],[ys ye]);
                set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
        %         title(nameTitle);
                xlabel(labX);
                ylabel(labY);
                legend(leg1,leg2);
            hold off
            saveas(gcf, path + namePlot + ".png");
        end
%--------------------------------------------------------------------------
      
%--------------------------------------------------------------------------
        function makeTriplePlot(obj,ax1, ay1, ax2, ay2, ax3, ay3, nameTitle, labX, labY, path, namePlot, ...
                    leg1, leg2, leg3)
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            hold on
                p = plot(ay1, ax1,'b',ay2, ax2,'r',ay3, ax3,'g');
                p(1).LineWidth = 2;
                p(2).LineWidth = 2;
                p(3).LineWidth = 2;
                grid on
                axp = get(gca,'Position');
                xs=axp(1);
                xe=axp(1)+axp(3)+0.04;
                ys=axp(2);
                ye=axp(2)+axp(4)+0.05;
                annotation('arrow', [xs xe],[ys ys]);
                annotation('arrow', [xs xs],[ys ye]);
                set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
        %         title(nameTitle);
                xlabel(labX);
                ylabel(labY);
                legend(leg1, leg2, leg3);
            hold off
            saveas(gcf, path + namePlot + ".png");
          end 
%--------------------------------------------------------------------------
        function makeSixoPlot(obj,timeline,ay1,ay2,ay3,ay4,ay5,ay6, nameTitle, labX, labY, path, namePlot, ...
                            leg1, leg2, leg3,leg4, leg5, leg6)
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            hold on
                p = plot(timeline, ay1, 'b' , timeline, ay2,'r',  timeline, ay3,'g',...
                         timeline, ay4, 'b--',timeline, ay5,'r--',timeline, ay6,'g--');
                p(1).LineWidth = 2;
                p(2).LineWidth = 2;
                p(3).LineWidth = 2;
                grid on
                axp = get(gca,'Position');
                xs=axp(1);
                xe=axp(1)+axp(3)+0.04;
                ys=axp(2);
                ye=axp(2)+axp(4)+0.05;
                annotation('arrow', [xs xe],[ys ys]);
                annotation('arrow', [xs xs],[ys ye]);
                set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
        %         title(nameTitle);
                xlabel(labX);
                ylabel(labY);
                legend(leg1, leg2, leg3,leg4, leg5, leg6);
            hold off
            saveas(gcf, path + namePlot + ".png");
        end
%--------------------------------------------------------------------------        
        function makeQuadroPlot(obj,timeline,ay1,ay2,ay3,ay4, nameTitle, labX, labY, path, namePlot, ...
                                leg1, leg2, leg3,leg4)
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            hold on
                p = plot(timeline, ay1, 'b' , timeline, ay2,'r',  timeline, ay3,'g',...
                         timeline, ay4, 'k--');
                p(1).LineWidth = 2;
                p(2).LineWidth = 2;
                p(3).LineWidth = 2;
                p(4).LineWidth = 2;
                grid on
                axp = get(gca,'Position');
                xs=axp(1);
                xe=axp(1)+axp(3)+0.04;
                ys=axp(2);
                ye=axp(2)+axp(4)+0.05;
                annotation('arrow', [xs xe],[ys ys]);
                annotation('arrow', [xs xs],[ys ye]);
                set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
        %         title(nameTitle);
                xlabel(labX);
                ylabel(labY);
                legend(leg1, leg2, leg3,leg4);
            hold off
            saveas(gcf, path + namePlot + ".png");
        end
%--------------------------------------------------------------------------        
        function makeEctoPlot(obj,timeline,ay1,ay2,ay3,ay4,ay5,ay6,ay7,ay8, nameTitle, labX, labY, path, namePlot, ...
                                leg1, leg2, leg3, leg4, leg5, leg6, leg7, leg8)
            figure('Color', [1,1,1],'Renderer', 'painters', 'Position', [10 10 750 415]);
            hold on
                p = plot(timeline, ay1, 'b', timeline, ay2,'r', timeline, ay3,'g',...
                         timeline, ay4, 'c', timeline, ay5,'m', timeline, ay6,'y',...
                         timeline, ay7, 'k', timeline, ay8, 'r-.');
                p(1).LineWidth = 2;
                p(2).LineWidth = 2;
                p(3).LineWidth = 2;
                p(4).LineWidth = 2;

                p(5).LineWidth = 2;
                p(6).LineWidth = 2;
                p(7).LineWidth = 1;
                p(8).LineWidth = 2;


                grid on
                axp = get(gca,'Position');
                xs=axp(1);
                xe=axp(1)+axp(3)+0.04;
                ys=axp(2);
                ye=axp(2)+axp(4)+0.05;
                annotation('arrow', [xs xe],[ys ys]);
                annotation('arrow', [xs xs],[ys ye]);
                set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
        %         title(nameTitle);
                xlabel(labX);
                ylabel(labY);
                legend(leg1, leg2, leg3, leg4, leg5, leg6, leg7, leg8);
            hold off
            saveas(gcf, path + namePlot + ".png");
        end   
    end
end
