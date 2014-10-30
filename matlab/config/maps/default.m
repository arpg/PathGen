map = {};
map.type = 'city';
map.height = 3;
map.width  = 3;
map.blockSize  = 44;
map.streetSize = 20;
map.crossRatio = 2 / 5;
map.offset = [ 0; 0; 0 ];
save('config/maps/default', '-struct', 'map');