#! /bin/Bash
export OBJ1=$(ls *.c)
export OBJ2=$(ls *.h)
#
test1=${OBJ1/./}
test=${test1/%c/}
########################
#echo $OBJ1 $OBJ2 $test 
autoscan
#configure.scan chage name to configure.in
TMP_file=$(ls *.scan)
cat > $TMP_file << 'HERE'
#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.63)
AC_INIT(FULL-PACKAGE-NAME, VERSION, BUG-REPORT-ADDRESS)
AM_INIT_AUTOMAKE(main,1,0)
AC_CONFIG_SRCDIR([$OBJ1])
#AM_CONFIG_HEADER([config.h])

# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.
AC_OUTPUT(Makefile)
HERE
mv configure.scan configure.in
#################################
aclocal
autoconf
autoheader
#creat Makefile.am
touch Makefile.am
echo AUTOMAKE_OPTIONS=foreign >Makefile.am
echo bin_PROGRAMS=$test>> Makefile.am
tt="($test)_SOURCES"
yy=${tt/\(/ }
uu=${yy/\)/}
echo $uu
echo $uu= $OBJ1 $OBJ2>> Makefile.am
#################################
automake --add-missing
automake
./configure
make
make dist
rm ./*.o
rm ./auto_tools.sh
arm-linux-gcc $OBJ1 -o arm.bin
