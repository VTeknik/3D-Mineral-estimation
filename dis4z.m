function  [zp]=dis4z(topo,xp,yp)
% this function provides the topo value from nearby points grids
dist=sqrt( ((topo(:,1)-xp).^2) + ((topo(:,2)-yp).^2)  );
sorted_dist = sort(dist);

topo1 = topo(find(dist==sorted_dist(1)),3);
topo2 = topo(find(dist==sorted_dist(2)),3);
topo3 = topo(find(dist==sorted_dist(3)),3);
topo4 = topo(find(dist==sorted_dist(4)),3);
 topo_mean = [topo1 topo2 topo3 topo4];
zp = round(mean(topo_mean),8);

end