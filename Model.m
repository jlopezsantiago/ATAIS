function y = Model(t,X)

%% Book space
N = length(t);
y = zeros(1,N);

%% Create pointers
%% Initial point of decay phase. If lower than 0, the value is changed to 
%% avaid errors.
if X(2) < 0
   X(2) = t(end)/2;
end
pR = find(t<X(2));
pIni = pR(end);
%% First point of oscillation
pO = find(t>X(6));
pOsc = pO(1);

%% Exponential rise
y(1:pIni) = X(1)*exp((t(1:pIni)-X(2))/X(3));

%% Exponential decay
y(pIni+1:end) = X(1)*exp(-(t(pIni+1:end)-X(2))/X(4));

%% Oscillation with damping
y(pOsc:end) = y(pOsc:end) + X(5)*sin(2*pi*(t(pOsc:end)-X(6))/X(7)) .* ...
              exp(-t(pOsc:end)/X(8)); 


return 
end