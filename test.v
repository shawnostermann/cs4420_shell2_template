#!/bin/bash
#
# students must NOT change this file in any way!!!
PATH=/bin:/usr/bin
TEST=$0

# this is the input lines to use
cat > $0.input << 'END'
echo STARTING

echo "OK, let's make a really long string to test variable expansion and substitution"

V1="x"
V2="($V1*$V1)"
V1="(${V2}+${V2}+${V2})"
V2="($V1*$V1)"
V1="(${V2}+${V2}+${V2})"
V2="($V1*$V1)"
V1="(${V2}+${V2}+${V2})"
V2="($V1*$V1)"
V1="(${V2}+${V2}+${V2})"
V2="($V1*$V1)"
V1="(${V2}+${V2}+${V2})"
V2="($V1*$V1)"

echo "the next line should say '1 1 55986'"
/bin/echo $V2 | wc | awk '{printf("%s %s %s\n", $1, $2, $3);}'
/bin/echo "the next line should say '3501 3499 15942'"
/bin/echo $V2 | od -c | sed 's/[^(]//g' | wc | awk '{printf("%s %s %s\n", $1, $2, $3);}'
/bin/echo "the next line should say '3501 3500 15942'"
/bin/echo $V2 | od -c | sed 's/[^)]//g' | wc | awk '{printf("%s %s %s\n", $1, $2, $3);}'
/bin/echo "the next line should say '3501 3498 19053'"
/bin/echo $V2 | od -c | sed 's/[^x]//g' | wc| awk '{printf("%s %s %s\n", $1, $2, $3);}'
END

# this is the correct output
# this is the output they should create
cat > $TEST.correct << 'END'
OK, let's make a really long string to test variable expansion and substitution
the next line should say '1 1 55986'
1 1 55986
the next line should say '3501 3499 15942'
3501 3499 15942
the next line should say '3501 3500 15942'
3501 3500 15942
the next line should say '3501 3498 19053'
3501 3498 19053
END

# don't change anything else
echo "export PS1=''; ./bash < $0.input; exit" | script -q > /dev/null 2>&1
sed 's/\r//g' typescript | grep STARTING -A 100000 | grep -v STARTING | awk '/exit/{exit} {print}' | grep  -v '^Script done' | egrep -v '^$' > $TEST.myoutput


if cmp -s $TEST.correct $TEST.myoutput; then
    echo "PASSES"; exit 0
else
    echo "FAILS"; 
    echo '==== output differences: < means the CORRECT output, > means YOUR output'
    diff $TEST.correct $TEST.myoutput
    exit 99
fi
