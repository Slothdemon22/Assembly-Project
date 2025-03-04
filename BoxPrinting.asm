printBoxesGridScreen:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    mov bx, bitboxesarray
    mov ax, 15          ; x
    mov dx, 30          ; y
    mov cx, 4
    mov si, 0

print_boxes:
    push word 1
    push word [bx+si]
    push 32             ; Dimensions
    add si, 2
    push ax             ; x
    push dx             ; y
    add dx, 50
    call functionGnericBitmaps
    loop print_boxes

    push 1
    push word hintBox
    push 32
    push 14
    push 178
    call functionGnericBitmaps

    ; End of this part

    ; This part prints empty boxes of 32x32 dimensions that hold count of numbers
    mov cx, 2
    mov bx, bitboxes4
    mov ax, 500
    mov dx, 160
    mov si, 0
    jmp print_boxes_num

next_row:
    mov ax, 500
    add dx, 70
    mov cx, 2

print_boxes_num:
    push word 1
    push bx
    push 32             ; Dimensions
    push ax             ; x
    push dx             ; y
    add ax, 60
    call functionGnericBitmaps
    loop print_boxes_num
    inc si
    cmp si, 4
    jnz next_row

    push word 1
    push bx
    push 32             ; Last box dimensions
    push 530
    push 420
    call functionGnericBitmaps
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret


	
print_horizontal:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    mov cx, [bp+8]   ; Load x1 (starting X)
    mov di, [bp+6]   ; Load x2 (ending X)
    mov dx, [bp+4]   ; Load Y coordinate
    mov ax, [bp+10]
print:
    mov ah, 0Ch      ; BIOS function to write a pixel
          ; White color (color 15)
    mov bh, 0        ; Page number

draw_loop:
    int 0x10         ; Draw the pixel at (cx, dx)
    inc cx           ; Move to the next X position
    cmp cx, di       ; Compare current X with x2
    jle draw_loop    ; If cx <= di, continue drawing

    ; Restore stack and return
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 8            ; Return and pop 3 parameters (x1, x2, y)


print_vertical:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push di

    ; Load parameters
    mov al, [bp+10]   ; Color (byte)
    mov cx, [bp+8]    ; X coordinate (word)
    mov dx, [bp+6]    ; Starting Y (word)
    mov di, [bp+4]    ; Ending Y (word)

    mov ah, 0Ch       ; BIOS function to write a pixel
    mov bh, 0         ; Video page 0

print_line:
    ; Plot the pixel at (CX, DX)
    int 10h
    inc dx            ; Move to the next Y position
    cmp dx, di        ; Compare current Y with ending Y
    jle print_line    ; If DX <= DI, continue drawing

    ; Restore stack and return
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 8             ; Return and clean up 8 bytes of parameters
printSudokoBox:
    push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	mov ax,[bp+4]
	
    ; Loop to draw multiple horizontal lines
    mov cx, 10       ; Number of lines to draw
    mov bx, 28       ; Initial Y-coordinate
    mov dx, 45       ; Offset between lines
line_loop:
    push word ax      ; Color
    push word 65    ; Starting X
    push word 468    ; Ending X
    push bx          ; Current Y-coordinate
    call print_horizontal

    add bx, dx       ; Increment Y-coordinate by offset
    loop line_loop   ; Repeat until CX (loop counter) reaches 0
	

        ; Initialize parameters for the loop
    mov cx, 10       ; Number of lines to draw
    mov bx, 64       ; Starting X-coordinate
    mov dx, 45       ; Offset between lines

line_loopVertical:
    push ax    ; Color (red)
    push bx           ; Current X-coordinate
    push word 28      ; Starting Y
    push word 433     ; Ending Y
    call print_vertical

    add bx, dx        ; Increment X-coordinate by the offset
    loop line_loopVertical    ; Decrement CX and repeat until CX == 0
	
	
    push ax       ; Color (red)
    push 63           ; Current X-coordinate
    push word 28      ; Starting Y
    push word 433     ; Ending Y
    call print_vertical
	push ax      ; Color (red)
    push 65         ; Current X-coordinate
    push word 28      ; Starting Y
    push word 433     ; Ending Y
    call print_vertical
    push ax      ; Color (red)
    push 63+405           ; Current X-coordinate
    push word 28      ; Starting Y
    push word 433     ; Ending Y
    call print_vertical
    push ax       ; Color (red)
    push 63+407           ; Current X-coordinate
    push word 28      ; Starting Y
    push word 433     ; Ending Y
    call print_vertical

    push word [boardColor]       ; Color (red)
    push 108+90           ; Current X-coordinate
    push word 28      ; Starting Y
    push word 433     ; Ending Y
    call print_vertical
    push ax       ; Color (red)
    push 108+92           ; Current X-coordinate
    push word 28      ; Starting Y
    push word 433     ; Ending Y
    call print_vertical
    push ax       ; Color (red)
    push 108+90+135           ; Current X-coordinate
    push word 28      ; Starting Y
    push word 433     ; Ending Y
    call print_vertical
    push ax       ; Color (red)
    push 108+90+137           ; Current X-coordinate
    push word 28      ; Starting Y
    push word 433     ; Ending Y
    call print_vertical
	
	
	
	
	
	
	
    push ax      ; Color
    push word 65    ; Starting X
    push word 468    ; Ending X
    push 27          ; Current Y-coordinate
    call print_horizontal
    push ax     ; Color
    push word 65    ; Starting X
    push word 468    ; Ending X
    push 29          ; Current Y-coordinate
    call print_horizontal
	
    push ax      ; Color
    push word 65    ; Starting X
    push word 468    ; Ending X
    push 28+134          ; Current Y-coordinate
    call print_horizontal
    push ax      ; Color
    push word 65    ; Starting X
    push word 468    ; Ending X
    push 28+136          ; Current Y-coordinate
    call print_horizontal
    push ax      ; Color
    push word 65    ; Starting X
    push word 468    ; Ending X
    push 28+134+135          ; Current Y-coordinate
    call print_horizontal
    push ax      ; Color
    push word 65    ; Starting X
    push word 468    ; Ending X
    push 28+134+137          ; Current Y-coordinate
    call print_horizontal
    push ax      ; Color
    push word 65    ; Starting X
    push word 468    ; Ending X
    push 28+134+137+133          ; Current Y-coordinate
    call print_horizontal
    push ax      ; Color
    push word 65    ; Starting X
    push word 468    ; Ending X
    push 28+134+137+135          ; Current Y-coordinate
    call print_horizontal
	
	
	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	mov sp,bp
	pop bp
	ret 2
StartScreenPrint:
    
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di	
	
	
	
	push word 1      ; Color
    push word 150    ; Starting X
    push word 435    ; Ending X
    push 120          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 150    ; Starting X
    push word 435    ; Ending X
    push 119          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 150    ; Starting X
    push word 435    ; Ending X
    push 121          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 150    ; Starting X
    push word 435    ; Ending X
    push 120+230          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 150    ; Starting X
    push word 435    ; Ending X
    push 120+230-1          ; Current Y-coordinate
    call print_horizontal
	push word 1      ; Color
    push word 150    ; Starting X
    push word 435    ; Ending X
    push 120+230+1          ; Current Y-coordinate
    call print_horizontal
    push 1       ; Color (red)
    push 108+42           ; Current X-coordinate
    push word 120      ; Starting Y
    push word 350     ; Ending Y
    call print_vertical
	push 1       ; Color (red)
    push 108+42-1           ; Current X-coordinate
    push word 120      ; Starting Y
    push word 350     ; Ending Y
    call print_vertical
	push 108+42+1           ; Current X-coordinate
    push word 120      ; Starting Y
    push word 350     ; Ending Y
    call print_vertical
	push 1       ; Color (red)
    push 435          ; Current X-coordinate
    push word 120      ; Starting Y
    push word 350     ; Ending Y
    call print_vertical
	push 1       ; Color (red)
    push 435-1          ; Current X-coordinate
    push word 120      ; Starting Y
    push word 350     ; Ending Y
    call print_vertical
	push 1       ; Color (red)
    push 435+1          ; Current X-coordinate
    push word 120      ; Starting Y
    push word 350     ; Ending Y
    call print_vertical
    call StartSuduko
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	mov sp,bp
	pop bp
	ret
; Function to print characters on the screen
