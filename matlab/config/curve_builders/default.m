builder = {};
builder.type = 'path';
builder.pathBuilder = 'config/path_builders/default.mat';
builder.pathModifier = 'config/path_modifiers/default.mat';
builder.curveBuilder = 'config/curve_builders/arc.mat';
save('config/curve_builders/default', '-struct', 'builder');