

function [Mean,Var,Std_dev,Skew,Kur]=MyStatistics(Vec) %Find all the required statistics.
Mean=sum(sum(Vec))/(size(Vec,1)*size(Vec,2));
% % Mean=mean2(Vec);
Temp1=(Vec-Mean).^2/((size(Vec,1)*size(Vec,2))-1);
Var=sum(sum(Temp1));
Std_dev=sqrt(Var);
Temp2=((Vec - Mean).^3)/(((size(Vec,1)*size(Vec,2))-1)*Std_dev^3);
Skew= sum(sum(Temp2));
Temp3 = ((Vec - Mean).^4)/(((size(Vec,1)*size(Vec,2))-1)*Std_dev^4);
Kur = sum(sum(Temp3));
end