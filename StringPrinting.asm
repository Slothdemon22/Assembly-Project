  

print_char:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si

    ; Set SI to point to the message string
    mov si, [bp+10]   ; SI now points to the start of the string
    mov cx, [bp+8]    ; Load the length of the string into CX

    ; Set cursor position
    mov ah, 02h
    mov bh, 0         ; Page number
    mov dh, [bp+6]    ; Row (for desired row)
    mov dl, [bp+4]    ; Column (for desired column)
    int 10h           ; Interrupt to set cursor position

loop_mis:
    lodsb             ; Load byte from [SI] into AL, increment SI
    cmp al, 0         ; Check if we reached the end of the string
    je done_text      ; If AL = 0, jump to done

    ; Print character
    mov ah, 0Eh       ; BIOS function to print a character
    mov bh, 0         ; Page number
    mov bl, 01h        ; White text color
    int 10h           ; Interrupt to print the character

    loop loop_mis     ; Decrement CX and loop back if CX != 0

done_text:
    ; Restore stack and return
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 8             ; Return and pop 4 parameters (row, column, length, string)
    

	


printMessagesUtil:
    push message
    push len
    push 0
    push 7
    call print_char

    push message1
    push len1
    push 0
    push 30
    call print_char

    push message2
    push len2
    push 0
    push 65
    call print_char
    ; push messsage3
    ; push len3
    ; push 0
    ; push 52
    ; call print_char
	
	ret
	
	
	PrintTeleTypeOutput:
	push bp
	mov bp,sp
	push ax
    push bx
    push dx
    push cx
	push di
	
	
	mov ah, 0x02
    mov bh, 0
    mov dh, [bp+4]    ;y
    mov dl, [bp+6]    ;x
    int 0x10
	
	
	mov ax,[bp+10]    ;code of what to print
	mov ah, 0x0E
	mov bl,[bp+8]     ;color
    add al, '0'       ;conveting into ascii
    int 0x10
	
	pop di
	pop cx
    pop dx
    pop bx
    pop ax
    pop bp
	ret 8


printColRow:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    
    ; Parameters:
    ; [bp+4] = column position
    ; [bp+6] = row position
    
    ; Set text position using parameters
    mov ah, 02h
    mov bh, 0                  ; Page 0
    mov dh, [bp+6]            ; Row position from parameter
    mov dl, [bp+4]            ; Column position from parameter
    int 10h
    
    ; Print rowCount
    mov ah, 0Eh               ; Teletype output
    mov al, [rowCount]
    add al, '0'              ; Convert to ASCII
    mov bh, 0                ; Page 0
    mov bl, 04h              ; Color (white)
    int 10h
    
    ; Move to next line
    mov ah, 0Eh
    mov al, 13               ; Carriage return
    int 10h
    mov al, 10               ; Line feed
    int 10h
    
    ; Print colCount
    mov al, [colCount]
    add al, '0'              ; Convert to ASCII
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 4  
printRowColUtil:
    push 0
    push 0	
    call printColRow
	ret
	
	
	
	
	
	