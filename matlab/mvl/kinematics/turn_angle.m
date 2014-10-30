function angle = turn_angle(a, b, c)
    % convert to b-space
    ba = a - b;
    bc = c - b;
    
    % compute ratio of x-length to radius
    x = dot(ba, bc) / (norm(ba) * norm(bc));
    x = max(min(x, 1), -1);
    
    % compute final angle
    angle = acos(x);
end