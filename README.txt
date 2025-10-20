# Proyecto: Secuencia de Fibonacci en Ensamblador y C

## Instrucciones

1. Instala MASM32 en C:\masm32\
2. Agrega MASM al PATH:
   set PATH=%PATH%;C:\masm32\bin
3. Ejecuta build.bat para compilar y ejecutar el programa ASM.
4. Usa DOSBox si el ejecutable no corre en tu Windows (16 bits).

## Versión en C
Compílala con:
gcc fibonacci.c -o fibonacci
./fibonacci

## Comparación
Ambos programas generan la secuencia de Fibonacci, pero en ASM se usan registros y direcciones, mientras que en C se usan índices de arrays.
