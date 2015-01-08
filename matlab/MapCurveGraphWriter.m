classdef MapCurveGraphWriter < CurveGraphWriter

    properties (Access = private)
        map;
        imgHeight;
        imgWidth;
        dpi;
    end

    methods (Access = public)
        function this = MapCurveGraphWriter()
            this.map = Map;
            this.imgHeight = 850;
            this.imgWidth = 850;
            this.dpi = 150;
        end

        function map = getMap(this)
            map = this.map;
        end

        function setMap(this, map)
            this.map = map;
        end
    end

    methods (Access = protected)
        function writeFile(this, curve)
            % set up graph
            fig = figure();
            this.startFigure(fig);
            
            % create graph
            this.graphMap();
            this.graphCurve(curve);
            this.graphPoses(curve);
            this.saveImage(fig);
            
            % close graph
            hold off;
            close(fig);
        end
    end

    methods (Access = private)
        function startFigure(this, fig)
            set(fig, 'visible', 'off');
            set(gca, 'ZDir', 'reverse', 'YDir', 'reverse');
            set(fig, 'Position', [0, 0, this.imgWidth, this.imgHeight]);
            axis equal;
            axis off;
            hold on;
        end
        
        function graphMap(this)
            count = size(this.map.nodes, 2);

            for i = 1 : count
                node = this.map.nodes(:, i);
                pts = this.map.nodes(:, this.map.links(:, i) == 1);
                node = repmat(node, 1, size(pts, 2));
                x = [ pts(1, :); node(1, :) ];
                y = [ pts(2, :); node(2, :) ];
                z = [ pts(3, :); node(3, :) ];
                plot3(x, y, z, ':', 'Color', [0.8, 0.8, 0.8]);
            end
        end
        
        function graphCurve(this, curve)
            times = curve.getTimes(10);
            poses = curve.getPoses(times);
            n = size(poses, 2);
            
            x = poses(1, :);
            y = poses(2, :);
            z = zeros(1, n);
            
            plot3(x, y, z, 'k-', 'LineWidth', 2);
            
            plot3(x(1), y(1), z(1), '>', 'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', 'g', 'MarkerSize', 10);
        end
        
        function graphPoses(this, curve)
            times = curve.getTimes(2);
            poses = curve.getPoses(times);
            count = size(poses, 2);
            
            for i = 1 : count
                plot_cf(poses(:, i), 4);
            end
        end
        
        function saveImage(this, handle)
            position = [0 0 this.imgWidth this.imgHeight];
            scaledPosition = position / this.dpi;
            filename = this.getFilePath();
            
            set(handle, 'PaperUnits', 'inches');
            set(handle, 'PaperPosition', scaledPosition);
            print(handle, '-dpng', ['-r' num2str(this.dpi)], filename);
        end
    end

end
