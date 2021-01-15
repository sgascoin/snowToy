function dSdt = snowMassBalanceEq(t,S,ft,acc,pabl)

% Interpolate the forcing at time t
acct = interp1(ft,acc,t);
pablt = interp1(ft,pabl,t);

% ablation cannot exceed storage
ablt=min(S,pablt);

% mass balance equation
dSdt=acct-ablt;

end
