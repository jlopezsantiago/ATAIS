function error = warnings(d)

%% Initialize error
error = 0;
%% Check whether a covariance matrix exists
if ~isfield(d,'Sigma') 
   disp('WARNING: Covariance matrix does not exist in the structure or');
   disp('         it is not named correctly. Diagonal unitary covariance');
   disp('         matrix will be assumed');
end
%% Check whether data exists
if ~isfield(d,'x') || ~isfield(d,'y')
   disp('ERROR 101: data vectors do not exist in the structure or');
   disp('           they are not named correctly. Please, verify the');
   disp('           vectors x (variable) and y (observations) exist'); 
   disp('           in the structure.');
   error = error + 1; 
end
%% Check whether Prior and Input parameters exist
if ~isfield(d,'pA') || ~isfield(d,'pB') || ~isfield(d,'qA') || ~isfield(d,'qB')
   disp('Error 102: prior or proposal distribution inputs do not exist'); 
   disp('           in the structure or they are not named correctly.');
   disp('           Prior distribution inputs must be named pA and pB');
   disp('           and the Proposal distribution inputs, qA and qB');
   disp('           in the structure with the data.');
   error = error + 1;
end
%% Check whether the adaptation logical vector is provided
if ~isfield(d, 'adapt')
  disp('WARNING: no information is given for adaptation. Adaptation of');
  disp('         the proposal distribution will not be done. Please include');
  disp('         an array of logical values with the position of the ');
  disp('         parameters to be adapted in the Proposal inputs vector');
  disp('         if adaptation of the proposal distribution is required.');
  disp('         ');
end
%% Check whether the adaptation logical vector is provided
if ~isfield(d, 'minStd') && isfield(d, 'adapt')
  disp('ERROR 103: adaptation is required by the user but the array stdMin');
  disp('           is not provided.');
  error = error + 1;
end

end