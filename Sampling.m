function samples = Sampling(input1, input2, N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input data
%
% - mu        : 1d-vector with the mean of each parameter and 
%               distribution function 
%
% - Std. Dev. : 1d-vector or array with the width of each  
%               distribution function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Determine the number of planets
sizeX = length(input1);
%% Book Space
samples = zeros(sizeX,N);
%% Determine the probability of each parameter of all the planets jointly
for i = 1:sizeX
    samples(i,:) = normrnd(input1(i),input2(i),[1,N]);
end

end