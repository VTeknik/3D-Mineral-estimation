clear all
clc
close all

% -------------------load data------------------------------------------ 
load Prediction_inout.XYZ; % Import XYZ format Bouguer and topo data: 
datain = Prediction_inout; % Replace loaded data in "datain".
x = datain(:,1); % longitude of each point
y = datain(:,2);% Latitude of each point
topo = datain(:,3); % topo
% -------------------load data------------------------------------------
data_out=[];
for i=1:length(x)
  i
    topo_c=topo(i):-20:topo(i)-300;
    xc = repmat(x(i),1,length(topo_c));
    yc = repmat(y(i),1,length(topo_c));
    data_out= [xc' yc' topo_c'; data_out];

end
 save ('prediction_out.txt', 'data_out', '-ascii')

 
%  Training2 = removevars(Training2, 'VarName12');
% Training2(1,:) = [];
CUfit = trainedModel.predictFcn(Prediction2);
 predicted =Prediction2;
predicted.('CU_predicted') = CUfit;
ind = find(isnan(predicted.CU_predicted));
predicted2 = predicted;
predicted2(ind,:) = [];
writetable(predicted2)