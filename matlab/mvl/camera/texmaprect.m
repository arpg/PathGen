% texmaprect( P, N, M, TEX, IMG, ZBUF, HPOSE, CMOD );
%
% Projects a texture TEX mapped onto a rectangle at P into a camera at POSE.
% P+N defines the top right of the rectangle, P+M the bottom left, and P+N+M the
% bottom right.  The vectors N and M must therefore be perpendicular.
%
% TODO: TEXMAPRECT( P, N, M, TEX, IM, ZBUF, CMOD ) with non-linear camera models
% TODO: TEXMATRI( T, TEXELS, TEX, IM, CMOD ) same but with triangles.
%
