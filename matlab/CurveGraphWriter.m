classdef CurveGraphWriter < CurveFileWriter

    properties (Access = private)
    end

    methods (Access = public)
        function this = CurveGraphWriter()
            this.filename = 'graph.png';
        end
    end

    methods (Access = protected)
        function writeFile(this, curve)
            duration = curve.getDuration();
            times = 0 : 1 / 50 : duration;
            poses = curve.getPoses(times);
            
            close all;
            hold on;
            axis equal;
            
            x = poses(1, :);
            y = poses(2, :);
            z = poses(3, :);
            
            plot3(x, y, z);
            waitforbuttonpress();
            
            hold off;
        end
    end

end
