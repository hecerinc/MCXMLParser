# this is a random commment

LIBS = -lfl
CFLAGS=-std=gnu99
all: test

test: ext.tab.h ext.tab.c test.c
	gcc $(CFLAGS) test.c ext.tab.c -o test $(LIBS)


ext.tab.h: ext.y
	bison -d ext.y

test.c: test.l
	flex -t test.l >test.c

clean:
	@rm test.c test ext.tab.*
