PathGen
=======

Matlab project for generating povray camera paths.


## Configuration ##

Functionality is largely driven by configuration files, which are in the form
of .mat files. The majority of the classes in this project have factory class
that reads a .mat file to create new objects. Default config files have already
been provided (as well as scripts for editing them). Look in the 'config'
directory for more information.

The default configuration currently writes a collection of camera-path files to
the './paths' directory.


## Running ##

NOTE: The 'mvl' folder should first be added to the Matlab path.

**Examples:**

<code>&gt;&gt; genpaths;</code>

Generates single path using the default PathGenerator.

<code>&gt;&gt; genpaths(10);</code>

Generates 10 paths using the default PathGenerator.

<code>&gt;&gt; genpaths(10, pathGenerator);</code>

Generates 10 paths using a custom PathGenerator instance.

<code>&gt;&gt; genpaths(10, 'myconfig.mat');</code>

Generates 10 paths using a custom PathGenerator created by the
PathGeneratorFactory class with the given config file.


## Known Issues ##

* Generated closed paths often have sharp 180 degree turns. This is due to the
map design (CityMapBuilder) and the employed path-planning algorithm
(ClosurePathBuilder).

* Estimated curve durations can be off significantly, leaving generated paths
'unfinished'. The estimated duration of a path is computed when the list of
waypoint positions and speeds are created. However, once these simple paths are
converted to splines, the actual time required to reach the intended
destination is unknown. This problem is exacerbated with each application of a
CurveModifier.

* Currently the only povray scripts being generated describe the camera paths.
For convenience, additional scripts for linking to a model and actually
rendering the povray images should to be generated.
