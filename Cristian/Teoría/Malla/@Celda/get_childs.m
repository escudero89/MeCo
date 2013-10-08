function hijos = get_childs(C, j = 0)

	if (j == 0)
		hijos = C.hijos;
	else
		hijos = C.hijos{j};
	end

	return;
endfunction