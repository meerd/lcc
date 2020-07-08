#!/bin/bash

WORKDIR=$(pwd)/objdir

if [ "$1" != "SKIP_BUILD" ]; then
	CFLAGS="-g -m32 -DLCCDIR=\\\"${WORKDIR}/\\\""
	LDFLAGS="-g -m32"

	CFLAGS=${CFLAGS} LDFLAGS=${LDFLAGS} make BUILDDIR=${WORKDIR} HOSTFILE=etc/linux.c clean all
fi

RETCODE=224
MESSAGE="Hello cruel world!"
CCODE=("int printf(const char *, ...);\nint main(void)\n{\n    " "printf(\"${MESSAGE}\\n\");" "\n    return ${RETCODE};\n}\n")

TEST_TARGET="/tmp/testapp"
TEST_CFLAGS=-I/usr/lib/gcc/x86_64-linux-gnu/7/include/
TEST_LDFLAGS=-L/usr/lib/gcc/x86_64-linux-gnu/7/32 

printf "${CCODE[0]}" >  ${WORKDIR}/test.c
echo   "${CCODE[1]}" >> ${WORKDIR}/test.c
printf "${CCODE[2]}" >> ${WORKDIR}/test.c

${WORKDIR}/lcc ${WORKDIR}/test.c ${TEST_CFLAGS} ${TEST_LDFLAGS} -o ${TEST_TARGET}
${TEST_TARGET}
RESULT=$?

if [ ${RESULT} -ne "${RETCODE}" ]; then
	echo "Failure! Expected ${RETCODE}, but got ${RESULT}!"
else
	echo "Success!"
fi
