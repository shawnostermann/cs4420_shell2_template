#
# Sample lex/yacc Makefile
# Shawn Ostermann - Mar 23, 2022
#
CFLAGS = -g -Wall -Werror -O2 -g
CC = gcc

PROGRAM = bash
CFILES = bash.c variables.c
HFILE = bash.h


##################################################
#
# You shouldn't need to change anything else
#
##################################################


# compute the OFILES
OFILES = ${CFILES:.c=.o}

# all of the .o files that the program needs
OBJECTS = y.tab.o lex.yy.o ${OFILES}


# How to make the whole program
${PROGRAM} : ${OBJECTS}
	${CC} ${CFLAGS} ${OBJECTS} -o ${PROGRAM}


# 
# Turn the parser.y file into y.tab.c using "yacc"
# 
# Also, yacc generates a header file called "y.tab.h" which lex needs
# It's almost always the same, so we'll have lex use a different
# file and just update it when y.tab.h changes (to save compiles)
#
y.tab.c : parser.y ${HFILES}
	yacc -dvt ${YFLAGS} parser.y
y.tab.o: y.tab.c
	${CC} -g -c y.tab.c
y.tab.h: y.tab.c
parser.h: y.tab.h
	cmp -s y.tab.h parser.h || cp y.tab.h parser.h

# 
#  Turn the scanner.l file into lex.yy.c using "lex"
# 
lex.yy.c : scanner.l parser.h ${HFILE}
	lex ${LFLAGS} scanner.l
lex.yy.o: lex.yy.c
	${CC} -Wall -Werror -Wno-unused-function -g -c lex.yy.c

#
# File dependencies
#
${OFILES}: ${HFILE} parser.h

test: bash
	-chmod a+rx ./test.?
	-for TEST in ./test.?; do echo "$$TEST: "; $$TEST; done
	
clean: cleanbuild cleantest


cleantest:
	/bin/rm -f *.o lex.yy.c y.output parser.tab.c ${PROGRAM} parser.h parser.output *.tab.c *.tab.h core 

cleanbuild:
	/bin/rm -f test.*.myoutput test.*.correct test.*.input test.*.unixoutput tmp.* typescript
	/bin/rm -rf tmpdir.dir
	