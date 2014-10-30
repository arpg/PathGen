builder = {};
builder.type = 'arc';
builder.sampleCount = 150;
builder.pathBuilder = 'config/arc_path_builders/default.mat';
save('config/curve_builders/arc', '-struct', 'builder');