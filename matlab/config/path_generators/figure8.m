generator = {};
generator.builder = 'config/curve_builders/figure8.mat';
generator.modifier = 'config/curve_modifiers/empty.mat';
generator.writer = 'config/curve_writers/figure8.mat';
save('config/path_generators/figure8.mat', '-struct', 'generator');
