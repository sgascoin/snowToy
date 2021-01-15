function abl=snowAbl(T)
k=0.4e-2; % degree day factor [0.2-0.5] cm/?C/d (0.05)
abl=k*T.*(T>0); %in m/d

% smoother fct for numerical stability => use softplus

end
