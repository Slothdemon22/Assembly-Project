
winFlag:dw 0
HintFunction:
    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push si
    push di
    cmp word [hintCounter],100
    jz noHint
    xor ax,ax
    xor bx,bx
    xor di,di
    xor dx,dx
    mov al,[rowCount]
    mov bl,9
    mul bl
    add al,[colCount]
    mov si,ax

    cmp byte [boardArray+si],0
    jnz noHint
    mov al,[boardArraySolution+si]
    mov byte [boardArray+si],al
    xor bx,bx
    mov dl,al
    mov bl,al

    dec bl
    dec byte [cardCountArray+bx]
    mov ax,[hintCounter]
    add ax,1
    mov word [hintCounter],ax


    dec dl
    shl dl,1
    mov si,dx
    push word 1
    push word[numbersArray+si]                   ; bitmap pointer
    push 24    
    mov ax,[cs:rowOffset]
    add ax,4
    push ax
    mov ax,[cs:colOffset]
    add ax,4
    push ax
    call functionGnericBitmaps
    call clear_screenNotes
    call updateCardCounterOnScreen
noHint:
     pop di                    
     pop si
     pop cx
     pop ax
     pop bx
     mov sp, bp                
     pop bp
     ret
CompleteBoardChecker:
    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push si

    mov dx, 1                ; Assume success (all zeros)
	mov word [cs:winFlag],1
    xor si, si               ; Start at the beginning of cardCountArray
    mov cx, 9                ; Length of array (9 elements)

nextCompleteCheck:
    mov al, [cardCountArray + si] ; Load the current element
    inc si                       ; Move to the next element
    cmp al, 0                    ; Check if it's zero
    jnz failCheckComplete        ; If not zero, fail the check
    loop nextCompleteCheck       ; Continue for all elements

    ; If we finish the loop, DX is already 1 (success)
    jmp endCompleteCheck         ; Skip failure handling

failCheckComplete:
    mov dx, 0
mov word [cs:winFlag],0	; Indicate failure (not all zeros)

endCompleteCheck:
    pop si                    
    pop cx
    pop ax
    pop bx
    mov sp, bp                
    pop bp
    ret


checkNumberPresent:
    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push si
    push di

mov dx,1
xor ax,ax
xor bx,bx
xor di,di
mov al,[rowCount]
mov bl,9
mul bl
add al,[colCount]
mov si,ax
cmp byte [boardArray+si],0
jz endCheckPresent

mov dx,0


endCheckPresent:
   
    pop di                    
    pop si
    pop cx
    pop ax
    pop bx
    mov sp, bp                
    pop bp
    ret
   






autoCompletion:
    push bp
    mov bp, sp
    sub sp, 2
    push si 
    push cx
    push dx 
    push ax
	
	
	xor ax,ax
	xor bx,bx
	xor cx,cx
	xor dx,dx
	xor si,si
	xor di,di
	
	
	
	
	
	mov cx, 9
    xor si, si
    mov ax, 72     ; Starting X position
    mov bx, bitmaps
    mov di, 0      ; Array index
    mov dx, 39     ; Starting Y position
    mov si, 0      ; Row counter
    jmp innerclear

outerclear:
    inc si
    add dx, 45     ; Move to next row (Y position)
    mov ax, 72     ; Reset X position
    mov cx, 9      ; Reset column counter

innerclear:
    push word 15
    push word clr_box
    je skip_printclear          ; If 0000, skip printing
    push 24               ; dimension
    push ax              ; x position
    push dx              ; y position
    call functionGnericBitmaps

skip_printclear:
    add di, 2            ; Move to next array element
    add ax, 45           ; Move to next column (X position)
    loop innerclear
    cmp si, 8           ; Check if we've completed all rows
    jnz outerclear

	
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
            mov al, [boardArraySolution + si]
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
    pop si  
    pop cx 
    pop dx 
    pop ax
    mov sp, bp
    pop bp
    ret
	
updatNonRemovableNumber:
    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push si
    push di  
	
	mov cx,81
	mov si,0
.next:
    mov al,[boardArray+si]
	cmp al,0
	jz .skip
	mov byte[boardArrayFixed+si],1
	
.skip:
    inc si
loop .next
    pop di                    
    pop si
    pop cx
    pop ax
    pop bx
    mov sp, bp                
    pop bp
    ret	
checkNonremoveableNUmber:
    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push si
    push di

    mov dx,1
    xor ax,ax
    xor bx,bx
    xor di,di
    mov al,[rowCount]
    mov bl,9
    mul bl
    add al,[colCount]
    mov si,ax
    cmp byte [boardArrayFixed+si],0
    jz endRemoveableCheck
    mov dx,0


endRemoveableCheck:
    pop di                    
    pop si
    pop cx
    pop ax
    pop bx
    mov sp, bp                
    pop bp
    ret
   
checkNumberNotes:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    call checkNumberPresent
cmp dx,1
jnz endCheckUtilNotes
    ; Check for key 1 (0x02)
mov cx,[rowOffset]
mov dx,[colOffset]
    cmp al, 0x02
    jnz check2Notes
add cx,2
add dx,2
    mov bx, number_s1           ; Get offset of bitmap for 1
    jmp printNumberNotes

check2Notes:
    cmp al, 0x03
    jnz check3Notes
add cx,12
add dx,2
    mov bx, number_s2           ; Get offset of bitmap for 2
    jmp printNumberNotes

check3Notes:
    cmp al, 0x04
    jnz check4Notes
add cx,22
add dx,2
    mov bx, number_s3           ; Get offset of bitmap for 3
    jmp printNumberNotes

check4Notes:
    cmp al, 0x05
    jnz check5Notes
add cx,2
add dx,12
    mov bx, number_s4           ; Get offset of bitmap for 4
    jmp printNumberNotes

check5Notes:
    cmp al, 0x06
    jnz check6Notes
add cx,12
add dx,12
    mov bx, number_s5           ; Get offset of bitmap for 5
    jmp printNumberNotes

check6Notes:
    cmp al, 0x07
    jnz check7Notes
add cx,22
add dx,12
    mov bx, number_s6           ; Get offset of bitmap for 6
    jmp printNumberNotes

check7Notes:
    cmp al, 0x08
    jnz check8Notes
add cx,2
add dx,22
    mov bx, number_s7           ; Get offset of bitmap for 7
    jmp printNumberNotes

check8Notes:
    cmp al, 0x09
    jnz check9Notes
add cx,12
add dx,22
    mov bx, number_s8           ; Get offset of bitmap for 8
    jmp printNumberNotes

check9Notes:
    cmp al, 0x0A
    jnz endCheckUtilNotes
add cx,22
add dx,22
    mov bx, number_s9           ; Get offset of bitmap for 9
    jmp printNumberNotes
printNumberNotes:
    ; Common logic to render the number bitmap
    push word 1        ; Color
    push bx             ; Bitmap pointer
    push word 8         ; Bitmap dimension
    push cx       ; Y coordinate
    push dx       ; X coordinate
    call functionGnericBitmaps
endCheckUtilNotes:
    ; If no valid key is pressed, exit function
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret



isValidInput:
    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push si
    push di

    mov dx, 1                  ; Initialize result as valid (1)

    ; === Row Check ===
    mov al, [cs:rowCount]      
    mov bl, 9                  
    mul bl                    
    mov si, ax                

    mov cx, 9                  
check_row_loop:
    mov al, [cs:boardArray + si]  
    cmp al, 0                  
    je next_column
    cmp al, [cs:inputNum]      
    je failCheck              
next_column:
    inc si                    
    loop check_row_loop        

    ; === Column Check ===
    xor ax, ax                
    xor bx, bx
    mov bl, [cs:colCount]      
    mov si, bx                
    mov cx, 9                  

nextCol:
    mov al, [cs:boardArray+si]
    cmp al, 0
    je skip_col
    cmp al, [cs:inputNum]      
    je failCheck              
skip_col:
    add si, 9                  
    loop nextCol              

    ; === 3x3 Grid Check ===
    mov al, [cs:rowCount]      ; Get current row
    mov bl, 3
    div bl                     ; Divide by 3 to get block row
    mov cl, 3
    mul cl                     ; Multiply by 3 to get starting row of block
    push ax                    ; Save starting row

    mov al, [cs:colCount]      ; Get current column
    mov bl, 3
    div bl                     ; Divide by 3 to get block column
    mov cl, 3
    mul cl                     ; Multiply by 3 to get starting column
    mov bx, ax                 ; Save starting column in BX
   
    pop ax                     ; Restore starting row
    mov cl, 9
    mul cl                     ; Multiply row by 9 to get row offset
    add ax, bx                 ; Add column offset
    mov si, ax                 ; SI now points to start of 3x3 block

    ; Check 3x3 grid
    mov cx, 3                  ; Outer loop counter (3 rows)
grid_row_loop:
    push cx                    ; Save outer loop counter
    mov bx, 0                  ; Column offset
    mov cx, 3                  ; Inner loop counter (3 columns)
grid_col_loop:
    mov al, [cs:boardArray + si + bx]
    cmp al, 0                  ; Skip if empty
    je next_grid_cell
    cmp al, [cs:inputNum]      ; Compare with input number
    je grid_fail
next_grid_cell:
    inc bx                     ; Move to next column
    loop grid_col_loop
   
    pop cx                     ; Restore outer loop counter
    add si, 9                  ; Move to next row
    loop grid_row_loop
   
    mov dx, 1                  ; If we get here, input is valid
    jmp endCheck

grid_fail:
    pop cx                     ; Clean up stack from loop
    mov dx, 0                  ; Mark as invalid
    jmp endCheck

failCheck:
    mov dx, 0                  ; Mark input as invalid
    jmp endCheck

endCheck:
    cmp dx,0
    jnz finalTerminate
    add word[MistakesCounter],1
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

finalTerminate:
    pop di                    
    pop si
    pop cx
    pop ax
    pop bx
    mov sp, bp                
    pop bp
    ret



checkNumberUtil:
    push bp
    mov bp,sp
    push ax
    push bx
   
    ; Get the key from stack (passed through ax)
    mov al,[cs:inputNum]
mov ax,0

mov al,[cs:inputNum]



   
    ; Check for key 1 (0x02)
    cmp al, 0x01
    jnz check2
    mov bx, numbersArray        ; Get offset of bitmap1
    jmp printNumber
   
check2:
    cmp al, 0x02
    jnz check3
    mov bx, numbersArray + 2    ; Get offset of bitmap2
    jmp printNumber
   
check3:
    cmp al, 0x03
    jnz check4
    mov bx, numbersArray + 4    ; Get offset of bitmap3
    jmp printNumber
   
check4:
    cmp al, 0x04
    jnz check5
    mov bx, numbersArray + 6    ; Get offset of bitmap4
    jmp printNumber
   
check5:
    cmp al, 0x05
    jnz check6
    mov bx, numbersArray + 8    ; Get offset of bitmap5
    jmp printNumber
   
check6:
    cmp al, 0x06
    jnz check7
    mov bx, numbersArray + 10   ; Get offset of bitmap6
    jmp printNumber
   
check7:
    cmp al, 0x07
    jnz check8
    mov bx, numbersArray + 12   ; Get offset of bitmap7
    jmp printNumber
   
check8:
    cmp al, 0x08
    jnz check9
    mov bx, numbersArray + 14   ; Get offset of bitmap8
    jmp printNumber
   
check9:
    cmp al, 0x09
    jnz endCheckUtil
    mov bx, numbersArray + 16   ; Get offset of bitmap9
   
printNumber:
   
     call checkNumberPresent
     cmp dx,1
     jnz endCheckUtil
     call isValidInput
     cmp dx,0
     jz endCheckUtil

     call ScoreUpdationFunction
     push 15
     push clr_box        ; Color
                 ; Bitmap pointer
    push word 32         ; Bitmap dimension
    push word [rowOffset]       ; Y coordinate
    push word [colOffset]       ; X coordinate
    call functionGnericBitmaps

push bx
xor bx,bx

mov bl,[cs:inputNum]
dec bl
dec  byte[cs:cardCountArray+bx]
call clear_screenNotes
call updateCardCounterOnScreen
pop bx



    mov bx, [cs:bx]            ;
push word 1
    push bx                    ; bitmap pointer
    push 24    
    mov ax,[cs:rowOffset]
    add ax,4
    push ax
    mov ax,[cs:colOffset]
    add ax,4
    push ax
    call functionGnericBitmaps

    mov al,[cs:rowCount]
    mov ah, 0        ; Clear AH for multiplication
    mov bl, 9        ; Row size (9 columns)
    mul bl           ; AX = row * 9
    mov bl,[cs:colCount]
    add al, bl       ; AX = (row * 9) + col
    mov si,ax

    mov al,[cs:inputNum]
    mov byte [cs:boardArray+si],al

    push 20
    push 0
    call printColRow
     ;call ScoreUpdationFunction
endCheckUtil:
    pop bx
    pop ax
    mov sp,bp
    pop bp
    ret


removeNumber:
    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push si
    push di


xor ax,ax
xor bx,bx
xor di,di
mov al,[rowCount]
mov bl,9
mul bl
add al,[colCount]
mov si,ax
mov al,[boardArray+si]
mov byte[boardArray+si],0
dec al
mov di,ax
inc byte [cardCountArray+di]
   

    pop di                    
    pop si
    pop cx
    pop ax
    pop bx
    mov sp, bp                
    pop bp
    ret


updateCardCount:
    push bp
mov bp,sp
push ax
    push bx
    push dx
    push cx
    xor ax,ax
mov si,boardArray
mov di,cardCountArray
mov cx,81
nextElement:
    mov al,[si]
cmp al,0
jz skipDec
mov bx,ax
dec bx
dec byte [cardCountArray+bx]
skipDec:
   
inc si
loop nextElement
pop cx
    pop dx
    pop bx
    pop ax
    pop bp
    ret




ScoreUpdationFunction:
    push bp                    
    mov bp, sp
    push bx                    
    push ax
    push cx
    push dx
    push di
   
    ; Increment score by 10
    mov ax, [Score]
    add ax, 10
    mov [Score], ax
   
    mov ax, [Score]     ; Load Score into AX
    push 1           ; Color (white)
    push 72         ; x coordinate
    push 0           ; y coordinate
    push ax              ; Number to print
    call PrintNumberUtil

 
    pop di                    
    pop dx
    pop cx
    pop ax
	pop bx
	pop bp
	ret