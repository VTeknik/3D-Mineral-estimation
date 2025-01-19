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
  fid_DC=fopen('dc_data_ebi.xyz','w'); %The final ouput name of the file
  header_dc = 'XA    YA    ZA    XB    YB    ZB    XM    YM    ZM    XN    YN    ZN    V/A    UNCERT    LINEID';
fprintf(fid_DC, [header_dc '\n']);

  fid_IP=fopen('ip_data_ebi.xyz','w'); %The final ouput name of the file
    header_ip = 'XA    YA    ZA    XB    YB    ZB    XM    YM    ZM    XN    YN    ZN    APP_CHG    UNCERT    LINEID';
  fprintf(fid_IP, [header_ip '\n']);
  
   fid_topo=fopen('topo_ebi.txt','w'); %The final ouput name of the file
   fmt_topo = '%d %d %5.1f \n';
   
 
   
   
  
 dy = 30; % step of in the y direction
 dx = 0;
   
for s = 1:13  
datain = xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{s});
sheet_name{s}
ind =[1;find(diff(datain(:,2))<=0)+1]
 
%==================plot and check for data===
fig1 = figure(1);
 plot(1:length(datain(:,2)),datain(:,2),'*'); % plot points 
 hold on
  plot(ind,datain(ind,2),'ro'); % plot points of initaions 
 grid on
 pause(1)
 %============================================
 close(fig1)


 reciver_locations =[];
 reciver_locations_i =[];
 Source_locations = [];
 data_out = [];
 ii =1;
 for i = 1:length(ind)
     
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
 ranges =ind(i):length(datain(:,2));
else
 ranges =ind(i):ind(i+1)-1; % range of recivers for each source 
end


 %-----------------------------------------------------------------
         %-----------------------------------
         % write first point on the topo file
         if i ==1
             Source_first = [Xa Ya Za];
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
volt_A =  datain(ranges,5)./datain(ranges,6); 
std_charg = 0.05*charg;
std_volt = 0.05*volt_A;
current= 1000;
%=====================convert volt to res

%====================================
Xa = repmat(Xa, size(Xm));
Ya = repmat(Ya, size(Xm));
Za = repmat(Za, size(Xm));
Xb = repmat(Xb, size(Xm));
Yb = repmat(Yb, size(Xm));
Zb = repmat(Zb, size(Xm));
indc = repmat(s, size(Xm));

data_line_dc = ([Xa+0.1 Ya+0.1 Za+0.1 Xb+0.1 Yb+0.1 Zb+0.1 Xm Ym Zm Xn Yn Zn volt_A std_volt indc]);
fmt_DC = '%d %d %5.1f %d %d %5.1f %d %d %5.1f %d %d %5.1f %5.4f %8.7f %d \n';

data_line_ip = ([Xa+0.1 Ya+0.1 Za+0.1 Xb+0.1 Yb+0.1 Zb+0.1 Xm Ym Zm Xn Yn Zn charg std_charg indc]);
fmt_IP = '%d %d %5.1f %d %d %5.1f %d %d %5.1f %d %d %5.1f %5.4f %8.7f %d \n';


topo_3dalongPrifile= [Xm Ym Zm];


fprintf(fid_DC,fmt_DC,data_line_dc.');
% fprintf(fid_DC,'\n',data_line_dc.');
fprintf(fid_IP,fmt_IP,data_line_ip.');
% fprintf(fid_IP,'\n',data_line_ip.');


topo_3dalongPrifile= [Xm Ym Zm];
fprintf(fid_topo,fmt_topo,topo_3dalongPrifile.');

 end 
 
  
  
         %----------------------- last point of topo profile
         topo_3dalongPrifile= [Xn Yn Zn];
                 fprintf(fid_topo,fmt_topo,topo_3dalongPrifile.');
         %----------------------------------------------
         
         
end         
         
 fclose(fid_DC);
 fclose(fid_IP);
 fclose(fid_topo);
