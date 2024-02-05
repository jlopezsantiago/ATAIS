function q = Proposal(X,input1,input2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input data
%
% - X : samples
%
% - mu  : array with the mean of each parameter and 
%            distribution function 
%
% - sigma : 1d-vector with the std deviation of each  
%           distribution function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialise the probability of each variable 
q = 1;
%% Determine the probability of each parameter of all the planets jointly
for i = 1:length(input1)
    q = q.*normpdf(X(i,:),input1(i),input2(i)); 
end

end