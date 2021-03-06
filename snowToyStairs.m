function hf=snowToyStairs(hf,...
    ix,z,swe,colSnow)
% plot topography and max annual SWE by elev band

figure(hf);

colormap([.7*ones(1,3) ; colSnow])
Smax=1e3*max(swe(:,ix),[],2);
if length(z)>1
    h=bar3([z' Smax],1,'stacked');
    ylim([-inf inf])
else % workaround https://fr.mathworks.com/matlabcentral/answers/295950-how-can-i-get-a-stacked-bar-graph-with-a-single-bar
    h=bar3([z' Smax; nan nan],1,'stacked');
    ylim([-inf 1.50]);
end
set(h(2),'EdgeColor',[0    0.4470    0.7410])
set(h(1),'EdgeColor',.5*ones(1,3))
zlim([0 5000])
view(-105.5000,12)
axis square
set(gca,'Xtick',[],'Ytick',[])
legend('Elevation (m)','SWE (mm)',...
    'location','N','Orientation','horizontal'),legend('boxoff')
