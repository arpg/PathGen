generator = {};
generator.builder = 'config/curve_builders/default.mat';
generator.modifier = 'config/curve_modifiers/default.mat';
generator.writer = 'config/curve_writers/default.mat';
save('config/path_generators/default.mat', '-struct', 'generator');
