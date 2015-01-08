modifier = {};
modifier.type = 'group';
modifier.modifiers{1} = 'config/path_modifiers/randspeed.mat';
modifier.modifiers{2} = 'config/path_modifiers/reploop.mat';
save('config/path_modifiers/default', '-struct', 'modifier');