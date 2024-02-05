%% Load data from the saved structure
load('initializationCycling.mat');

%% Define the arguments for the AIS
%% Number of steps in the chain
nSteps = 30;
%% Number of particles
N = 10000; 

tic
chain = ATAIS(Data,nSteps,N,1);
toc

d = load(Data.fic);

%% Figures
figure(2);
plot(Data.x,Data.y);
hold on
%for i = 5:nSteps
%   plot(Data.x,Model(Data.x,d.partialMAP(:,i)),'Color',[0.5, 0.5, 0.5]) 
%end
plot(Data.x,Model(Data.x,d.maxMAP),'k','LineWidth',2);
%ax = gca;
%ax.FontSize = 16;
%xlabel('time (days)','FontSize',18)
%ylabel('radial velocity (m/s)','FontSize',18)
grid(gca,'minor');
grid on;
hold off
%%
%figure(3);
%plot(d.gamma)
