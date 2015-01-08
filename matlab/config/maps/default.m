map = {};
map.type = 'city';
map.height = 3;
map.width  = 3;
map.blockSize  = 24;
map.streetSize = 40;
map.crossRatio = 2 / 3;
map.offset = [ 0; 0; -1.8 ];
save('config/maps/default', '-struct', 'map');