function [So,abl,acc]=snowElevBand(t,ft,T,P)

% snow accumulation in m/d
acc=snowAcc(P,T);
% potential ablation in m/d
pabl=snowAbl(T);

% solve mass balance equation

% % explicit scheme fixed daily timestep
% S=zeros(1,length(t));
% for i=t(1:end-1)
%     dSdt = snowMassBalanceEq(i,S(i),ft,acc,pabl);
%     S(i+1)=S(i)+dSdt;
% end
% So=S';

% make sure no daily precip event are missed
options=odeset('maxstep',1);

% explicit Runge-Kutta (4,5) using ODE solver
[~,So] = ode45(@(t,S) snowMassBalanceEq(t,S,ft,acc,pabl),t,0,options);

% retrieve actual ablation
So=So';
abl=min(So,pabl);

