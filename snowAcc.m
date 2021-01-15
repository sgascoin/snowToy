function acc=snowAcc(P,T)
%acc=P.*(T<0);
%acc=P.*heaviside(-1*T);

% continuous fct for numerical stability
acc=P.*(0.5+0.5*tanh(-10*T));

end
