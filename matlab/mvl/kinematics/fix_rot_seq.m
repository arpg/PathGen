function poses = fix_rot_seq(poses)
    poses = fix_rot(poses, 4);
    poses = fix_rot(poses, 5);
    poses = fix_rot(poses, 6);
    
    function poses = fix_rot(poses, index)
        % initialize with first pose
        total = poses(index, 1);
        
        % total each subsequent pose
        for i = 2 : size(poses, 2)
            a = poses(index, i - 1);
            b = poses(index, i);

            diff = mod(b - a, 2 * pi);

            if (diff > pi)
                diff = diff - 2 * pi;
            end

            total = total + diff;
            poses(index, i) = total;
        end
    end
end
