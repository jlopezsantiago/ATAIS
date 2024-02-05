%% Read data from file
M = dlmread('simulFlare.txt');
tObs = M(:,1)' - M(1,1)';
rvObs = M(:,2)';
eRvObs = M(:,3)';
ndata = length(tObs);
%% Sort data according to their observing time
[tOrdered, tOrderedPos] = sort(tObs);
tObs = tObs(tOrderedPos);
rvObs = rvObs(tOrderedPos);
eRvObs = eRvObs(tOrderedPos);
%% Covariance matrix of data
% Sigma = eye(ndata).*eRvObs.^2;
Sigma = eye(ndata)*4;

%% Read prior inputs from file
priorInputs = dlmread('priorInputs.dat');
%% Read proposal inputs from file
proposalInputs = dlmread('proposalInputs.dat');

%% Prepare vectors with inputs for prior and proposal 
sz1 = size(priorInputs);
sz2 = size(proposalInputs);
%% First check: number of planets. If pInputs and qInputs do not contain
%% the same number of rows and columns, the execution is stopped. 
if ~isequal(sz1,sz2)
   disp('WARNING: The number of columns in the prior and proposal') 
   disp('         distributions do not match. Both files must ')
   disp('         contain 2 columns with the input parameters')
   disp('         to the prior and proposal distributions.')
   return
end

%% Create a logical vector for adaptation step
adapt = logical([1; 1; 1; 1; 1; 1; 1; 1]);

%% Create a vector with the minimum possible standard deviation of the 
%% parameters
minstd = [0.01; 0.01; 0.01; 0.01; 0.01; 0.01; 0.01; 0.01];

%% For cycling adaptation rate 
maxstd = [10; 10; 10; 10; 10; 10; 10; 10];
Delta = maxstd - minstd;
PeriodOfCyclingRate = 20;
freqCyclingRate = 2*pi/PeriodOfCyclingRate;

%% Output name
fic = 'ATAISResultCycling';

%% Save data for the MCMC in a structure. 
Data = struct('x', tObs, 'y', rvObs, 'Sigma', Sigma, ...
              'ndata', ndata, ...
              'pA', priorInputs(:,1), ...
              'pB', priorInputs(:,2), ...
              'qA', proposalInputs(:,1), ...
              'qB', proposalInputs(:,2), ...
              'adapt', adapt, ...
              'minStd', minstd, ...
              'maxStd', maxstd, ...
              'Delta', Delta, ...
              'freqCyclingRate' , freqCyclingRate, ...
              'fic', fic); 
save('initializationCycling.mat','Data');
