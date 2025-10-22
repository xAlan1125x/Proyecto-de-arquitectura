.MODEL SMALL          ; Modelo de memoria SMALL (uno o pocos segmentos, t?pico en DOS)
.STACK 100h           ; Reservar 256 bytes para la pila (100h = 256)

.DATA                 ; Inicio del segmento de datos
    num     DW 5                 ; Variable 'num' (word 16 bits) inicializada a 5
    result  DW ?                 ; Variable 'result' (word 16 bits) sin inicializar para guardar resultado
    msg     DB 'Factorial = $'   ; Cadena a mostrar antes del n?mero; '$' es terminador para INT 21h AH=09h
    buffer  DB 6 DUP(0), '$'     ; Buffer de 6 bytes inicializados a 0 + '$' terminador (espacio para d?gitos)

.CODE                 ; Inicio del segmento de c?digo
START:                ; Etiqueta de entrada del programa

    MOV AX, DGROUP       ; Cargar en AX el selector del grupo de datos por defecto (DGROUP)
    MOV DS, AX           ; Mover AX a DS para que las referencias a variables en .DATA funcionen

    ; --- Calcular factorial iterativo ---
    MOV AX, 1            ; Inicializar AX = 1, ser? el acumulador del producto
    MOV CX, [num]        ; Cargar en CX el valor de 'num' desde memoria (contador para el bucle)
    CMP CX, 0            ; Comparar CX con 0 para ver si num == 0
    JE FACT_DONE         ; Si CX == 0, saltar a FACT_DONE (0! = 1)

FACT_LOOP:              ; Etiqueta del inicio del bucle de factorial
    MUL CX               ; Multiplicar AX por CX; resultado 32-bit en DX:AX
    LOOP FACT_LOOP       ; Decrementa CX y salta a FACT_LOOP si CX != 0

FACT_DONE:              ; Etiqueta cuando el c?lculo termin?
    MOV [result], AX     ; Guardar la parte baja del resultado (AX) en la variable 'result'

    ; --- Mostrar mensaje ---
    LEA DX, msg          ; Cargar en DX la direcci?n de la cadena 'msg'
    MOV AH, 09h          ; AH = 09h, servicio DOS INT 21h para imprimir cadena terminada en '$'
    INT 21h              ; Llamar a la interrupci?n 21h para mostrar "Factorial = "

    ; --- Preparar conversi?n a ASCII ---
    MOV AX, [result]     ; Cargar AX con el valor guardado en 'result' (valor a convertir)
    MOV BX, 10           ; Poner 10 en BX para usarlo como divisor decimal
    LEA DI, buffer + 5   ; Cargar en DI la direcci?n del ?ltimo byte ?til del buffer (antes del '$')
    MOV CX, 0            ; Inicializar contador de d?gitos en 0

    ; Si el n?mero es 0, escribir '0' expl?citamente
    CMP AX, 0            ; Comparar AX con 0
    JNE .conv_loop_zero_check ; Si AX != 0, saltar al bucle de conversi?n normal
    MOV BYTE PTR [DI], '0' ; Escribir el car?cter '0' en la posici?n apuntada por DI
    DEC DI               ; Retroceder DI para dejar el primer d?gito en su lugar
    INC CX               ; Incrementar contador de d?gitos
    JMP .conv_done       ; Saltar a la etiqueta de fin de conversi?n

.conv_loop_zero_check:  ; Etiqueta de entrada al bucle de conversi?n cuando AX != 0
.conv_loop:             ; Bucle para convertir n?mero en ASCII (extrae d?gitos)
    XOR DX, DX           ; Poner DX = 0 antes de DIV porque DIV usa DX:AX como dividendo
    DIV BX               ; Dividir DX:AX entre BX (10): cociente->AX, resto->DX
    ADD DL, '0'          ; Convertir el resto (DL) en car?cter ASCII sumando '0'
    MOV [DI], DL         ; Guardar el d?gito ASCII en el buffer en la posici?n DI
    DEC DI               ; Mover DI una posici?n hacia la izquierda para el siguiente d?gito
    INC CX               ; Incrementar contador de d?gitos
    CMP AX, 0            ; Comprobar si quedan m?s d?gitos (AX es el cociente)
    JNZ .conv_loop       ; Si AX != 0, repetir el bucle

.conv_done:             ; Etiqueta tras completar la conversi?n
    INC DI               ; Avanzar DI al primer d?gito v?lido almacenado en el buffer
    LEA DX, [DI]         ; Cargar en DX la direcci?n del primer d?gito a imprimir
    MOV AH, 09h          ; AH = 09h, servicio DOS para imprimir cadena terminada en '$'
    INT 21h              ; Llamar a la interrupci?n 21h para imprimir el n?mero

    ; Finalizar programa
    MOV AH, 4Ch          ; AH = 4Ch, servicio DOS para terminar programa y devolver control al DOS
    INT 21h              ; Llamar a la interrupci?n 21h para terminar

END START               ; Fin del m?dulo y definici?n del punto de entrada START
