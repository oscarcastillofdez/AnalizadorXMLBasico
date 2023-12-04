FUENTE = practica2
PRUEBA = pruebas/practica2

all: compile run

compile:
	flex $(FUENTE).l
	bison -o $(FUENTE).tab.c $(FUENTE).y -yd
	gcc -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -lfl -ly
run:
	./$(FUENTE) < $(PRUEBA).xml
	
run2: 
	./$(FUENTE) $(PRUEBA).xml

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h

runPruebas: runP1 runP2 runP3 runP4 runP5

runP1: 
	./$(FUENTE) < $(PRUEBA)_prueba1.xml

runP2: 
	./$(FUENTE) < $(PRUEBA)_prueba2.xml

runP3: 
	./$(FUENTE) < $(PRUEBA)_prueba3.xml

runP4: 
	./$(FUENTE) < $(PRUEBA)_prueba4.xml

runP5: 
	./$(FUENTE) < $(PRUEBA)_prueba5.xml
