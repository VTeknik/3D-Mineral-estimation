clear all;
clc;
close all;
format long;
format long g

% load the sheets f the data
[~,sheet_name]=xlsfinfo('IP_Rs Data_SheikhdarAbad.xlsx');

%   PD_W04=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{1});
%   PD_W03=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{2});
%   PD_W02=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{3});
%   PD_W01=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{4});
%   
%   PD_BL=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{5});
%   PD_E01=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{6});
%   PD_E02=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{7});
%   PD_E03=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{8});
%   PD_E04=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{9});
%   PD_E05=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{10}); 
%   PD_E06=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{11});
%   PD_E07=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{12});
%   PD_E08=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{13});
%   
%   PD_EW_h=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{14});
%   Points_Coordinates=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{15});
%   Area_Coordinates=xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{16});
     %================================================
  %load topo grid xyz format
  topo = load('topo2_grid.XYZ');
  %================================================
  
  
 
  
  for ss=1:length(sheet_name)-3
      
  %open file identifier
datain =  xlsread('IP_Rs Data_SheikhdarAbad.xlsx',sheet_name{ss}); % put each line one by one 
mkdir (['D:/Min proj_Ebi/Matlab/OutPut20230612/' sheet_name{ss}])
fid_IPDC=fopen(['D:/Min proj_Ebi/Matlab/OutPut20230612/',sheet_name{ss},'/',sheet_name{ss},'.txt'] ,'w'); %The final ouput name of the file
fprintf(fid_IPDC, [sheet_name{ss},'\n']); %The name of the profile


fprintf(fid_IPDC, ['30 \n']); %Unit electrode spacing
fprintf(fid_IPDC, ['6 \n']); %Array number (pole-dipole=6)
fprintf(fid_IPDC, [num2str(length(datain(:,2))) '\n']); %Number of data points
fprintf(fid_IPDC, ['1 \n']); %x-location given in terms of first electrode use 1 if mid-point location is given
fprintf(fid_IPDC, ['1 \n']); %0 for no IP, use 1 if IP present
fprintf(fid_IPDC, ['Chargeability \n']); %0 for no IP 1 if IP present
fprintf(fid_IPDC, ['mV/V \n']); %0 for no IP unit
fprintf(fid_IPDC, ['0.0,1.0 \n']); %Delay, integration time
%   Array format change
  % =************************S-N********************************************
  % =************************S-N********************************************
  if mean (diff(datain(:,2)) )>15 % for profiles S-N                            
  
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
% ind = [1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 273 289 305 321 337 353 369 ...
%     385 401 417 433 449 464 478 491 503 514 524 533 541 548 554 559 563 566];%PD_H
fig1 = figure(1); 
clf(fig1)
set (fig1, 'units','normalized','outerposition',[0.003 0.04 0.995 0.95]);
 plot(1:length(datain(:,2)),datain(:,2),'b*'); % plot points 
 hold on
%   plot(ind,datain(ind,2),'ro'); % plot points of initaions 
 grid on
 ind = find (diff(datain(:,2))<dy/2);
 ind = [1;ind+1];
plot (ind,datain(ind,2),'ro');
pause
 
 % x indicate the loctions along the profile; it can west-east or south-north
 xloc =[];
 data_out_i = [];topo_out = [];
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
 yloc =  datain(ranges,2);% + (dy/4)%: uses  the mid-point between the C1-P2 electrodes to define the x-location of the array 
 xloc =  datain(1,1)*ones(length(yloc),1); 
 a =  dy*ones(length(yloc),1); 
 n =  1:length(yloc);
 k = 2*pi.*i.*(i+1);
 
 % ======================Calculate the K by cosidering topo================
 % -------------source locations---------------     
 Ya(i) = datain(ind(i),2) - (3*dy/4);
 Xa(i) = datain(1,1);
 Za(i) = dis4z(topo,Xa(i),Ya(i)); % topo value at each point
  % -------------Reciver locations--------------- 
 Ym = datain(ranges,2) + (dy/4);
 Xm =  datain(1,1)*ones(length(Ym),1);
 Yn = Ym + dy;
 Xn = Xm;
 
   Zm = []; Zn = [];       
for j=1:length(Ym)
  Zm(j) = dis4z(topo,Xm(j),Ym(j));        
  Zn(j) = dis4z(topo,Xn(j),Yn(j));         
 end     
Zm = Zm'; Zn = Zn';
% ----------------------------------
 rAM = (  ((Xm-Xa(i)).^2)  +  ((Ym-Ya(i)).^2)  + ((Zm-Za(i)).^2)  ).^0.5;
 rAN = (  ((Xn-Xa(i)).^2)  +  ((Yn-Ya(i)).^2)  + ((Zn-Za(i)).^2)  ).^0.5;
 k = 2*pi ./ ( (1./rAM) - (1./rAN));
 %=========================================================================
 apres=  (datain(ranges,5) ./  datain(ranges,6)).*k;
 IP =   datain(ranges,4); 
% ----------------------------------
 data_out_i =([yloc a n' apres IP]); % for pole-dipole the A and B repeated
  fmt_SRC = '%9.1f, %d, %d, %9.6f, %6.3f \n';
  fprintf(fid_IPDC,fmt_SRC,data_out_i.');
  
  end 
 topo_out = [Xa' Ya' Za'; Xm(2:end) Ym(2:end) Zm(2:end) ; Xn(2:end) Yn(2:end) Zn(2:end)]; % location of all 
[numRows,numCols] = size(topo_out); 
% add topo points
fprintf(fid_IPDC, ['1 \n']); %1 for true horizontal, 2 surface distances 
fprintf(fid_IPDC, [num2str(numRows) '\n']); %Number of topography points 
% add topo points
fmt_SRC_topo = '%9.1f, %9.1f \n';
fprintf(fid_IPDC,fmt_SRC_topo,topo_out(:,2:3).');
fprintf(fid_IPDC, ['1 \n']); %1 topography data point coinciding with first electrode
 fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fclose(fid_IPDC);
  
 %--------------------------------------------------
  
  end %if mean (diff(datain(:,2)) )>15 % for profiles S-N 
  
  
  
  
% =************************E-W********************************************
% =************************E-W********************************************
  if mean (diff(datain(:,1)) )>15 % for profiles E-W 
  
  dx = 30; % step of in the y direction
 dy = 0;
  %================================================
  
%  ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 160 168 175 181 186 190 193];%PD_W01& PD_W01
%  ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 130 138 145 151 156 160 163];%PD_W04
%  ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 160 168 175 181 186 190 193];%PD_BL & PD_E05
% ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 161 171 181 191 200 208 215 221 226 230 233];%PD_E4
% ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 161 171 181 191 201 211 221 ...
%     231 241 251 261 271 281 291 301 311 321 331 341 351 360 368 375 381 386 390 393];%PD_E6
% ind = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 161 171 181 191 201 211 221 ...
%     231 241 251 261 271 280 288 295 301 306 310 313];%PD_E7
% ind = [1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 273 289 305 321 337 353 369 ...
%     385 401 417 433 449 464 478 491 503 514 524 533 541 548 554 559 563 566];%PD_H
fig1 = figure(1); 
clf(fig1)
set (fig1, 'units','normalized','outerposition',[0.003 0.04 0.995 0.95]);
 plot(1:length(datain(:,1)),datain(:,1),'b*'); % plot points 
 hold on
%   plot(ind,datain(ind,1),'ro'); % plot points of initaions 
 grid on
 ind = find (diff(datain(:,1))<dx/2);
 ind = [1;ind+1];
plot (ind,datain(ind,1),'ro');
pause

 % x indicate the loctions along the profile; it can west-east or south-north
 xloc =[];
 data_out_i = [];topo_out = [];
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
 xloc =  datain(ranges,1);% + (dy/4)%: uses  the mid-point between the C1-P2 electrodes to define the x-location of the array 
 yloc =datain(1,2)*ones(length(xloc),1); 
 a =  dx*ones(length(xloc),1); 
 n =  1:length(xloc);
 k = 2*pi.*i.*(i+1);
 
 % ======================Calculate the K by cosidering topo================
 % -------------source locations---------------     
 Xa(i) = datain(ind(i),1) - (3*dx/4);
 Ya(i) = datain(1,2);
 Za(i) =  dis4z(topo,Xa(i),Ya(i)); % topo value at each point
  % -------------Reciver locations--------------- 
 Xm = datain(ranges,1) + (dx/4);
 Ym =  datain(1,2)*ones(length(Xm),1);
 Yn = Ym ;
 Xn = Xm + dx;
 
   Zm = []; Zn = [];       
for j=1:length(Ym)
  Zm(j) = dis4z(topo,Xm(j),Ym(j));        
  Zn(j) = dis4z(topo,Xn(j),Yn(j));         
 end     
Zm = Zm'; Zn = Zn';
% ----------------------------------
 rAM = (  ((Xm-Xa(i)).^2)  +  ((Ym-Ya(i)).^2)  + ((Zm-Za(i)).^2)  ).^0.5;
 rAN = (  ((Xn-Xa(i)).^2)  +  ((Yn-Ya(i)).^2)  + ((Zn-Za(i)).^2)  ).^0.5;
 k = 2*pi ./ ( (1./rAM) - (1./rAN));
 %=========================================================================
 apres=  (datain(ranges,5) ./  datain(ranges,6)).*k;
 IP =   datain(ranges,4); 
% ----------------------------------
 data_out_i =([xloc a n' apres IP]); % for pole-dipole the A and B repeated
  fmt_SRC = '%9.1f, %d, %d, %9.6f, %6.3f \n';
  fprintf(fid_IPDC,fmt_SRC,data_out_i.');
  
  end 
 topo_out = [Xa' Ya' Za'; Xm(2:end) Ym(2:end) Zm(2:end) ; Xn(2:end) Yn(2:end) Zn(2:end)]; % location of all 
[numRows,numCols] = size(topo_out); 
% add topo points
fprintf(fid_IPDC, ['1 \n']); %1 for true horizontal, 2 surface distances 
fprintf(fid_IPDC, [num2str(numRows) '\n']); %Number of topography points 
% add topo points
fmt_SRC_topo = '%9.1f, %9.1f \n';
fprintf(fid_IPDC,fmt_SRC_topo,topo_out(:,1:2:3).');
fprintf(fid_IPDC, ['1 \n']); %1 topography data point coinciding with first electrode
 fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fprintf(fid_IPDC, ['0 \n']); %0 for no IP, use 1 if IP present 
fclose(fid_IPDC);
  
 %--------------------------------------------------
  
  end%mean (diff(datain(:,1)) )>15 % for profiles EW 
  
  
  end