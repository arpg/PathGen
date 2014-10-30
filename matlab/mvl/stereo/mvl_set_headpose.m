% [lcmod,rcmod] = mvl_set_headpose( lcmod, rcmod, lcenter, pointing, right, up )
%   takes a camera pair and moves them s.t. the left camera is centered at 'at', 
%   looking along 'pointing' vecotr, with 'right' to the right and 'up' up.

function [lcmod,rcmod] = mvl_set_headpose( lcmod, rcmod, lcenter, pointing, right, up )

	warning('mvl_set_headpose is untested\n')

	[tlw,Rlw] = dcm_inverse_op( lcmod.t, lcmod.R ); % invert l cam pose
	[tlr,Rlr] = dcm_compound_op( tlw, Rlw, rcmod.t, rcmod.R );

   	lcmod.t = lcenter;
	lcmod.R = [ pointing right up ]; % new left cam orientation in world cf

    [rcmod.t,rcmod.R] = dcm_compound_op( lcmod.t, lcmod.R, tlr, Rlr );

