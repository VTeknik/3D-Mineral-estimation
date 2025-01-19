clear all;
clc;
close all;
format long;
format long g

% load the sheets f the data
[~,sheet_name]=xlsfinfo('IP_Rs Data_SheikhdarAbad.xlsx');

  PD_W04=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{1});
  PD_W03=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{2});
  PD_W02=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{3});
  PD_W01=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{4});
  
  PD_BL=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{5});
  PD_E01=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{6});
  PD_E02=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{7});
  PD_E03=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{8});
  PD_E04=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{9});
  PD_E05=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{10}); 
  PD_E06_Au=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{11});
  PD_E07=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{12});
  PD_E08=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{13});
  
  PD_EW_h=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{14});
  Points_Coordinates=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{15});
  Area_Coordinates=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{16});
  
   %================================================
  %load topo grid xyz format
  topo = load('topogrid_xyz.XYZ');
  
  topo2 = [topo(:,2) topo(:,1) topo(:,3)];
  save ('topogrid2_xyz.XYZ', 'topo2', '-ASCII')
  
  topo3 = sortrows(topo, 1);
   save ('topogrid3_xyz.XYZ', 'topo3', '-ASCII')
  %================================================
  %open file identifier
fid_DC=fopen('PD_W04_POT.OBS','w'); %The final ouput name of the file
fprintf(fid_DC, ['COMMON_CURRENT \n']);

  fid_IP=fopen('PD_W04_IP.OBS','w'); %The final ouput name of the file
  fprintf(fid_IP, ['COMMON_CURRENT \n']);
  
   fid_topo=fopen('PD_W04_topo.XYZ','w'); %The final ouput name of the file
   fmt_topo = '%d %d %5.1f \n';

%   Array format change
 datain =  PD_W04; % put each line one by one  
 dy = 30; % step of in the y direction
 dx = 0;
  %================================================
  

 
%  i_indx = [1 11 21 31 41 51 61 71 81 91 101 111 121 130 138 145 151 156 160 181 186 190 193]
 ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 130 138 145 151 156 160 163]
 plot(1:length(datain(:,2)),datain(:,2),'*'); % plot points 
 hold on
  plot(ind,datain(ind,2),'ro'); % plot points of initaions 
 grid on

 numHead= [length(ind)]; % first line of the input file
 fprintf(fid_DC, ['! general FORMAT' '\n']);
 fprintf(fid_DC, [num2str(numHead) '\n']);
   fprintf(fid_IP, ['! general FORMAT' '\n']);
   fprintf(fid_IP, [num2str(numHead) '\n']);
   fprintf(fid_IP, ['IPTYPE=1' '\n']);

 reciver_locations =[];
 reciver_locations_i =[];
 Source_locations = [];
 data_out = [];
 ii =1;
 for i = 1:length(ind)
     i
   Xa=[];Ya=[];Za=[]; Xm=[];Ym=[];Zm=[]; Xn=[];Yn=[];Zn=[]; Res=[]; 

% ----------------------------------source locations---------------     
 Xa =  datain(ind(i),1);   
 Ya =  datain(ind(i),2) - (3*dy/4); 
 Za =  dis4z(topo,Xa,Ya);
  Xb =  datain(ind(i),1);   
  Yb =  datain(ind(i),2) - (3*dy/4); 
  Zb =  dis4z(topo,Xb,Yb);
% ----------------------------------
if i==length(ind) % for the last point you should count number of the points by using fig and write here
 ranges =ind(i):ind(i)+2;
else
 ranges =ind(i):ind(i+1)-1; % range of recivers for each source 
end

 Source_locations = ([Ya Za Yb Zb length(ranges)]); % for pole-dipole the A and B repeated
  fmt_SRC = '%d %5.1f %d %5.1f %d \n';
  fprintf(fid_DC,fmt_SRC,Source_locations.');
  fprintf(fid_IP,fmt_SRC,Source_locations.');
 %-----------------------------------------------------------------
         %-----------------------------------
         % write first point on the topo file
         if i ==1
             Source_first = [Ya Xa Za];
             fprintf(fid_topo,fmt_topo, Source_first) 
         end
         %------------------------------------- 
 % ----------------------------------Reciver locations-------------- 

            for k = 1: length(ranges)
             Xm(k) = datain(ranges(k),1);
             Ym(k) = datain(ranges(k),2) + (dy/4) + ((k-1)*(dy/2));
            end
             Xm = Xm';Ym = Ym';
             
         Zm_j = [];
         for j=1:length(Xm)
             Zm_j(j) = dis4z(topo,Xm(j),Ym(j));
         end
         Zm = Zm_j';
         
Xn =  Xm;       
Yn = Ym + dy;
          Zn_j = [];
          for j=1:length(Xn)
             Zn_j(j) = dis4z(topo,Xn(j),Yn(j));
          end
          Zn = Zn_j';
charg =  datain(ranges,4);  
volt =  datain(ranges,5); 
std_charg = 0.02*charg;
std_volt = 0.02*volt;
current= 1000;
%=====================convert volt to res
n = 1:length(ranges);
G = ( 1./(n.*(n+1).*(dy)) );

 res = (2*pi*volt)./(current*G)';
 std_res =0.02*res;
%====================================
% reciver_locations_DC = [Xm Ym Zm Xn Yn Zn res std_res charg std_charg volt std_volt];
reciver_locations_DC = ([Ym Zm Yn Zn volt std_volt]);
fmt_DC = '%d %5.1f %d %5.1f %4.3f %4.3f \n';
reciver_locations_IP = [Ym Zm Yn Zn charg std_charg];
fmt_IP = '%d %5.1f %d %5.1f %4.3f %4.3f \n';

topo_3dalongPrifile= [Ym Xm Zm];


fprintf(fid_DC,fmt_DC,reciver_locations_DC.');
fprintf(fid_DC,'\n',reciver_locations_DC.');
fprintf(fid_IP,fmt_IP,reciver_locations_IP.');
fprintf(fid_IP,'\n',reciver_locations_IP.');


topo_3dalongPrifile= [Ym Xm Zm];
fprintf(fid_topo,fmt_topo,topo_3dalongPrifile.');

 end 
  
         %----------------------- last point of topo profile
         topo_3dalongPrifile= [Yn Xn Zn];
                 fprintf(fid_topo,fmt_topo,topo_3dalongPrifile.');
         %----------------------------------------------
 fclose(fid_DC);
 fclose(fid_IP);
 fclose(fid_topo);
