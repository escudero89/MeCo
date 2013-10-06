function display (arista)

	tag = arista.tag;

	fprintf('Arista con la etiqueta: %d\n', tag);
	fprintf('P1 : '); display(arista.p1);
	fprintf('P2 : '); display(arista.p2);
	fprintf('Normal : '); display(arista.normal);

endfunction