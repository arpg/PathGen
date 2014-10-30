modifier = {};
modifier.type = 'waddle';
modifier.name = 'waddle';
modifier.sampleRate = 150;
modifier.amplitude  = 0.5;
modifier.period     = 1;
modifier.horShift   = pi / 2;
modifier.maxRoll    = pi / 8;
save('config/curve_modifiers/waddle', '-struct', 'modifier');