builder = {};
builder.type = 'randloop';
builder.randomBuilder = 'config/path_builders/randpath.mat';
builder.closureBuilder = 'config/path_builders/closure.mat';
builder.map = 'config/maps/default.mat';
save('config/path_builders/default.mat', '-struct', 'builder');