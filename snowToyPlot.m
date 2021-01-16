function snowToyPlot(hf,...
    ix,A,t,P,T,Qout,SnowMasstot,colSnow,colRain,colTemp,colDisch)
% plot some snowToy variables

figure(hf);

% forcing
subplot 311
[AX,H1,H2] = plotyy(t,T(1,:),t,1e3*P(end,:));
hold(AX(1),'on')
hold(AX(2),'on')
plot(AX(2),t,1e3*P(1,:),'color',colRain);
plot(t,T(end,:),'--','color',colTemp);
ylim(AX(1),[-10 20])
ylim(AX(2),[0 40])
set(H1,'color',colTemp)
set(H2,'color',colSnow)
set(AX(1),'YColor',colTemp,'YtickMode','auto')
set(AX(2),'YColor',colRain,'Ytick',[0 20 40])
legend('T (^oC) low','T (^oC) high','P (mm) high', 'P (mm) low')
datetick(AX(1),'x','mmm')
xlim(AX(1),t(ix([1 end])))
xlim(AX(2),t(ix([1 end])))
title('Meteorological forcing')
box off
grid
set(gca,'layer','top')

% total SWE
subplot 312
area(t,1e3*SnowMasstot/A,'facecolor',colSnow,'linestyle','none');
datetick('x','mmm')
xlim(t(ix([1 end])))
ylim([0 500])
title('SWE (mm)')
box off
grid
set(gca,'layer','top')

% outlet discharge
subplot 313
ha=area(t,1e3*Qout./A);
set(ha,'facecolor',colDisch,'linestyle','none')
datetick('x','mmm')
xlim(t(ix([1 end])))
ylim([0 10])
title('Discharge (mm/d)')
box off
grid
set(gca,'layer','top')
