#!/bin/bash

# Author: Filip Jorissen
# Copyright: KU Leuven and Builtwins bv


# Run this script to compile the integer solver

# Compile binaries to .o file
g++ -fPIC -c IntegerSolver.cc callIntegerSolver.cpp -rdynamic -std=c++11 -g  -ldl
# Transform .o file in shared library file
if [ $(arch) != arm64 ] ; then
	ext=so
else
	ext=dylib
fi
g++ -shared -o libIntegerSolver.$ext IntegerSolver.o callIntegerSolver.o -lc -std=c++11
# copy the resulting shared library file in the folder where you run 'make package'
# the make script will then copy the custom shared library file and overwrite the default file 
