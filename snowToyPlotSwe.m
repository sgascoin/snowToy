function snowToyPlotSwe(hf,ix,z,t,swe)
% plot SWE by elev band

figure(hf);
nz=length(z);
colSwe=cool(nz);
h=plot(t,swe*1e3);
for i=1:nz,set(h(i),'Color',colSwe(i,:));end
datetick('x','mmm')
ylim([0 inf])
xlim(t(ix([1 end])))
legend(num2str(round(z)'))
title('SWE (mm)')
box off
grid
set(gca,'layer','top')
