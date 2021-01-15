<div class="content">

**Snow hydrology toy model**

## Contents

<div>

*   [Model setup](#1)
*   [Plot options](#2)
*   [Run model](#3)
*   [Plot some variables](#4)
*   [Plot topography and max annual SWE by elev band](#5)
*   [Plot SWE by elevation](#6)

</div>

## Model setup<a name="1"></a>

<pre class="codeinput">A=10e6; <span class="comment">% catchment area in sq m</span>
nz=20; <span class="comment">% nb of elev bands</span>
zmin=2000; <span class="comment">% elevation of the lowest elev band</span>
zmax=3500; <span class="comment">% elev of the top band</span>

<span class="comment">% band elevations linearly spaced from zmin to zmax</span>
z=linspace(zmin,zmax,nz);
nzmax=length(zmax); <span class="comment">% nb of increments</span>

gfA=zeros(1,nz); <span class="comment">% glacier fraction area per elevation band</span>

ft=1:365*2; <span class="comment">% forcing time vector: two years</span>
t=ft; <span class="comment">% computation time vector</span>

Tlr=-0.6e-2; <span class="comment">% temp lapse rate in dC/m (-0.6d/100m)</span>
Plr=0.2e-3; <span class="comment">% precip lapse rate in m-1 (0.2 km-1)</span>
Pmax=10e-3; <span class="comment">% max precip rate by timestep (m)</span>
aT=20; <span class="comment">% temp annual amplitude in dC</span>
mT0=10; <span class="comment">% mean annual temp at z(1) in dC</span>

<span class="comment">% daily temp in dC at z(1) (sinusoid of amplitude aT, mean mT0)</span>
T0=mT0+0.5*aT*cos(2*pi*ft/365+pi);

<span class="comment">% daily precip rate in m at z(1) (sinusoid set to zero at 80% random dates)</span>
P0=Pmax+Pmax*cos((ft-ft(1))*2*pi/length(ft)*2);
rng(0);
y=randsample(length(ft),0.8*length(ft));
P0(y)=0;
</pre>

## Plot options<a name="2"></a>

<pre class="codeinput">colSnow=[0 175 234]/255;
colRain=[64 109 180]/255;
colTemp=[237 122 37]/255;
colDisch=[203 206 233]/255;
ix=(1:365)+181; <span class="comment">% plot only 1 water year</span>
</pre>

## Run model<a name="3"></a>

<pre class="codeinput">[P,T,swe,Qout,Qsnowtot,Qglaciertot,Qraintot,SnowMasstot,~]<span class="keyword">...</span>
    = snowToy(A,t,ft,z,T0,Tlr,P0,Plr,gfA);
</pre>

## Plot some variables<a name="4"></a>

<pre class="codeinput">figure(1),clf
snowToyPlot(1,ix,A,t,P,T,Qout,SnowMasstot,colSnow,colRain,colTemp,colDisch);
</pre>

![](html/snowToyDemo_01.png)

## Plot topography and max annual SWE by elev band<a name="5"></a>

<pre class="codeinput">figure(2),clf
snowToyStairs(2,ix,z,swe,colSnow);
</pre>

![](html/snowToyDemo_02.png)

## Plot SWE by elevation<a name="6"></a>

<pre class="codeinput">figure(2),clf
iz = 1:nz;
n=length(iz);
colSwe=cool(n);
h=plot(t,swe(iz,:)*1e3);
<span class="keyword">for</span> i=1:n,set(h(i),<span class="string">'Color'</span>,colSwe(i,:));<span class="keyword">end</span>
datetick(<span class="string">'x'</span>,<span class="string">'mmm'</span>)
ylim([0 inf])
xlim(t(ix([1 end])))
legend(num2str(round(z(iz))'))
title(<span class="string">'SWE (mm)'</span>)
box <span class="string">off</span>
grid
set(gca,<span class="string">'layer'</span>,<span class="string">'top'</span>)
</pre>

![](html/snowToyDemo_03.png)

[Published with MATLAB? R2014b](http://www.mathworks.com/products/matlab/)  

</div>