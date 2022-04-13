#!/bin/bash
cd bin/
make clean
cd ../
cmake -S . -B bin
cd bin
make
cd ../
cat program/program$1 | bin/Compiler
