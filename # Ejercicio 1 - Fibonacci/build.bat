@echo off
echo Compilando Fibonacci en ensamblador con MASM...
ml fibonacci.asm
link16 fibonacci.obj
echo Ejecutando programa...
fibonacci.exe
pause
