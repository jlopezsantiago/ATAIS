function chain = ATAIS(d,nSteps,N,initGamma)

%% STEP 1 : CHECK data in the input structure
error = warnings(d);
if error ~= 0
   return 
end

%% STEP 2 : CREATE VARIABLES AND BOOK SPACE
%% Pass Data from the structure to accelerate access
x = d.x;
y = d.y;
pA = d.pA;
pB = d.pB;
qA = d.qA;
qB = d.qB;
%% Number of data points
nData = length(x);
%% Dimensions of the parameter space
sz = size(pA);
dims = sz(1);
%% Define the covariance matrix
if isfield(d,'Sigma')
    Sigma = d.Sigma;
else
    Sigma = eye(nData);
end
%% Adaptation
if isfield(d,'adapt')
   adapt = d.adapt;
end
%% Minimum variance accepted for the adaptation.
%% OBSOLET: from version 1.01, the code will give ERROR 103 and the 
%% code will not be executed if 'minStd' is not given but 'adapt' exists. 
if ~isfield(d,'minStd')
   minStd = d.pB;
else
   minStd = d.minStd;
end
%% Generate value for tempering. 
if ~exist('initGamma','var')
   initGamma = 1;
end
%% Create a vetor with the value of the tempering for each step. 
gamma = zeros(1,nSteps) + initGamma;

%% Book Space
maxLogTarget = zeros(1,nSteps);
mdMAP = zeros(1,nSteps);
partialMAP = zeros(dims,nSteps);
mu = zeros(dims,nSteps);
var = zeros(dims,nSteps);
qInputsA = zeros(dims,nSteps);
qInputsB = zeros(dims,nSteps);
%% Initializations (HISTORY)
previousMD = Inf;                    % Mahalanobis distance to adapt gamma 
maxMAP = d.qA;                       % Maximum MAP to save
nClip = floor(sqrt(N));              % For weight clipping

for iter = 1:nSteps
    
    fprintf('Iter = %i \ngamma = %.3f \n', iter, gamma(iter));
    %% Initialization of some variables that depend only on N.
    %% The initialization is done here to avoid using values from the 
    %% previous iteration
    logLH = zeros(1,N) - Inf;
    sumDiff = zeros(1,N) + Inf;
    dSquare = zeros(1,N) + Inf;
    wn2 = zeros(1,N);
    %% Save parameters of the proposal used for sampling at this step
    qInputsA(:,iter) = qA;
    qInputsB(:,iter) = qB;
    
    %% Sample from the Proposal
    samples = Sampling(qA, qB, N);
    %% Prior probability
    p = Prior(samples,pA, pB);
    %% Proposal probability
    q = Proposal(samples,qA, qB);
    %% Likelihood
    parfor m = 1:N
       model = Model(x,samples(:,m));
       diff = (model - y);
       dSquare(m) = sum(diff.^2);
       sumDiff(m) = (diff/Sigma)*diff';
       logLH(m) = -0.5*sumDiff(m) - 0.5*logdet(Sigma) - ...
                   0.5*nData*log(2*pi);
    end
    %% Copy of logLH without tempering
    copyLogLH = logLH;
    %% Apply Autotempering
    logLH = logLH/gamma(iter);
    %% logPosterior
    logTarget = logLH + log(p);
    %% logWeights
    logw = logTarget - log(q);
    %% "Normalised" Weights
    logw2 = logw - max(logLH);
    w2 = exp(logw2);
    %% Clipping 
    wPoints = find(w2 > 0);
    if length(wPoints) <= nClip
       [sortedlogw2, ~] = sort(logw2, 'descend');
       valueClip = sortedlogw2(nClip);
       wn2(logw2 >= valueClip) = 1/nClip;
    else
       wn2 = w2/nansum(w2);
    end 
    % wn2 = w2/nansum(w2);
    %% Save mean and variance. If wn2 has collapsed, the mean should
    %% coincide with the MAP. 
    mu(:,iter) = sum(repmat(wn2,dims,1).*samples,2);
    var(:,iter) = sum(repmat(wn2,dims,1).*(samples - mu(:,iter)).^2,2);
    
    %% Determine MAP. This could be done from the logarithmic posterior
    %% directly. positionMAP is a logical array. It may cause errors if
    %% the dimension of MAP is higher than 1, but it is quite unprobable.
    maxLogTarget(iter) = max(logTarget);
    positionMAP = find(logTarget == maxLogTarget(iter));
    positionMAP = positionMAP(1);
    partialMAP(:,iter) = samples(:,positionMAP);
    %% Update gamma if lower distance is found.
    mdMAP(iter) = sumDiff(positionMAP); %% Mahalanobis
    if mdMAP(iter) < previousMD 
       maxMAP = partialMAP(:,iter);
       previousMD = mdMAP(iter);
       gamma(iter+1) = mdMAP(iter)/nData;
    else
       gamma(iter+1) = gamma(iter);
    end
    
    %% Adapt proposal. If "Cycling" is active, the variance/width of the 
    %% proposal is adapted following a sinusoid over iter. Else, 
    %% the variance/width of the proposal is adapted as usual.  
    if isfield(d, 'adapt')
       qA(adapt) = maxMAP(adapt);
       if isfield(d,'freqCyclingRate') && isfield(d,'Delta') 
          qB(adapt) = 0.5*d.Delta(adapt)*cos(d.freqCyclingRate*iter) + ...
                      0.5*d.Delta(adapt) + minStd(adapt);
       else
          qB(adapt) = max(sqrt(var(adapt,iter)), minStd(adapt)); 
       end
    end
    %% Save samples
    fic = 'ATAISstep' + string(iter);
    stepSamples = samples;
    stepLogLH = copyLogLH;
    stepP = p;
    stepQ = q;
    stepDsquare = dSquare;
    save(fic,'stepSamples','stepLogLH','stepP', 'stepQ', 'stepDsquare');
    
end

%% Adaptation
if isfield(d,'fic')
   fic = d.fic;
else
   fic = 'ATAISResult';
end

%% Save generic results
save(fic,'mu','var','partialMAP','gamma','maxMAP','qInputsA','qInputsB');

%% Output : maximum MAP
chain = maxMAP;

end