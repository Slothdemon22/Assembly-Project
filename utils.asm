printBitBoxesNumbers:
    push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
    mov bx, bitboxesnum
    mov di, 0
    mov cx, 2
    mov ax, 506         ; x
    mov dx, 164         ; y
    mov si, 0
    jmp print_boxes_numbers

next_row_num:
    mov ax, 500
    add dx, 70
    mov cx, 2

print_boxes_numbers:
    push word 1
    push word [bx+di]
    add di, 2
    push 24             ; Dimensions
    push ax             ; x
    push dx             ; y
    add ax, 60
    call functionGnericBitmaps
    loop print_boxes_numbers

    inc si
    cmp si, 4
    jnz next_row_num

    push word 1
    push word [bx+16]
    push 24
    push 536
    push 424
    call functionGnericBitmaps
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
	ret

printGameOverMessagesScreen:
    
	
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	
	push 240         ; Height
    push 360        ; Width
    push 120          ; Y start
    push 120         ; X start
    push 15         ; Color (white)
    call clr_screenGeneric
	push word 1      ; Color
    push word 120    ; Starting X
    push word 480    ; Ending X
    push 120          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 120    ; Starting X
    push word 480    ; Ending X
    push 120-2          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 120    ; Starting X
    push word 480    ; Ending X
    push 120-1          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 120    ; Starting X
    push word 480    ; Ending X
    push 120+239         ; Current Y-coordinate
    call print_horizontal
    push word 1      ; Color
    push word 120    ; Starting X
    push word 480    ; Ending X
    push 120+238         ; Current Y-coordinate
    call print_horizontal
    push word 1      ; Color
    push word 120    ; Starting X
    push word 480    ; Ending X
    push 120+240         ; Current Y-coordinate
    call print_horizontal
	push 1
	push 120          ; Current X-coordinate
    push word 120      ; Starting Y
    push word 350+10     ; Ending Y
    call print_vertical
	push 1
	push 120-1          ; Current X-coordinate
    push word 119      ; Starting Y
    push word 350+10     ; Ending Y
    call print_vertical
	push 1
	push 120+1          ; Current X-coordinate
    push word 119      ; Starting Y
    push word 350+10     ; Ending Y
    call print_vertical
	push 1
	push 120+360          ; Current X-coordinate
    push word 119      ; Starting Y
    push word 350+10     ; Ending Y
    call print_vertical
	push 1
	push 120+360+1          ; Current X-coordinate
    push word 119      ; Starting Y
    push word 350+10     ; Ending Y
    call print_vertical
	push 1
	push 120+360-1          ; Current X-coordinate
    push word 119      ; Starting Y
    push word 350+10     ; Ending Y
    call print_vertical
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
printInstructionScreen:
    push bp
	pusha
	
	push word 1      ; Color
    push word 190    ; Starting X
    push word 420    ; Ending X
    push 145          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 190    ; Starting X
    push word 420    ; Ending X
    push 145+1          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 190    ; Starting X
    push word 420    ; Ending X
    push 145 -1         ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 190    ; Starting X
    push word 420    ; Ending X
    push 145+140          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 190    ; Starting X
    push word 420    ; Ending X
    push 145+140+1          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 190    ; Starting X
    push word 420    ; Ending X
    push 145+140 -1         ; Current Y-coordinate
    call print_horizontal
	push 1
	push 190         ; Current X-coordinate
    push word 145      ; Starting Y
    push word 285     ; Ending Y
    call print_vertical
	push word 1      ; Color
    push word 190    ; Starting X
    push word 420    ; Ending X
    push 145+55          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 190    ; Starting X
    push word 420    ; Ending X
    push 145+55+1          ; Current Y-coordinate
    call print_horizontal
	push 1
	push 190-1         ; Current X-coordinate
    push word 145      ; Starting Y
    push word 285     ; Ending Y
    call print_vertical
	push 1
	push 190 +1       ; Current X-coordinate
    push word 145      ; Starting Y
    push word 285     ; Ending Y
    call print_vertical
	push 1
	push 190+230         ; Current X-coordinate
    push word 145      ; Starting Y
    push word 285     ; Ending Y
    call print_vertical
	push 1
	push 190+230 -1        ; Current X-coordinate
    push word 145      ; Starting Y
    push word 285     ; Ending Y
    call print_vertical
	push 1
	push 190+230 +1        ; Current X-coordinate
    push word 145      ; Starting Y
    push word 285     ; Ending Y
    call print_vertical
	push stringEasy
	push stringEasyLen
	push 14
	push 32
	call print_char
	push stringMedium
	push stringMediumLen
	push 15
	push 32
	call print_char
	push stringHard
	push stringHardLen
	push 16 
	push 32
	call print_char
		mov si,0
    mov bx,sudoku_array
    mov ax,220;x
    mov dx,160;y
    mov cx,6
	.print_sudoku:
    push word 1
    push word [bx+si]
    push 32  ; bitmaps dim
    add si,2
    push ax ;x
    add ax,25+3
    push dx ; y
    call functionGnericBitmaps
	call delay
	call delay
	call delay

	
   loop .print_sudoku	
    call SuperDelay	
	call SuperDelay
    push instruction
	push instructionLen
	push 20
	push 32
	call print_char
	call delay
	call delay
	push instructionHint
	push instructionHintLen
	push 22
	push 30
	call print_char
	call delay
	call delay
	push instructionNotes
	push instructionNotesLen
	push 23
	push 26
	call print_char
	call delay
	call delay
	push instructionUndo
	push instructionUndoLen
	push 24
	push 23
	call print_char
	
	
	popa
	pop bp
	ret
printScreenStartUtil:
   	call SuperDelay
	call StartScreenPrint
    call SuperDelay	
	push Startgame
    push StartLen
    push 25
    push 22
    call print_char

	call printPen
	mov si,0
    mov bx,sudoku_array
    mov ax,190+22;x
    mov dx,300-10;y
    mov cx,6
print_sudoku:
    push word 1
    push word [bx+si]
    push 32  ; bitmaps dim
    add si,2
    push ax ;x
    add ax,25+3
    push dx ; y
    call functionGnericBitmaps
	call delay
	call delay
	call delay

	
    loop print_sudoku
	ret
	StartSuduko:
    call SuperDelay
	call SuperDelay
	call SuperDelay
    push word [StartSudokuColor]
	push p1
	push 32
	push 240
	push 160
	call functionGnericBitmaps
    call SuperDelay

   

    push word [StartSudokuColor]
	push p4
	push 32
	push 240
	push 160+32
	call functionGnericBitmaps
	push word [StartSudokuColor]
	push p5
	push 32
	push 240+32
	push 160+32
	call functionGnericBitmaps
    call SuperDelay
	push word [StartSudokuColor]
	push p3
	push 32
	push 240+32+31
	push 160
	call functionGnericBitmaps

	push word [StartSudokuColor]
	push p6
	push 32
	push 240+32+31
	push 160+32
	call functionGnericBitmaps
	push word [StartSudokuColor]
	push p7
	push 32
	push 240
	push 160+32+32
	call functionGnericBitmaps
    call SuperDelay

    call SuperDelay


	push word [StartSudokuColor]
	push p8
	push 32
	push 240+32
	push 160+32+32
	call functionGnericBitmaps
	push word [StartSudokuColor]
	push p9
	push 32
	push 240+32+31
	push 160+32+32
	call functionGnericBitmaps
    call SuperDelay
	push word [StartSudokuColor]
	push p2
	push 32
	push 240+32
	push 160
	call functionGnericBitmaps
	ret	
	
	
printPen:
     push word [StartSudokuColor]
	 push pen1
	 push 32
	 push 340
	 push 160
	 call functionGnericBitmaps
     call SuperDelay

	 push word [StartSudokuColor]
	 push pen2
     push 32
	 push 340
	 push 160+32
     call functionGnericBitmaps
     call SuperDelay

	 push word [StartSudokuColor]
	 push pen3
	 push 32
	 push 340
	 push 160+32+32
	 call functionGnericBitmaps
	ret
	
	
printTextOnMainGridScreenUtil:
    
	    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push dx
    push di
	
	
	    ; This part prints initial counter for mistakes
    push word [MistakesCounter]
    push word 1
    push word 16
    push word 0
    call PrintTeleTypeOutput

    push mistakes
    push mistakesLen
    push 0
    push 17
    call print_char

    mov ax, [Score]     ; Load Score into AX
    push 1              ; Color (white)
    push 72             ; x coordinate
    push 0              ; y coordinate
    push ax             ; Number to print
    call PrintNumberUtil

    ; This function prints Sudoku inside the rectangle below
    mov si, 0
    mov bx, sudoku_array
    mov ax, 185         ; x
    mov dx, 438         ; y
    mov cx, 6

print_sudoku1:
    push word 1
    push word [bx+si]
    push 32             ; Bitmap dimensions
    add si, 2
    push ax             ; x
    add ax, 25
    push dx             ; y
    call functionGnericBitmaps
    loop print_sudoku1

    ; End of this part

    ; This function uses address bitmapsDimension, x, and y coordinates to draw erase undo pencil 32x32 bitmaps
    mov bx, bitboxesarray
    mov ax, 15          ; x
    mov dx, 30          ; y
    mov cx, 4
    mov si, 0
    pop di
    pop dx
    pop cx
    pop ax
    pop bx
    mov sp, bp                
    pop bp
    ret


PrintNumberUtil:
    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push dx
    push di
    
    mov ax, [bp+4]    ; Number to convert
    mov dh, [bp+6]    ; Row (y coordinate)
    mov dl, [bp+8]    ; Column (x coordinate)
    
    mov bx, 10        ; Base 10
    mov cx, 0         ; Digit count
    
    ; Convert number to stack in reverse order
ConvertLoop:
    mov dx, 0         ; Zero upper half for division
    div bx            ; Divide by 10
    add dl, '0'       ; Convert remainder to ASCII
    push dx           ; Save digit on stack
    inc cx            ; Count digits
    cmp ax, 0         ; Check if quotient is zero
    jnz ConvertLoop   ; Continue if not
    
    ; Restore coordinates
    mov dh, [bp+6]    ; Row (y coordinate)
    mov dl, [bp+8]    ; Column (x coordinate)
    mov bl, [bp+10]   ; Color parameter
    
    ; Print digits
PrintLoop:
    mov ah, 02h       ; Set cursor position
    mov bh, 0         ; Page number
    int 10h
    
    pop ax            ; Retrieve digit
    mov ah, 0x0E      ; Teletype output
    int 10h           ; Print character
    
    inc dl            ; Move to next column
    loop PrintLoop    ; Continue until all digits printed
    
    pop di
    pop dx
    pop cx
    pop ax
    pop bx
    mov sp, bp                
    pop bp
    ret 8           ; Clean up 6 bytes from stack
    
	
	
	
	



debuggerInput:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx


mov ah, 02h
    mov bh, 0                  ; Page 0
    mov dh, [bp+6]            ; Row position from parameter
    mov dl, [bp+4]            ; Column position from parameter
    int 10h
   
    ; Print rowCount
    mov ah, 0Eh               ; Teletype output
    mov al, [bp+8]
    add al, '0'              ; Convert to ASCII
    mov bh, 0                ; Page 0
    mov bl, 1h              ; Color (white)
    int 10h

pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 6

 backGroundPrintingUtil:
  MOV AL, 0
  MOV DX, 0x3C8
  OUT DX, AL

  MOV DX, 0x3C9

  MOV AL, 63   ;red
  OUT DX, AL
  MOV AL,63     ;green
  OUT DX, AL
  MOV AL, 63    ;blue
  OUT DX, AL

  MOV AL, 0
  OUT DX, AL
  MOV AL, 0
  OUT DX, AL
  MOV AL,0
  OUT DX,AL
  ret
  
   
clr_box_Util:
    ;push 1
    push clr_box
    push 32
    push word [cs:rowOffset]
    push word [cs:colOffset]
	call clearCursor
	 ret 
	
draw_Bitmap_Util:
    push word 1
    push bitboxes4
    push 32
    push word [cs:rowOffset]
    push word [cs:colOffset]
    call functionGnericBitmaps
	
	ret
	
	
clr_cursor_Util:
    push bitboxes4
    push 32
    push word [cs:rowOffset]
    push word [cs:colOffset]
    call clearCursor
	
	ret
	
	
delay:
    push cx
    mov cx, 0xffff
l1: loop l1
    pop cx
    ret
SuperDelay:
    push bp
	mov bp,sp
	call delay
	call delay
	call delay
	call delay
	call delay
	pop bp
	ret
play_tone:
    ; Load the frequency value into counter 2
    mov al, 0b6h
    out 43h, al       ; Send control word to PIT
    out 42h, al       ; Send low byte of frequency
    mov al, ah
    out 42h, al       ; Send high byte of frequency

    ; Turn the speaker on
    in al, 61h        ; Read current value from port 61h
    mov ah, al        ; Backup the original value
    or al, 3h         ; Set bits 0 and 1 to enable speaker
    out 61h, al       ; Write back to port 61h

    call delay        ; Call delay for the tone duration

    ; Turn the speaker off
    mov al, ah        ; Restore original value of port 61h
    out 61h, al       ; Write back to port 61h

    ret               ; Return from subroutine
printYouBitmapUtil: 
   
	mov si,0
    mov bx,YouArray
    mov ax,180;x
    mov dx,160;y
    mov cx,3
print_You:
    push word 1
    push word [bx+si]
    push 32  ; bitmaps dim
    add si,2
    push ax ;x
    add ax,25+3
    push dx ; y
    call functionGnericBitmaps
	call delay
	call delay
	call delay
	loop print_You
	ret
hookTimerAndKeyboardUtil: 
    push bp
	pusha
	
	
	mov ax, [es:9*4]
    mov [oldKeyboardIsr], ax     ; Save low 16 bits of offset
    mov ax, [es:9*4+2]
    mov [oldKeyboardIsr+2], ax   ; Save segment

    ; Save timer interrupt vector
    mov ax, [es:8*4]
    mov [oldTimerIsr], ax        ; Save low 16 bits of offset
    mov ax, [es:8*4+2]
    mov [oldTimerIsr+2], ax      ; Save segment

    ; Set new interrupt handlers
    mov word [es:9*4], kbsir     ; New keyboard interrupt handler
    mov word [es:9*4+2], cs      ; Keyboard handler code segment
    mov word [es:8*4], timer     ; New timer interrupt handler
    mov word [es:8*4+2], cs      ; Timer handler code segment
	popa
	pop bp
	ret
unhookTimerAndKeyboardUtil:
    push bp
	pusha
	
	mov ax, [oldTimerIsr]
    mov [es:8*4], ax
    mov ax, [oldTimerIsr+2]
    mov [es:8*4+2], ax
	

    ; Restore keyboard interrupt vector
    mov ax, [oldKeyboardIsr]
    mov [es:9*4], ax
    mov ax, [oldKeyboardIsr+2]
    mov [es:9*4+2], ax
	
	popa
	pop bp
	ret
WinBitmapUtil:
    push bp
    mov bp, sp
    sub sp, 2
    push si 
    push cx
    push dx 
    push ax
	call printYouBitmapUtil
	 push 1
	 push word w
	 push 32
	 push 190+32+32+32
	 push 160
	 call functionGnericBitmaps
	 push 1
	 push i
	 push 32
	 push 190+32+32+30+28
	 push 160
	 call functionGnericBitmaps
	 push 1
	 push n
	 push 32
	 push 190+32+32+32+30+28
	 push 160
	 call functionGnericBitmaps

	
	pop si  
    pop cx 
    pop dx 
    pop ax
    mov sp, bp
    pop bp
    ret
	
   
loseBitmapUtil:
    push bp
    mov bp, sp
    sub sp, 2
    push si 
    push cx
    push dx 
    push ax
	
	
	call printYouBitmapUtil
	
	
	

	 push 1
	 push l
	 push 32
	 push 190+32+32+32
	 push 160
	 call functionGnericBitmaps
	 push 1
	 push o
	 push 32
	 push 190+32+32+32+32
	 push 160
	 call functionGnericBitmaps
	 push 1
	 push s
	 push 32
	 push 190+32+32+32+32+32
	 push 160
	 call functionGnericBitmaps
	 push 1
	 push e
	 push 32
	 push 190+32+32+32+32+32+32
	 push 160
	 call functionGnericBitmaps
	 pop si  
    pop cx 
    pop dx 
    pop ax
    mov sp, bp
    pop bp
    ret
	
printEndGameMessgaesUtil:
    push bp
    mov bp, sp
    sub sp, 2
    push si 
    push cx
    push dx 
    push ax 
    	push time
	push timeLen
	push 16
	push 20
	call print_char
	mov ah, 0x02
    mov bh, 0
    mov dh, 16
    mov dl, 27
    int 0x10

    ; Display minutes
    xor ax, ax
    mov al, [minutes]
    mov bl, 10
    div bl
    
    push ax
    mov ah, 0x0E
	mov bl,0x01
    add al, '0'
    int 0x10
    
    pop ax
    mov al, ah
    mov ah, 0x0E
	mov bl,0x01
    add al, '0'
    int 0x10
    
    ; Print colon
    mov ah, 0x0E
    mov al, ':'
    int 0x10

    ; Display seconds
    xor ax, ax
    mov al, [seconds]
    mov bl, 10
    div bl
    
    push ax
    mov ah, 0x0E
    add al, '0'
	mov bl,0x01
    int 0x10
    
    pop ax
    mov al, ah
    mov ah, 0x0E
	mov bl,0x01
    add al, '0'
    int 0x10

    sti

	push message2
	push len2
	push 16
	push 40
	call print_char
	mov ax, [Score]     ; Load Score into AX
    push 1          ; Color (white)
    push 47         ; x coordinate
    push 16         ; y coordinate
    push ax              ; Number to print
    call PrintNumberUtil
	push message
	push len
	push 20
	push 30
	call print_char
	push word [MistakesCounter]
    push word 1        
    push word 40    
    push word 20      
    call PrintTeleTypeOutput
	push mistakes
	push mistakesLen
	push 20
	push 41
	call print_char



    pop si  
    pop cx 
    pop dx 
    pop ax
    mov sp, bp
    pop bp
    ret
		
printArray:
    push bp
    mov bp, sp
    sub sp, 2
    push si 
    push cx
    push dx 
    push ax
    mov si, 0

    
    
    mov cx, 4
    add cx, 70
    mov [bp - 2], cx
    mov dx, 4
    add dx, 35

    .outerloop:
        mov word[colcount1], 0
        mov cx, [bp - 2]
        .innerloop:
            xor ax,ax
            mov al, [boardArray + si]
            mov [auxarray], ax 
            cmp ax, 0
            je .skipZero
			
			
            mov ax, numbersArray
            push ax
            mov ax, 24 ;size of bitmap
            push ax
            mov ax, 0x8   ;color (0xA green)
            push ax
            mov ax, [auxarray]
            push ax  ;number
            push cx  ;x position
            push dx  ; y pos

            call printBitMap
            pop dx
            pop cx
            pop ax 
            pop ax 
            pop ax
			pop ax
			
            .skipZero:
                inc si
                cmp si, 81
                je .endi
                add cx, 45          ; Move to the next column
                add word [colcount1], 1
                cmp word [colcount1], 9
            jne .innerloop

        add dx, 45              ; Move down to the next row
        add word [rowcount1], 1
        cmp word [rowcount1], 9
        jne .outerloop
    
    .endi:
	mov word [colcount1],0
	mov word [rowcount1],0
	mov byte [bitaux],0
	
	
    pop si  
    pop cx 
    pop dx 
    pop ax
    mov sp, bp
    pop bp
    ret
	
printBitMap:
    push bp 
    mov bp, sp
    ;bp + 4 -> dx location , bp + 6 cx location, bp + 8 -> number ,bp + 10 colour, bp + 12 size of bit map, bp + 14 adress of bitmap array
    sub sp, 4

    push ax
    push bx
    push si 
    push di

    mov cx, [bp + 6]
    mov dx, [bp + 4]
    mov [bp - 2], cx
    mov [bp - 4], dx 
    mov bx, [bp + 12]
    add [bp - 2], bx 
    add [bp - 4], bx

    sub word[bp + 8], 1
    shl word[bp + 8], 1
    mov si,[bp + 8]
    mov bx,[bp + 14]
    ;mov si,[bitmap24 + si]
    mov si,[bx + si]
    mov di, 0
    mov bx, 0
    .nextline:
        mov cx, [bp + 6]
        .drawX:
            xor ax,ax
            mov al, [si + bx]
            mov [bitaux], al
            inc bx
            mov di, 0
            .checkbit:
                shl byte [bitaux], 1
                jnc .space
                mov ah, 0x0C
                mov al, [bp + 10]          
                mov bh, 0x00
                int 0x10

                .space:
                    inc cx
                    inc di
                    mov ah, 0x0C
                    mov al, 0x0f          
                    mov bh, 0x00
                    int 0x10
                    cmp di, 8
                jne .checkbit
    
            cmp cx, [bp - 2]
        jne .drawX

        inc dx
        cmp dx, [bp - 4]
    jne .nextline 


    pop di 
    pop si
    pop bx 
    pop ax
    mov sp, bp
    pop bp
    ret ; consult print array
	
bitaux: db 0
colcount1: dw 0
rowcount1: dw 0
auxarray:  dw 0
  
  

	
	
  
