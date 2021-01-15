function [P,T,swe,Qout,Qsnowtot,Qglaciertot,Qraintot,SnowMasstot,Sprod]...
    = snowToy(A,t,ft,z,T0,Tlr,P0,Plr,gfA)

nz=length(z);
nft=length(ft);
nt=length(t);

% elev band area 
az=A*ones(nz,1)/nz; % equi-area

[T,P]=deal(zeros(nz,nft));
[abl,acc,swe,gmelt,rain]=deal(zeros(nz,nt));

% Generate daily P,T forcing by elevation bands using MicroMet lapse
% rates
for iz=1:nz
    dz=z(iz)-z(1);
    T(iz,:)=T0+Tlr*dz;
    dz0 = min(dz,1800.0);
    alpha=Plr*dz0;
    P(iz,:)=P0*(1+alpha)/(1-alpha);
end

% solve snow mass balance ODE by elevation band in parallel yeah baby
parfor iz=1:nz
    [swe(iz,:),abl(iz,:),acc(iz,:)]=snowElevBand(t,ft,T(iz,:),P(iz,:));
end

% glacier melt
for iz=1:nz
    gmelt(iz,:) = gfA(iz)*(swe(iz,:)<1e-3).*snowAbl(T(iz,:));
end

% rain runoff
for iz=1:nz
    rain(iz,:) = P(iz,:)-acc(iz,:);
end

% Snow melt discharge by elev band
Qsnow=bsxfun(@times,abl,az);
% Total snow melt discharge
Qsnowtot=sum(Qsnow);
% Glacier melt discharge by elev band
Qglacier=bsxfun(@times,gmelt,az);
% Total glacier melt discharge
Qglaciertot=sum(Qglacier);
% Rain discharge by elev band
Qrain=bsxfun(@times,rain,az);
% Total rain discharge
Qraintot=sum(Qrain);
% swe m3 by elev band
SnowMass=bsxfun(@times,swe,az);
% total swe m3
SnowMasstot=sum(SnowMass);

% transform "surface water input" to discharge using a lumped production function
Qin = Qsnowtot+Qglaciertot+Qraintot;
[Sprod,Qout] = transfert(t,t,Qin);
