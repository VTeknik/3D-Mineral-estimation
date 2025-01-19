clear all;
clc;
close all;
format long;
format long g

% load the sheets f the data
[~,data_name]=xlsfinfo('IP-Rs Data - Sheikhdar abad - Phase 2_end point Corrected.xlsx');
[~,cord_name]=xlsfinfo('UTM Sheikhdar Abad - Phase 2_edited.xlsx');
delete SheikhPhase2.xlsx %delete 
% length(data_name)
dy =30;
  for ss=1:length(data_name)
 dataout =[];     
  %open file identifier
datain =  xlsread('IP-Rs Data - Sheikhdar abad - Phase 2_end point Corrected.xlsx',data_name{ss}); % put each line one by one
cordin =   xlsread('UTM Sheikhdar Abad - Phase 2_edited.xlsx',data_name{ss}); % put each line one by one



dataout (:,6)=datain(:,4); % I
dataout (:,5)=datain(:,6); % VP
dataout (:,4)=datain(:,5); % m
dataout (:,3)=datain(:,3); % c
dataout (:,7)=datain(:,1); % M
dataout (:,8)=datain(:,2); % N
x0 =cordin(1,1); y0 = cordin(1,2); % first location of Xm or P1 or M1

 Ym=[];Xm=[];idx=[];ind=[];ind_s=[];Mid_Obs=[];
 
%***************************************************** 
if mode (diff(cordin(:,2)) )>0 % for profiles S-N
    dataout (1:length(dataout (:,6)),1)= x0;
   
   for i=1:length(datain (:,1))
        Yc(i)=y0+(datain(i,3)*dy); % this is the cordinate Xm
        Ym(i)= y0+(datain(i,1)*dy);
        Mid_Obs(i) = Ym(i) -  ((2*(datain(i,1) - datain(i,3))+1)*(dy/4) );
   end


  dataout(:,2) = Mid_Obs;      
end  

%*****************************************************

if mode(diff(cordin(:,1)) )>0   % For Profiles E-W
    dataout (1:length(dataout (:,6)),2 )= y0;
   for i=1:length(datain (:,1))
    Xc(i)=x0+(datain(i,3)*dy); % this is the cordinate Xm
    Xm(i)=Xc(i)+(datain(i,1)*dy); % this is the cordinate Xm 
    Mid_Obs(i) = Xm(i) -  ((2*(datain(i,1) - datain(i,3))+1)*(dy/4) );
   end


  dataout(:,1) = Mid_Obs;      
end 
%*****************************************************
datain_table = array2table(dataout,'VariableNames',{'x','y','z','m','VP','I','M','N'});
writetable(datain_table,'SheikhPhase2.xlsx','FileType','spreadsheet','Sheet',data_name{ss})

  end