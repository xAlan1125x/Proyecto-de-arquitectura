.MODEL SMALL
.STACK 100h
.DATA
    fib     DW 10 DUP(?)  ; Array para 10 números Fibonacci
    msg     DB 'Fibonacci: $'
.CODE
START:
    MOV AX, @DATA
    MOV DS, AX
    
    ; Inicializar primeros dos números
    MOV WORD PTR [fib], 0
    MOV WORD PTR [fib+2], 1
    
    ; Calcular secuencia
    MOV CX, 8
    MOV SI, 4
FIB_LOOP:
    MOV AX, [fib+SI-4]    ; Direccionamiento indexado
    ADD AX, [fib+SI-2]
    MOV [fib+SI], AX
    ADD SI, 2
    LOOP FIB_LOOP
    
    ; Mostrar resultados
    MOV AH, 09h
    LEA DX, msg
    INT 21h
    
    MOV CX, 10
    MOV SI, 0
DISPLAY:
    ; Conversión a ASCII y display
    MOV AX, [fib+SI]
    CALL PRINT_NUMBER
    ADD SI, 2
    LOOP DISPLAY
    
    MOV AH, 4Ch
    INT 21h

PRINT_NUMBER PROC
    ; Implementar conversión número a ASCII
    RET
PRINT_NUMBER ENDP

END START
