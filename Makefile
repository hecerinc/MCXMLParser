# this is a random commment

LIBS = -lfl

all: test

test: ext.tab.h ext.tab.c test.c
	gcc -std=c99 test.c ext.tab.c -o test $(LIBS)

ext.tab.h: ext.y
	bison -d ext.y

test.c: test.l
	flex -t test.l >test.c

clean:
	@rm test.c test ext.tab.*
