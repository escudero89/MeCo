% El idx refiere que punto retorna (1 => P1, 2 => P2, 3 => N, 4 => tag)
function p = get_args(a, idx)

	switch idx
		case {1}
			p = a.p1;
		case {2}
			p = a.p2;
		case {3}
			p = a.n;
		case {4}
			p = a.tag;

		otherwise
			error ('arista::get_points () : no esta definido el idx para ese valor');
	end

endfunction