all: basm

./bin/c/bison.tab.c ./bin/c/bison.tab.h: src/bison.y
	bison -Wcounterexamples -d -b ./bin/c/bison src/bison.y

./bin/c/lex.yy.c: src/flex.l ./bin/c/bison.tab.h
	flex  -o ./bin/c/lex.yy.c src/flex.l

basm: ./bin/c/lex.yy.c ./bin/c/bison.tab.c ./bin/c/bison.tab.h
	gcc ./bin/c/bison.tab.c ./bin/c/lex.yy.c -o ./bin/basm

test_asm: all
	./bin/basm -f ./example/loop.basm > ./example/loop.asm
	nasm -f win64 ./example/loop.asm
	gcc ./example/loop.obj -o ./example/loop.exe
	./example/loop.exe

test_c: all
	./bin/basm ./example/loop.basm > ./example/loop.c
	gcc ./example/loop.c -o ./example/loop.exe
	./example/loop.exe