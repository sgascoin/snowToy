%% Script to simulate the hydrograph of a changing topography

% figure export folders
outfA=['..' filesep 'figs' filesep 'A' filesep];
outfB=['..' filesep 'figs' filesep 'B' filesep];
mkdir(outfA)
mkdir(outfB)

%% model setup
A=10e6; % catchment area in sq m
nz=20; % nb of elev bands
zmin=2000; % elevation of the lowest elev band
zmax=2000:10:3500; % elev of the top band
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

%% plot options
colSnow=[0 175 234]/255;
colRain=[64 109 180]/255;
colTemp=[237 122 37]/255;
colDisch=[203 206 233]/255;
ix=(1:365)+181; % plot only 1 water year

%% Loop on the elevation of the uppermost elevation band

% init progress bar
reverseStr = '';

for izmax=1:100:nzmax
    
    % band elevations linearly spaced from zmin to zmax
    z=linspace(zmin,zmax(izmax),nz);
    
    % run model
    [P,T,swe,Qout,Qsnowtot,Qglaciertot,Qraintot,SnowMasstot,~]...
        = snowToy(A,t,ft,z,T0,Tlr,P0,Plr,gfA);
    
    % fig A: plot some snowToy variables
    figure(1),clf
    snowToyPlot(1,ix,A,t,P,T,Qout,SnowMasstot,colSnow,colRain,colTemp,colDisch);
    
    % export fig A
    saveas(1,sprintf('%ssnowToyLoop%04d.png',outfA,izmax))
    clf(1)
    
    % fig B: plot topography and max annual SWE by elev band
    figure(2),clf
    snowToyStairs(2,ix,z,swe,colSnow);
    
    % export fig B
    saveas(2,sprintf('%ssnowToyLoopStairs%04d.png',outfB,izmax))
    
    % Display the progress
    msg=sprintf('Percent done: %3.1f', 100*izmax/nzmax);
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
    
end
fprintf('\nEnd\n')

%% shell commands to make movie
! mkdir -p ../figs/AB
! ls -v ../figs/A/*png > A.txt
! ls -v ../figs/B/*png > B.txt
! /usr/local/bin/parallel --xapply /usr/local/bin/convert +append {2} {1} ../figs/AB/{2/}  ::: $(cat A.txt) ::: $(cat B.txt)
! /usr/local/bin/ffmpeg -r 25 -pattern_type glob -i '../figs/AB/*.png' -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -pix_fmt yuv420p ../figs/video.mp4
! /usr/local/bin/ffmpeg -i ../figs/video.mp4 -vf reverse ../figs/reversed.mp4
! echo "file 'video.mp4'" > ../figs/list.txt
! echo "file 'reversed.mp4'" >> ../figs/list.txt
! /usr/local/bin/ffmpeg -f concat -safe 0 -i ../figs/list.txt -c copy ../figs/vidrev.mp4
! rm -rf ../figs/video.mp4 ../figs/reversed.mp4 A.txt B.txt
