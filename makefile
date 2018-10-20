upa:	upa.y upa.l struct.h upa.tab.h entrada
	bison -d upa.y
	flex upa.l
	gcc upa.tab.c lex.yy.c -lfl -o upa
	./upa < entrada > saida.cpp
	sed -i '8d' saida.cpp
	echo "\n\nreturn 0;\n}" >> saida.cpp
	gedit saida.cpp
	g++ -o programa saida.cpp
	./programa
