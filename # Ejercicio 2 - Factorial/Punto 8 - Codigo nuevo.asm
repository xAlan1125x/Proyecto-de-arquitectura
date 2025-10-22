; Factorial function in Turbo Assembler
.MODEL small
.STACK 100h

.DATA
    num dw 5        ; Number to calculate factorial for
    result dq ?     ; Result will be stored here (64-bit to handle larger factorials)

.CODE
main PROC
    mov ax, @data   ; Initialize data segment
    mov ds, ax

    ; Call the factorial function
    mov ax, num
    call factorial

    ; Store the result
    mov word ptr result, ax
    mov word ptr result + 2, dx

    ; Exit program (MS-DOS)
    mov ax, 4c00h
    int 21h
main ENDP

; Factorial function
; Input: AX (number n)
; Output: DX:AX (factorial result)
factorial PROC
    push bp
    mov bp, sp

    mov dx, 0       ; Initialize result (high word) to 0
    mov ax, 1       ; Initialize result (low word) to 1

    cmp word ptr [bp+4], 2 ; Check if n < 2
    jl factorial_end

    mov cx, word ptr [bp+4] ; Loop counter = n
    mov bx, 2       ; Start from 2

factorial_loop:
    mul bx          ; AX = AX * BX (result * i)
    push dx         ; Save DX (high word of result)
    mov dx, 0       ; Clear DX for next multiplication
    mov ax, bx      ; AX = BX (i)
    inc ax          ; AX = i + 1
    mov bx, ax      ; BX = i + 1
    pop dx          ; Restore DX

    loop factorial_loop

factorial_end:
    pop bp
    ret 2           ; Return and pop the argument
factorial ENDP

END main