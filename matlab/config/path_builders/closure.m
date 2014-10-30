builder = {};
builder.type = 'closure';
builder.minTurnAngle = pi / 3;
builder.tightTurnWeight = 100000;
builder.retraceWeight = 250;
builder.openIndices = 1;
builder.map = 'config/maps/default.mat';
save('config/path_builders/closure.mat', '-struct', 'builder');