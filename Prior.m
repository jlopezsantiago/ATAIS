function p = Prior(X,input1,input2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input data
%
% - X : array with the value of the sample
%
% - input1 : 1d-vector with the first parameter of each 
%            distribution function 
%
% - input2 : 1d-vector with the second parameter of each 
%            distribution function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Determine the probability of each parameter 
p = 1;
for i = 1:length(input1) 
   p = p.*unifpdf(X(i,:),input1(i),input2(i));
end 

end