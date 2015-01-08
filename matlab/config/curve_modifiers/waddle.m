modifier = {};
modifier.type = 'waddle';
modifier.name = 'waddle';
modifier.sampleRate = 150;
modifier.period     = 2.0;
modifier.horShift   = pi / 2;
modifier.maxRoll    = pi / 16;
save('config/curve_modifiers/waddle', '-struct', 'modifier');