#!/bin/bash
#
# students must NOT change this file in any way!!!
PATH=/bin:/usr/bin
TEST=$0

# which commands to use
PLATFORM=`uname`
if [[ ${PLATFORM} == "Darwin" ]]; then
    COMMAND="'lsof -p \$\$ | awk \"/CHR/{print \\\$4}\"'"
    OUTPUT=$'1u\n2u'
elif [[ ${PLATFORM} == "Linux" ]]; then
    COMMAND="'ls /proc/\$\$/fd'"
    OUTPUT='0  1  2  3'
else
    echo "Don't know how to check this on your platform: $PLATFORM" 1>&2
    exit 666
fi    
# echo "Running for platform ${PLATFORM}"

# this is the input lines to use
cat > $0.input << END
echo STARTING

echo "File closing test"

echo "Open a bunch of empty files"

cat < /dev/null > /dev/null 2> /dev/null
cat < /dev/null > /dev/null 2> /dev/null
cat < /dev/null > /dev/null 2> /dev/null
cat < /dev/null > /dev/null 2> /dev/null
cat < /dev/null > /dev/null 2> /dev/null

echo "Make sure you're not leaving files open"
/bin/bash -c ${COMMAND}

END

# this is the correct output
# this is the output they should create
cat > $TEST.correct << END
STARTING
File closing test
Open a bunch of empty files
Make sure you're not leaving files open
${OUTPUT}
END

# don't change anything else
echo "export PS1=''; ./bash < $0.input; exit" | script -q > /dev/null 2>&1
sed 's/\r//g' typescript | grep STARTING -A 100000 | awk '/exit/{exit} {print}' > $TEST.myoutput


if cmp -s $TEST.correct $TEST.myoutput; then
    echo "PASSES"; exit 0
else
    echo "FAILS"; 
    echo '==== output differences: < means the CORRECT output, > means YOUR output'
    diff $TEST.correct $TEST.myoutput
    exit 99
fi
