clear all;
clc;
close all;
format long;
format long g
delete SheikhAll_output.xlsx %delete 
% ===========Make list of folders================
% get the folder contents
 d = dir('D:\Min proj_Ebi\Matlab\OutPut20230612');
% remove all files (isdir property is 0)
 dfolders = d([d(:).isdir]); 
% remove '.' and '..' 
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));

for i=1:length(dfolders)
fname(i) = convertCharsToStrings(dfolders(i).name);
end 

%===============================================
% ss=39
 for ss=1:length(fname)
     ftext=[];data_1 =[];data_2=[];dataout=[];datain_table = [];
     fid = fopen(['D:/Min proj_Ebi/Matlab/OutPut20230612/' fname{ss} '/' fname{ss} '.xyz'],'r');
%      filetext = fileread(['D:/Min proj_Ebi/Matlab/OutPut20230612/' fname{ss} '/' fname{ss} '.xyz']);
     expr = "/the model blocks after incorporating the surface topography.";
%      matches = regexp(filetext,expr);
%      disp(matches')
     
     
ftext = textscan(fid,'%s','Delimiter','\n');
fclose(fid);
data_1 = string(ftext{1});
ind = find(data_1==expr);

data_2= data_1(ind(end)+5:end);
            for j=1:length(data_2)
            dataout(j,:) =  str2num(data_2(j)); 
            end    
datain_table = array2table(dataout,'VariableNames',{'x','topo','rs','cond','IP'});%X       Elevation    Resistivity  Conductivity      I.P.
writetable(datain_table,'SheikhAll_output.xlsx','FileType','spreadsheet','Sheet',fname{ss})
 end
%==================================================================================




clear all;
clc;
close all;
format long;
format long g
delete SheikhAll_output_xy.xlsx %delete 
%  Make the file with x and y cordinate
[~,SheikhAll_output_name]=xlsfinfo('SheikhAll_output.xlsx'); % Reeds the sheet name 
 SheikhAll_output_name2 =SheikhAll_output_name(4:end);%Remove sheet1 2 3 names
 
 [~,SheikhPhase1_name]=xlsfinfo('SheikhPhase1.xlsx'); % Reeds the sheet name 
  [~,SheikhPhase22_name]=xlsfinfo('SheikhPhase22.xlsx'); % Reeds the sheet name 
 
   
   for rr=1:length(SheikhAll_output_name2)
  datain_phas = []; datain_section = [];data_out = [];
  %open file identifier
datain_section =  xlsread('SheikhAll_output.xlsx',SheikhAll_output_name2{rr}); % put each line one by one

%             The section is part of the phase1 or Phase2
            if any(strcmp(SheikhPhase1_name,SheikhAll_output_name2{rr}))  
            datain_phas =  xlsread('SheikhPhase1.xlsx',SheikhAll_output_name2{rr}); % put each line one by one
            else
            datain_phas =  xlsread('SheikhPhase22.xlsx',SheikhAll_output_name2{rr}); % put each line one by one
            end
            
if datain_section(1,1)<800000 % section horizontal then
    data_out (:,1)=datain_section (:,1);
    data_out (:,2)= datain_phas(1,2)*ones(length(datain_section (:,1)),1); 
    data_out (:,3:6)=datain_section (:,2:5);
else
    data_out (:,1)= datain_phas(1,1)*ones(length(datain_section (:,1)),1);
    data_out (:,2)= datain_section (:,1); 
    data_out (:,3:6)=datain_section (:,2:5);
end
rr
 datain_table2 = array2table(data_out,'VariableNames',{'x','y','topo','rs','cond','IP'});%X       Elevation    Resistivity  Conductivity      I.P.
writetable(datain_table2,'SheikhAll_output_xy.xlsx','FileType','spreadsheet','Sheet',SheikhAll_output_name2{rr})
   end