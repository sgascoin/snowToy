%%
% *Snow hydrology toy model (demo with glacier)*
%% Model setup
A=10e6; % catchment area in sq m
nz=10; % nb of elev bands
zmin=2000; % elevation of the lowest elev band
zmax=3500; % elev of the top band

% band elevations linearly spaced from zmin to zmax
z=linspace(zmin,zmax,nz);
nzmax=length(zmax); % nb of increments

gfA=zeros(1,nz); % glacier fraction area per elevation band

ft=1:365*2; % forcing time vector: two years
t=ft; % computation time vector

Tlr=-0.6e-2; % temp lapse rate in dC/m (-0.6d/100m)
Plr=0.2e-3; % precip lapse rate in m-1 (0.2 km-1)
Pmax=20e-3; % max precip rate by timestep (m)
aT=20; % temp annual amplitude in dC
mT0=10; % mean annual temp at z(1) in dC

% daily temp in dC at z(1) (sinusoid of amplitude aT, mean mT0)
T0=mT0+0.5*aT*cos(2*pi*ft/365+pi);

% daily precip rate in m at z(1) (sinusoid set to zero at 80% random dates)
P0=0.5*Pmax+0.5*Pmax*cos(ft*2*pi/365);
rng(0);
y=randsample(length(ft),0.8*length(ft));
P0(y)=0;

%% Run model for different glacier fraction
gftop=0:0.1:0.5; % define glacier fraction in the uppermost band
ngf=length(gftop);

for igf=1:ngf
    
    % linearly increasing glacier fraction in top 5 bands
    gfA(end-4:end)=linspace(0,gftop(igf),5);
    
    % Run model
    [P,T,swe,Qout,Qsnowtot,Qglaciertot,Qraintot,SnowMasstot,~]...
        = snowToy(A,t,ft,z,T0,Tlr,P0,Plr,gfA);
    
    % Export discharge
    out.Qout{igf}=Qout;
end

%% Plot options
colSnow=[0 175 234]/255;
colRain=[64 109 180]/255;
colTemp=[237 122 37]/255;
colDisch=[203 206 233]/255;
colDischGla=[239,243,255;
    198,219,239;
    158,202,225;
    107,174,214;
    49,130,189;
    8,81,156]/255; % "blues" palette from colorbrewer
ix=(1:365)+181; % plot only 1 water year

%% Plot hydrographs
figure(1),clf
snowToyPlot(1,ix,A,t,P,T,Qout,SnowMasstot,colSnow,colRain,colTemp,0*colDisch);
% erase subplot 313
hold all
for igf=ngf:-1:1
    ha=area(t,1e3*out.Qout{igf}./A);
    set(ha,'facecolor',colDischGla(igf,:),'linestyle','none')
end
plot(t,1e3*out.Qout{igf}./A,'color',colDisch)

%% Plot glacier fraction
figure(2),clf
hold all
ha=barh(z,ones(size(z)),1);
set(ha,'facecolor',.7*ones(1,3),'linestyle','none')
for igf=ngf:-1:1
    gfA(end-4:end)=linspace(0,gftop(igf),5);
    ha=barh(z,gfA,1);
    set(ha,'facecolor',colDischGla(igf,:),'linestyle','none')
end
ha=barh(z,ones(size(z)),1);
set(ha,'facecolor','non','linestyle','-')
title('Glacier fraction by elevation band')
ylabel('Elevation (m)')
set(gca,'xtick',[])
axis tight
