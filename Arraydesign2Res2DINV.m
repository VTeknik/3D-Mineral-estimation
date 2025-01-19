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
  PD_E06=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{11});
  PD_E07=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{12});
  PD_E08=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{13});
  
  PD_EW_h=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{14});
  Points_Coordinates=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{15});
  Area_Coordinates=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{16});
  
%    %================================================
%   %load topo grid xyz format
%   topo = load('topogrid_xyz.XYZ');
%   
%   topo2 = [topo(:,2) topo(:,1) topo(:,3)];
%   save ('topogrid2_xyz.XYZ', 'topo2', '-ASCII')
%   
%   topo3 = sortrows(topo, 1);
%    save ('topogrid3_xyz.XYZ', 'topo3', '-ASCII')
%   %================================================
  %open file identifier
datain =  PD_EW_h; % put each line one by one 
fid_IPDC=fopen('D:/Min proj_Ebi/Matlab/NewDataRes/PD_EW_h.txt','w'); %The final ouput name of the file
fid_IPDC2=fopen('D:/Min proj_Ebi/Matlab/NewDataRes/PD_EW_htopo.txt','w'); %The final ouput name of the file
fid_IPDC3=fopen('D:/Min proj_Ebi/Matlab/NewDataRes/PD_EW_htopo2.txt','w'); %The final ouput name of the file
fprintf(fid_IPDC, ['PD_EW_h \n']); %The name of the profile


fprintf(fid_IPDC, ['30 \n']); %Unit electrode spacing
fprintf(fid_IPDC, ['6 \n']); %Array number (pole-dipole=6)
fprintf(fid_IPDC, [num2str(length(datain(:,2))) '\n']); %Number of data points
fprintf(fid_IPDC, ['1 \n']); %x-location given in terms of first electrode use 1 if mid-point location is given
fprintf(fid_IPDC, ['1 \n']); %0 for no IP, use 1 if IP present
fprintf(fid_IPDC, ['Chargeability \n']); %0 for no IP 1 if IP present
fprintf(fid_IPDC, ['mV/V \n']); %0 for no IP unit
fprintf(fid_IPDC, ['0.0,1.0 \n']); %Delay, integration time
%   Array format change
  
 dy = 30; % step of in the y direction
 dx = 0;
  %================================================
  
%  ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 160 168 175 181 186 190 193];%PD_W01& PD_W01
%  ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 130 138 145 151 156 160 163];%PD_W04
%  ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 160 168 175 181 186 190 193];%PD_BL & PD_E05
% ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 161 171 181 191 200 208 215 221 226 230 233];%PD_E4
% ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 161 171 181 191 201 211 221 ...
%     231 241 251 261 271 281 291 301 311 321 331 341 351 360 368 375 381 386 390 393];%PD_E6
% ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 161 171 181 191 201 211 221 ...
%     231 241 251 261 271 280 288 295 301 306 310 313];%PD_E7
ind = [1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 273 289 305 321 337 353 369 ...
    385 401 417 433 449 464 478 491 503 514 524 533 541 548 554 559 563 566];%PD_H
 plot(1:length(datain(:,2)),datain(:,2),'*'); % plot points 
 hold on
  plot(ind,datain(ind,2),'ro'); % plot points of initaions 
 grid on

 numHead= [length(ind)]; % first line of the input file


%  0.0 1.0 1 30.1 | For each data point; enter x-location, "a"
% 1.0 1.0 1 30.1 | spacing, "n" factor value, apparent
% 2.0 1.0 1 30.1 | resistivity

 
  xloc =[];

 data_out_i = [];
 ii = 1;
 for i = 1:length(ind)
     i
   xloc=[];yloc=[];a=[];n=[]; apres=[]; IP =[];
   
   
if i==length(ind) % for the last point you should count number of the points by using fig and write here
 ranges =ind(i):ind(i)+2; % here the last number indicate the number of the points minus 1
else
 ranges =ind(i):ind(i+1)-1; % range of recivers for each pints
end
% ----------------------------------source locations---------------
% ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 130 138 145 151 156 160 163];
 xloc =  datain(ranges,2);% + (dy/4)%: uses  the mid-point between the C1-P2 electrodes to define the x-location of the array 
 yloc=datain(1,1)*ones(length(xloc),1); 
 a =  dy*ones(length(xloc),1); 
 n =  1:length(xloc);
 k = 2*pi.*i.*(i+1);
 
 % ======================Calculate the K by cosidering topo================
 % ----------------------------------source locations---------------     
    
 Xa =  datain(ind(i),2) - (3*dy/4); 
 Za =  datain(ind(i),7);
 Ym = datain(ranges,2) + (dy/4) ;
 Yn = Ym + dy;
  Zm_j(j) =           
  Zn_j(j) =            
      

% ----------------------------------

 xm
 rAM = 
 rAN = 
 %=========================================================================
 apres=  (datain(ranges,5) ./  datain(ranges,6)).*k;
 IP =   datain(ranges,4); 

% ----------------------------------
% if i==length(ind) % for the last point you should count number of the points by using fig and write here
%  ranges =ind(i):ind(i)+2;
% else
%  ranges =ind(i):ind(i+1)-1; % range of recivers for each source 
% end

 data_out_i =([xloc a n' apres IP]); % for pole-dipole the A and B repeated
  fmt_SRC = '%9.1f, %d, %d, %9.6f, %6.3f \n';
  fprintf(fid_IPDC,fmt_SRC,data_out_i.');
  % for output of only location of the points 
  fmt_SRC2 = '%9.1f, %9.1f \n';
  data_out_i2 =([yloc xloc]); % for pole-dipole the A and B repeated
  fprintf(fid_IPDC2,fmt_SRC2,data_out_i2.');
 end 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
  fclose(fid_IPDC);
  fclose(fid_IPDC2);
 %--------------------------------------------------
topocor=load('D:/Min proj_Ebi/Matlab/NewDataRes/PD_EW_htopo.txt');

 xx = topocor (:,1);
 yy = topocor (:,2);
 
 yy=unique(yy);
 xx = datain(1,1)*ones(length(yy),1);
   fmt_SRC3 = '%9.1f, %9.1f \n';
  data_out_i3 =([xx yy]); % for pole-dipole the A and B repeated
  fprintf(fid_IPDC3,fmt_SRC3,data_out_i3.');
  fclose(fid_IPDC3);
 % ----------------------------------Reciver locations-------------- 

