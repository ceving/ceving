armref.txt: misc/armref.pdf
	ps2ascii $^ |\
	grep ' cond ' |\
	tr -cd '[:print:]\n' |\
	sed 's/ [ ]\+/ /g' > $@
