classdef RenderParamWriter < CurveFileWriter
    
    properties (Access = private)
        quality;
        antialias;
        antialiasThresh;
        antialiasDepth;
        samplingMethod;
        cyclicAnimation;
        pauseWhenDone;
    end
    
    methods (Access = public)
        function this = RenderParamWriter()
            this.filename = 'Render.ini';
            this.quality = 9;
            this.antialias = 'on';
            this.antialiasThresh = 0.001;
            this.antialiasDepth = 4;
            this.samplingMethod = 2;
            this.cyclicAnimation = 'on';
            this.pauseWhenDone = 'off';
        end

        function quality = getQuality(this)
            quality = this.quality;
        end

        function setQuality(this, quality)
            this.quality = quality;
        end

        function antialias = getAntialias(this)
            antialias = this.antialias;
        end

        function setAntialias(this, antialias)
            this.antialias = antialias;
        end

        function antialiasThresh = getAntialiasThreshold(this)
            antialiasThresh = this.antialiasThresh;
        end

        function setAntialiasThreshold(this, antialiasThresh)
            this.antialiasThresh = antialiasThresh;
        end

        function antialiasDepth = getAntialiasDepth(this)
            antialiasDepth = this.antialiasDepth;
        end

        function setAntialiasDepth(this, antialiasDepth)
            this.antialiasDepth = antialiasDepth;
        end

        function samplingMethod = getSamplingMethod(this)
            samplingMethod = this.samplingMethod;
        end

        function setSamplingMethod(this, samplingMethod)
            this.samplingMethod = samplingMethod;
        end

        function cyclicAnimation = getCyclicAnimation(this)
            cyclicAnimation = this.cyclicAnimation;
        end

        function setCyclicAnimation(this, cyclicAnimation)
            this.cyclicAnimation = cyclicAnimation;
        end

        function pauseWhenDone = getPauseWhenDone(this)
            pauseWhenDone = this.pauseWhenDone;
        end

        function setPauseWhenDone(this, pauseWhenDone)
            this.pauseWhenDone = pauseWhenDone;
        end
    end

    methods (Access = protected)
        function writeFile(this, curve)
            fout = fopen(this.getFilePath(), 'w+');
            fprintf(fout, 'Quality=%d\n', this.quality);
            fprintf(fout, 'Antialias=%s\n', this.antialias);
            fprintf(fout, 'Antialias_Threshold=%f\n', this.antialiasThresh);
            fprintf(fout, 'Antialias_Depth=%d\n', this.antialiasDepth);
            fprintf(fout, 'Sampling_Method=%d\n', this.samplingMethod);
            fprintf(fout, 'Cyclic_Animation=on\n');
            fprintf(fout, 'Pause_when_Done=off');
            fclose(fout);
        end
    end
    
end
