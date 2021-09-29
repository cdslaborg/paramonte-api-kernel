#!/bin/bash
gfortran -O3 -ffree-line-length-none -Wl,-rpath,../../../../lib -I../../../../include main.f90 ../../../../lib/libparamonte_fortran_*_gnu_*.so -o main.exe
./main.exe