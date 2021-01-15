function [So,Qout]=transfert(t,ft,Qin)

k = .05; % recession cst in d^-1

% make sure no daily precip event are missed
options=odeset('maxstep',1);

% explicit Runge-Kutta (4,5) using ODE solver
[~,So] = ode45(@(t,S) linearReservoir(t,S,ft,Qin,k),t,1e6,options);

% % explicit scheme fixed daily timestep
%  S=1000000*ones(1,length(t));
%  for i=t(1:end-1)
%      dSdt = linearReservoir(i,S(i),ft,Qin);
%      S(i+1)=S(i)+dSdt;
%  end
%  So=S';

So=So';
Qout=k*So;
end

function dSdt=linearReservoir(t,S,ft,Qin,k)
% Interpolate the forcing at time t
Qint = interp1(ft,Qin,t);
Qout = k*S;
dSdt = (Qint - Qout);
end