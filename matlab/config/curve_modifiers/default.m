modifier = {};
modifier.type = 'group';
modifier.name = 'group';
modifier.modifiers{1} = 'config/curve_modifiers/bounce.mat';
modifier.modifiers{2} = 'config/curve_modifiers/snake.mat';
save('config/curve_modifiers/default', '-struct', 'modifier');
