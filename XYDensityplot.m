
 clear all;
clc;
close all;
format long;
%---------------------------load  Moho _BG data----------------------------
% fro data base of d:\V\MEdata\MohoCTv3cs0p5_20220629
% datain = load('CU_depth.XYZ');% resouloustion of data set is 0.5 degree
% CUdepth = importfile_cudepth('CU_depth.XYZ', 1, end);
load("CUdepth1.mat")
name =CUdepth1.name;n =CUdepth1.n;x =CUdepth1.x;y =CUdepth1.y;depth =CUdepth1.depth;cu =CUdepth1.cu;

%--------------------------------------------------------------------------



 % ======================================= plottopo moho
 %
fig1 = figure(1); 
clf(fig1)
set (fig1, 'units','normalized','outerposition',[0.003 0.04 0.995 0.95]);
%  s = scatter(mohos,mohoml,30,'MarkerEdgeColor',[0.01 0.09 0.49],'LineWidth',1);
 scatter_kde(cu,depth, 'filled', 'MarkerSize', 40);
 hold on
  ax = gca;
%  bar(mohos-mohoml);
 grid on
 box on
 xlabel('CU(ppm)','FontSize',12,'FontWeight','bold','Color','k')
 ylabel('depth(m)','FontSize',12,'FontWeight','bold','Color','k')
 axis('square'); ax.Color = 'white'; ax.FontSize = 30;ax.FontWeight = 'bold'; 
 set(gca, 'YDir','reverse')
% yline(40)
% xline(70)
% minmax= [min(density) max([density]) ];
% xlim([-500 3500])
% ylim([-0.001 0.035])
% plot(minmax,minmax,'--')
    %--------------------------------------------------
        colormap('parula')
        cb = colorbar; 
        set(cb,'position',[.67 .425 0.015 .15])
%         set(cb,'YTick',[0.002 0.004 0.006])
%         set(cb,'YTickLabel',{'0.002','0.004','0.006'})
        cb.Title.String = ['Probability Density'];
        cb.FontSize = 20;                     % make the text larger
        cb.FontWeight = 'bold';               % make the text bold
     %--------------------------------------------------
set(fig1, 'PaperSize', [15 12]); %Keep the same paper size
%  saveas(fig3, fullfile(path,nestname), 'pdf')
 print('-painters', '-dpdf',fig1) 
%===============================================

fig2 = figure(2); 
clf(fig2)
set (fig2, 'units','normalized','outerposition',[0.003 0.04 0.995 0.95]);
%  s = scatter(mohos,mohoml,30,'MarkerEdgeColor',[0.01 0.09 0.49],'LineWidth',1);

        nameu = unique(name);% make unique BH
        namechar = char(name);
     
        for i=1: length(name) 
           
                       name2(i) = string (namechar(i,1:4));
      end

gscatter(cu,depth,name2,[0 0 1; 0.6350 0.0780 0.1840;0 0 0;0.3010 0.7450 0.9330;...
    0.4660 0.6740 0.1880;0 1 1;0.4940 0.1840 0.5560;0.9290 0.6940 0.1250;0.8500 0.3250 0.0980;...
    0 0.4470 0.7410;0.6 0 0.2;0.7 0 0.7;0.6 1 0.3;0.6 0.6 0.6 ...
    ],'o*+xsd^v><phsd',11,'on') 
 hold on
  ax = gca;
%  bar(mohos-mohoml);
 grid on
 box on
 xticks([0:2000:10000])
 xlabel('CU(ppm)','FontSize',12,'FontWeight','bold','Color','k')
 ylabel('depth(m)','FontSize',12,'FontWeight','bold','Color','k')
 axis('square'); ax.Color = 'white'; ax.FontSize = 30;ax.FontWeight = 'bold'; 
 set(gca, 'YDir','reverse')
% yline(40)
% xline(70)
% minmax= [min(density) max([density]) ];
xlim([0 max(cu)+1])
% ylim([-0.001 0.035])
% plot(minmax,minmax,'--')


     %--------------------------------------------------
set(fig2, 'PaperSize', [15 12]); %Keep the same paper size
%  saveas(fig3, fullfile(path,nestname), 'pdf')
 print('-painters','-dpdf',fig2) 
%===============================================
