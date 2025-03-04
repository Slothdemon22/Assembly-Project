[org 0x0100]       ; Origin for COM file format (starts at 0x100)
jmp start          ; Jump to the start of the program
clr_screen:
    ; Save registers (including BP)
    push ax
    push bx
    push cx
    push dx
    push bp
    push si
    push di

    mov ax, 0x0C0F  ; Function 0Ch (Write pixel) with color 0x0F (white) in AL
    mov bh, 0       ; Page number (always 0 for mode 12h)
    xor cx, cx      ; Start X position from 0
    xor dx, dx      ; Start Y position from 0

draw_screen:
    int 10h         ; Call interrupt 10h, function 0Ch to draw the pixel
    inc cx          ; Increment X (move right)

    cmp cx, 640     ; If X >= 640, move to the next line
    jne next_pixel  ; If not at the end of the row, continue

    xor cx, cx      ; Reset X position to 0
    inc dx          ; Move to the next row (increment Y)

    cmp dx, 480     ; If Y >= 480, we're done
    je finish         ; If at the bottom of the screen, finish

next_pixel:
    jmp draw_screen ; Repeat for the next pixel

finish:
    ; Restore registers (including BP)
    pop di
    pop si
    pop bp
    pop dx
    pop cx
    pop bx
    pop ax

    ret 
function_notes:
    push bp
    mov bp, sp
    sub sp, 4          ; Make space for 2 local variables (xEnding and yEnding)
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    ; Initialize parameters from the stack
    mov cx, [bp+6]     ; Load starting X coordinate
    mov dx, [bp+4]     ; Load starting Y coordinate
    mov si, [bp+8]     ; SI points to bitmap data

    ; Calculate xEnding and yEnding
    mov ax, cx         ; Copy starting X to AX
    add ax, 8         ; Add 24 to X for the width
    mov [bp-4], ax     ; Store xEnding in local variable

    mov ax, dx         ; Copy starting Y to AX
    add ax, 8         ; Add 24 to Y for the height
    mov [bp-2], ax     ; Store yEnding in local variable

draw_loop2:
    mov bl, [si]       ; Load byte from bitmap into BL
    inc si             ; Increment SI to the next byte

    ; Bit shifting loop to draw pixels
    mov di, 8          ; 8 bits per byte
bit_loop2:
    shl bl, 1          ; Shift left, bit goes into carry flag
    jnc skip_pixel2     ; If carry not set, skip the pixel

    ; Plot pixel using AL for color
    mov ah, 0Ch        ; BIOS function to plot pixel
    mov bh, 0          ; Page number
    mov al, 01h        ; White color in AL
    int 10h            ; Interrupt to draw the pixel

skip_pixel2:
    inc cx             ; Move to next X coordinate
    dec di
    jnz bit_loop2       ; Continue if not all 8 bits processed

    ; Check if the row has been fully drawn
    cmp cx, [bp-4]     ; Compare with xEnding
    jne continue_row2

    ; Move to next row
    mov cx, [bp+6]     ; Reset X to starting X
    inc dx             ; Move to the next row
    cmp dx, [bp-2]     ; Compare with yEnding
    je done2            ; If all rows are drawn, exit

continue_row2:
    jmp draw_loop2

done2:
    ; Restore stack and return
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    mov sp, bp
    pop bp
    ret 6              ; Return and pop 3 parameters (X, Y, bitmap data)

; Function to draw a 32x32 bitmap
function1:
    push bp
    mov bp, sp
    sub sp, 4          ; Make space for 2 local variables (xEnding and yEnding)
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    ; Initialize parameters from the stack
    mov cx, [bp+6]     ; Load starting X coordinate
    mov dx, [bp+4]     ; Load starting Y coordinate
    mov si, [bp+8]     ; SI points to bitmap data

    ; Calculate xEnding and yEnding
    mov ax, cx         ; Copy starting X to AX
    add ax, 32         ; Add 32 to X for the width
    mov [bp-4], ax     ; Store xEnding in local variable

    mov ax, dx         ; Copy starting Y to AX
    add ax, 32         ; Add 32 to Y for the height
    mov [bp-2], ax     ; Store yEnding in local variable

draw_loop1_:
    mov bl, [si]       ; Load byte from bitmap into BL
    inc si             ; Increment SI to the next byte

    ; Bit shifting loop to draw pixels
    mov di, 8          ; 8 bits per byte
bit_loop1_:
    shl bl, 1          ; Shift left, bit goes into carry flag
    jnc skip_pixel_    ; If carry not set, skip the pixel

    ; Plot pixel using AL for color
    mov ah, 0Ch        ; BIOS function to plot pixel
    mov bh, 0          ; Page number
    mov al, 01h        ; White color in AL
    int 10h            ; Interrupt to draw the pixel

skip_pixel_:
    inc cx             ; Move to next X coordinate
    cmp cx, [bp-4]     ; Compare with xEnding
    jl continue_bit    ; If less, continue with current byte

    ; Move to the next row
    mov cx, [bp+6]     ; Reset X to starting X
    inc dx             ; Move to the next row
    cmp dx, [bp-2]     ; Compare with yEnding
    je done1           ; If all rows are drawn, exit

    jmp draw_loop1_    ; Start the next row

continue_bit:
    dec di
    jnz bit_loop1_     ; Continue if not all 8 bits processed
    jmp draw_loop1_    ; Move to the next byte

done1:
    ; Restore stack and return
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    mov sp, bp
    pop bp
    ret 6              ; Return and pop 3 parameters (X, Y, bitmap data)

; Function to draw a 24x24 bitmap
function:
    push bp
    mov bp, sp
    sub sp, 4          ; Make space for 2 local variables (xEnding and yEnding)
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    ; Initialize parameters from the stack
    mov cx, [bp+6]     ; Load starting X coordinate
    mov dx, [bp+4]     ; Load starting Y coordinate
    mov si, [bp+8]     ; SI points to bitmap data

    ; Calculate xEnding and yEnding
    mov ax, cx         ; Copy starting X to AX
    add ax, 24         ; Add 24 to X for the width
    mov [bp-4], ax     ; Store xEnding in local variable

    mov ax, dx         ; Copy starting Y to AX
    add ax, 24         ; Add 24 to Y for the height
    mov [bp-2], ax     ; Store yEnding in local variable

draw_loop1:
    mov bl, [si]       ; Load byte from bitmap into BL
    inc si             ; Increment SI to the next byte

    ; Bit shifting loop to draw pixels
    mov di, 8          ; 8 bits per byte
bit_loop:
    shl bl, 1          ; Shift left, bit goes into carry flag
    jnc skip_pixel     ; If carry not set, skip the pixel

    ; Plot pixel using AL for color
    mov ah, 0Ch        ; BIOS function to plot pixel
    mov bh, 0          ; Page number
    mov al, 01h        ; White color in AL
    int 10h            ; Interrupt to draw the pixel

skip_pixel:
    inc cx             ; Move to next X coordinate
    dec di
    jnz bit_loop       ; Continue if not all 8 bits processed

    ; Check if the row has been fully drawn
    cmp cx, [bp-4]     ; Compare with xEnding
    jne continue_row

    ; Move to next row
    mov cx, [bp+6]     ; Reset X to starting X
    inc dx             ; Move to the next row
    cmp dx, [bp-2]     ; Compare with yEnding
    je done            ; If all rows are drawn, exit

continue_row:
    jmp draw_loop1

done:
    ; Restore stack and return
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    mov sp, bp
    pop bp
    ret 6              ; Return and pop 3 parameters (X, Y, bitmap data)

; Function to print a horizontal line
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

print:
    mov ah, 0Ch      ; BIOS function to write a pixel
    mov al, 01h       ; White color (color 15)
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
    ret 6            ; Return and pop 3 parameters (x1, x2, y)

; Function to print a vertical line
print_vertical:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    mov cx, [bp+8]   ; Load X coordinate
    mov dx, [bp+6]   ; Load y1 (starting Y)
    mov di, [bp+4]   ; Load y2 (ending Y)

    mov ah, 0Ch      ; BIOS function to write a pixel
    mov al, 0x1       ; White color (color 15)
    mov bh, 0        ; Page number

print_line:
    int 0x10         ; Draw the pixel at (cx, dx)
    inc dx           ; Move to the next Y position
    cmp dx, di       ; Compare current Y with y2
    jle print_line   ; If dx <= di, continue drawing

    ; Restore stack and return
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 6            ; Return and pop 3 parameters (x, y1, y2)

; Function to print characters on the screen
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
    

start:
    mov ax, 0x0012   ; Set video mode to 640x480 16-color graphics mode
    int 0x10
    MOV AL, 0
MOV DX, 0x3C8
OUT DX, AL

MOV DX, 0x3C9

MOV AL, 63
OUT DX, AL
MOV AL, 63
OUT DX, AL
MOV AL, 63
OUT DX, AL

MOV AL, 0
OUT DX, AL
MOV AL, 0
OUT DX, AL
MOV AL,0
OUT DX,AL
  


;----- Draw the left horizontal border -----;
    
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
    push messsage3
    push len3
    push 0
    push 52
    call print_char
    
    ; Top horizontal line
    mov ax, 60       ; Y coordinate (starting position)
    mov bx, 26       ; X1 (left boundary)
    mov dx, 423      ; X2 (right boundary)

;----- Draw vertical borders (3px wide) -----;

    ; First vertical border
    mov cx, 5
border_v_1:
    push ax
    push bx
    push dx
    add ax, 1
    call print_vertical   ; Draw vertical line
    loop border_v_1       ; Loop for cx times

    ; Second vertical border (shifted 43 pixels)
    mov ax, 107
    mov cx, 3
vertical_3_rows:
    push ax
    push bx
    push dx
    add ax, 43
    call print_vertical
    loop vertical_3_rows

    ; Third vertical border
    mov ax, 194
    mov cx, 2
border_v_2:
    push ax
    push bx
    push dx
    add ax, 1
    call print_vertical
    loop border_v_2

    ; Fourth vertical border
    mov ax, 238
    mov cx, 3
print_6_vertical:
    push ax
    push bx
    push dx
    add ax, 43
    call print_vertical
    loop print_6_vertical

;----- Draw the remaining vertical borders -----;

    mov ax, 325
    mov cx, 2
border_v_3:
    push ax
    push bx
    push dx
    add ax, 1
    call print_vertical
    loop border_v_3

    ; Fifth vertical border
    mov ax, 369
    mov cx, 3
print_9_vertical:
    push ax
    push bx
    push dx
    add ax, 43
    call print_vertical
    loop print_9_vertical

    ; Final vertical border
    mov ax, 456
    mov cx, 4
border_v_4:
    push ax
    push bx
    push dx
    add ax, 1
    call print_vertical
    loop border_v_4

;----- Draw horizontal borders -----;

    xor ax, ax
    xor cx, cx
    mov cx, 5
    mov ax, 25
    mov bx, 60
    mov dx, 459

border_0:
    push bx
    push dx
    push ax
    add ax, 1
    call print_horizontal
    loop border_0

    ; First 3 horizontal rows
    mov ax, 72
    mov cx, 3
first_3_horizontal_lines:
    push bx
    push dx
    push ax
    add ax, 43
    call print_horizontal
    loop first_3_horizontal_lines

    ; Second set of horizontal rows (2px wide border)
    mov ax, 159
    mov cx, 2
border_1:
    push bx
    push dx
    push ax
    add ax, 1
    call print_horizontal
    loop border_1

    ; Next 6 horizontal rows
    mov ax, 203
    mov cx, 3
next_6_horizontal_rows:
    push bx
    push dx
    push ax
    add ax, 43
    call print_horizontal
    loop next_6_horizontal_rows
    mov ax,288 
    mov cx, 3
border_2:
    push bx
    push dx
    push ax
    add ax, 1
    call print_horizontal
    loop border_2

    ; Final 9 horizontal rows
    mov ax, 334
    mov cx, 3
next_9_horizontal_rows:
    push bx
    push dx
    push ax
    add ax, 43
    call print_horizontal
    loop next_9_horizontal_rows

    ; Bottom border
    mov ax, 421
    mov cx, 4
border_3:
    push bx
    push dx
    push ax
    add ax, 1
    call print_horizontal
    loop border_3
    mov bx, 120
    mov dx, 400
    mov ax,430
    push bx
    push dx
    push ax
    call print_horizontal
    add ax,1
    push bx
    push dx
    push ax
    call print_horizontal
    add ax,43
    push bx
    push dx
    push ax
    call print_horizontal
    add ax,1
    push bx
    push dx
    push ax
    call print_horizontal



    mov ax, 120       ; Y coordinate (starting position)
    mov bx, 430       ; X1 (left boundary)
    mov dx, 474      ; X2 (right boundary)
    push ax
    push bx
    push dx
    call print_vertical   ; Draw vertical line
    add ax,1
    push ax
    push bx
    push dx
    call print_vertical   ; Draw vertical line
    add ax,280
    push ax
    push bx
    push dx
    call print_vertical   ; Draw vertical line
    dec ax
    push ax
    push bx
    push dx
    call print_vertical   ; Draw vertical line
;    push messsage4
;     push len4
;     push 28
;     push 28
;     call print_char
    mov si,0
    mov bx,sudoku_array
    mov ax,185
    mov dx,438
    mov cx,6
  print_sudoku:
   push word [bx+si]
   add si,2
   push ax
   add ax,25
   push dx
   call function1
   loop print_sudoku

  


;----- Draw bitboxes using function1 -----;
    mov bx,bitboxesarray
    mov ax,15
    mov dx,30
    mov cx,3
    mov si,0
print_boxes:
    push word [bx+si]
    add si,2
    push ax
    push dx
    add dx,50
    call function1
    loop print_boxes
    

    
    ; Loop to draw multiple bitboxes
    
    mov cx,2
    mov bx,bitboxes4
    mov ax,500
    mov dx,50
    mov si,0
    jmp print_boxes_num


    next_row:
        mov ax,500
        add dx ,70
        mov cx,2
    print_boxes_num:
        push bx
        push ax
        push dx
        add ax,60
        call function1
        loop print_boxes_num
        inc si
        cmp si,4  
        jnz next_row
        push bx
        push 530
        push 330
        call function1
       

        mov bx,bitboxesnum
        mov di,0
        mov cx,2
        mov ax,506
        mov dx,54
        mov si,0
        jmp print_boxes_numbers



        next_row_num:
        mov ax,500
        add dx ,70
        mov cx,2
      print_boxes_numbers:
       
        push word [bx+di]
        add di,2
        push ax
        push dx
        add ax,60
        call function
        loop print_boxes_numbers
        inc si
        cmp si,4  
        jnz next_row_num
        push word [bx+16]
        push 536
        push 334
        call function
        
        mov cx,2
        mov ax,494
        mov dx,90
        mov si,0
        mov di,0
        mov bx,notes_array
        jmp print_notes
        
        next_row_notes:
        mov ax,490
        add dx,70
        mov cx,2
        print_notes:
        push word[bx+di]
        add di,2
        push ax
        push dx
        add ax,60
        call function_notes
        loop print_notes
        inc si
        cmp si,4  
        jnz next_row_notes
        push word [bx+16]
        push 530
        push 370
        call function_notes


   

        

;----- Draw rows using function -----;

    xor cx, cx
    mov cx, 9
    xor bx, bx
    mov bx, bitboxesnum
    xor si, si
    mov ax, 65


    ; Nested loop to draw bitmaps
    mov cx, 9
    mov ax, 72
    mov bx, bitmaps
    mov di, 0
    mov dx, 38
    mov si, 0
    jmp inner

outer:
    inc si
    add dx, 44
    mov ax, 72
    mov cx, 9

inner:
    push word [bx + di]
    add di, 2
    push ax
    add ax, 44
    push dx
    call function
    loop inner
    cmp si, 8
    jnz outer

;----- Print text messages -----;


    ; mov ah,0Bh
    ; mov bh,00h
    ; mov bl,0xF
    ; int 10h

;----- Wait for key press and exit -----;

    mov ah, 0x00
    int 0x16          ; Wait for key press

    mov ax, 0x4C00    ; Exit program
    int 0x21

bitmaps: 
    dw bitmap5, bitmap3, bitmap1, bitmap8, bitmap6, bitmap4, bitmap9, bitmap7, bitmap2
    dw bitmap7, bitmap2, bitmap5, bitmap1, bitmap6, bitmap9, bitmap4, bitmap8, bitmap3
    dw bitmap9, bitmap6, bitmap2, bitmap4, bitmap1, bitmap7, bitmap3, bitmap5, bitmap8
    dw bitmap3, bitmap1, bitmap4, bitmap2, bitmap8, bitmap7, bitmap9, bitmap6, bitmap5
    dw bitmap2, bitmap7, bitmap9, bitmap5, bitmap6, bitmap3, bitmap8, bitmap4, bitmap1
    dw bitmap4, bitmap5, bitmap6, bitmap8, bitmap9, bitmap7, bitmap3, bitmap1, bitmap2
    dw bitmap6, bitmap8, bitmap2, bitmap9, bitmap4, bitmap3, bitmap7, bitmap5, bitmap1
    dw bitmap1, bitmap9, bitmap7, bitmap6, bitmap3, bitmap2, bitmap8, bitmap5, bitmap4
    dw bitmap8, bitmap4, bitmap2, bitmap3, bitmap1, bitmap5, bitmap6, bitmap7, bitmap9
bitboxesnum:
    dw bitmap1,bitmap2,bitmap3,bitmap4,bitmap5,bitmap6,bitmap7,bitmap8,bitmap9

bitboxesarray:
    dw bitboxes1,bitboxes2,bitboxes3

message: db 'Mistakes 0/3', 0 ; Null-terminated string
len:     dw 12                 ; Length of the string (including spaces, not null terminator)

message1: db 'Easy',0
len1:dw 4
message2:db 'Score 0',0
len2:dw 7
messsage3: db '00:08',0
len3: dw 5
message4: db 'Sudoku Grid',0
len4:dw 11

number_s2:
     db 0x18, 0x24, 0x44, 0x04, 0x08, 0x10, 0x20, 0x7c
number_s1:
     db 0x08, 0x18, 0x28, 0x08, 0x08, 0x08, 0x08, 0x3e
number_s3:
     db 0x3c, 0x02, 0x04, 0x08, 0x04, 0x04, 0x24, 0x18
number_s4:
     db 0x00, 0x24, 0x24, 0x24, 0x1c, 0x04, 0x04, 0x04
number_s5:
     db 0x00, 0x3c, 0x20, 0x20, 0x3c, 0x04, 0x04, 0x3c
number_s6:
     db 0x04, 0x08, 0x10, 0x10, 0x1e, 0x12, 0x12, 0x0c
number_s7:
     db 0x3e, 0x02, 0x04, 0x08, 0x08, 0x10, 0x10, 0x10
number_s8:
     db 0x38, 0x44, 0x44, 0x44, 0x38, 0x44, 0x44, 0x38
number_s9:
     db 0x1c, 0x22, 0x22, 0x22, 0x1e, 0x02, 0x02, 0x1c
notes_array:
    dw number_s8,number_s6,number_s2,number_s1,number_s4,number_s6,number_s1,number_s7,number_s2


u: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x02, 0x00, 0x00, 0x80, 0x01, 0xff, 0xff, 0x00, 0x00, 0xff, 0xfe, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
s: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xff, 0xff, 0x80, 0x03, 0xff, 0xff, 0xc0, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0xff, 0xff, 0x80, 0x00, 0xff, 0xff, 0xc0, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x40, 0x01, 0xff, 0xff, 0xc0, 0x00, 0xff, 0xff, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
d: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 0xff, 0xfc, 0x00, 0x07, 0xff, 0xfe, 0x00, 0x06, 0x00, 0x03, 0x00, 0x06, 0x00, 0x01, 0x80, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x01, 0x80, 0x07, 0xff, 0xff, 0x00, 0x07, 0xff, 0xfe, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
o:db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xfe, 0x00, 0x01, 0xff, 0xff, 0x00, 0x02, 0x00, 0x00, 0x80, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x06, 0x00, 0x00, 0xc0, 0x02, 0x00, 0x00, 0x80, 0x01, 0xff, 0xff, 0x00, 0x00, 0xff, 0xfe, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
k: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x60, 0x06, 0x00, 0x00, 0x60, 0x0c, 0x00, 0x00, 0x60, 0x18, 0x00, 0x00, 0x60, 0x30, 0x00, 0x00, 0x60, 0x60, 0x00, 0x00, 0x60, 0xc0, 0x00, 0x00, 0x61, 0x80, 0x00, 0x00, 0x63, 0x00, 0x00, 0x00, 0x66, 0x00, 0x00, 0x00, 0x6c, 0x00, 0x00, 0x00, 0x78, 0x00, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x78, 0x00, 0x00, 0x00, 0x6c, 0x00, 0x00, 0x00, 0x66, 0x00, 0x00, 0x00, 0x63, 0x00, 0x00, 0x00, 0x61, 0x80, 0x00, 0x00, 0x60, 0xc0, 0x00, 0x00, 0x60, 0x60, 0x00, 0x00, 0x60, 0x30, 0x00, 0x00, 0x60, 0x18, 0x00, 0x00, 0x60, 0x0c, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

sudoku_array: dw s,u,d,o,k,u
bitboxes:
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 1 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 2 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 3 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 4 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 5 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 6 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 7 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 8 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 9 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 10 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 11 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 12 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 13 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 14 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 15 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 16 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 17 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 18 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 19 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 20 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 21 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 22 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 23 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 24 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 25 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 26 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 27 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 28 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 29 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 30 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 31 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 32 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 33 (34 bits used)
    db 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; Row 34 (34 bits used)


bitmap1:
     db 00000000b,00011100b,00000000b
     db 00000000b,00111100b,00000000b 
     db 00000000b,01111100b,00000000b 
     db 00000000b,11111100b,00000000b 
     db 00000001b,11111100b,00000000b 
     db 00000011b,11111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,00111100b,00000000b 
     db 00000000b,11111111b,00000000b 
     db 00000000b,11111111b,0000000b 
bitmap2:
    db 0x01, 0xff, 0x00, 0x03, 0xff, 0x80, 0x07, 0xff, 0xc0, 0x07, 0x01, 0xe0, 0x0e, 0x00, 0x70, 0x0c, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0xe0, 0x00, 0x01, 0xc0, 0x00, 0x03, 0x80, 0x00, 0x07, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x1c, 0x00, 0x00, 0x38, 0x00, 0x00, 0x70, 0x00, 0x00, 0xe0, 0x00, 0x01, 0xc0, 0x00, 0x07, 0x80, 0x00, 0x0f, 0xff, 0xf0, 0x0f, 0xff, 0xf0, 0x0f, 0xff, 0xf0, 0x00, 0x00, 0x00
bitmap3:
    db 0x00, 0x00, 0x00, 0x00, 0xff, 0x80, 0x01, 0xff, 0xc0, 0x03, 0xff, 0xc0, 0x03, 0x81, 0xe0, 0x03, 0x00, 0xf0, 0x00, 0x00, 0xf0, 0x00, 0x00, 0xf0, 0x00, 0x01, 0xf0, 0x00, 0x01, 0xe0, 0x00, 0x03, 0xc0, 0x00, 0x7f, 0x80, 0x00, 0x7f, 0x80, 0x00, 0x03, 0xc0, 0x00, 0x01, 0xe0, 0x00, 0x01, 0xf0, 0x00, 0x00, 0xf0, 0x00, 0x00, 0xf0, 0x03, 0x00, 0xf0, 0x03, 0x81, 0xe0, 0x03, 0xff, 0xc0, 0x01, 0xff, 0xc0, 0x00, 0xff, 0x80, 0x00, 0x00, 0x00
bitmap4:
    db 0x00, 0x03, 0xc0, 0x00, 0x07, 0xc0, 0x00, 0x0f, 0xc0, 0x00, 0x1f, 0xc0, 0x00, 0x3d, 0xc0, 0x00, 0x79, 0xc0, 0x00, 0xf1, 0xc0, 0x01, 0xe1, 0xc0, 0x03, 0xc1, 0xc0, 0x07, 0x81, 0xc0, 0x0f, 0x01, 0xc0, 0x1e, 0x01, 0xc0, 0x3c, 0x01, 0xc0, 0x78, 0x01, 0xc0, 0xff, 0xff, 0xf8, 0x7f, 0xff, 0xf8, 0x3f, 0xff, 0xf8, 0x00, 0x01, 0xc0, 0x00, 0x01, 0xc0, 0x00, 0x01, 0xc0, 0x00, 0x01, 0xc0, 0x00, 0x01, 0xc0, 0x00, 0x01, 0xc0, 0x00, 0x01, 0xc0
bitmap5:
    db 0x03, 0xff, 0xf0, 0x07, 0xff, 0xe0, 0x0f, 0xff, 0xc0, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0e, 0x7f, 0xc0, 0x0e, 0xff, 0xe0, 0x0f, 0xff, 0xf0, 0x0f, 0x00, 0x78, 0x00, 0x00, 0x38, 0x00, 0x00, 0x38, 0x00, 0x00, 0x38, 0x00, 0x00, 0x38, 0x0c, 0x00, 0x38, 0x0e, 0x00, 0x78, 0x0f, 0x00, 0xf8, 0x07, 0x81, 0xf0, 0x03, 0xc3, 0xe0, 0x01, 0xff, 0xc0, 0x00, 0xff, 0x80, 0x00, 0x00, 0x00
bitmap6:
    db 0x00, 0xff, 0x80, 0x01, 0xff, 0xc0, 0x03, 0xff, 0xe0, 0x03, 0xc0, 0xf0, 0x07, 0x80, 0x70, 0x0f, 0x00, 0x10, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0f, 0xff, 0xc0, 0x0f, 0xff, 0xe0, 0x0f, 0x81, 0xf0, 0x0f, 0x00, 0xf0, 0x0e, 0x00, 0x70, 0x0e, 0x00, 0x70, 0x0e, 0x00, 0x70, 0x0f, 0x00, 0xf0, 0x07, 0x81, 0xf0, 0x03, 0xff, 0xe0, 0x01, 0xff, 0xc0, 0x00, 0xff, 0x80
bitmap7:
    db 0x00, 0x00, 0x00, 0x03, 0xff, 0xf0, 0x07, 0xff, 0xf0, 0x0f, 0xff, 0xf0, 0x00, 0x00, 0xf0, 0x00, 0x00, 0xe0, 0x00, 0x01, 0xc0, 0x00, 0x01, 0xc0, 0x00, 0x03, 0x80, 0x00, 0x03, 0x80, 0x00, 0x07, 0x00, 0x00, 0x07, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x1c, 0x00, 0x00, 0x1c, 0x00, 0x00, 0x38, 0x00, 0x00, 0x38, 0x00, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0xe0, 0x00, 0x00, 0xe0, 0x00, 0x01, 0xc0, 0x00, 0x01, 0xc0, 0x0
bitmap9:
    db 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x01, 0xff, 0x80, 0x03, 0xff, 0xc0, 0x07, 0x81, 0xe0, 0x0f, 0x00, 0xf0, 0x0f, 0x00, 0xf0, 0x0f, 0x00, 0xf0, 0x0f, 0x00, 0xf0, 0x0f, 0x00, 0xf0, 0x0f, 0x81, 0xf0, 0x07, 0xff, 0xf0, 0x03, 0xff, 0xf0, 0x00, 0xfe, 0xf0, 0x00, 0x00, 0xf0, 0x00, 0x00, 0xf0, 0x00, 0x00, 0xf0, 0x00, 0x00, 0xf0, 0x0f, 0x00, 0xf0, 0x0f, 0x81, 0xe0, 0x07, 0xff, 0xc0, 0x03, 0xff, 0xc0, 0x01, 0xff, 0x80, 0x00, 0x00, 0x00
bitmap8:
    db 0x00, 0xff, 0x80, 0x01, 0xff, 0xc0, 0x03, 0xff, 0xe0, 0x07, 0x00, 0xf0, 0x0f, 0x00, 0xf0, 0x0e, 0x00, 0x70, 0x0e, 0x00, 0x70, 0x0e, 0x00, 0x70, 0x0f, 0x00, 0xf0, 0x07, 0x00, 0xe0, 0x03, 0x81, 0xc0, 0x03, 0xff, 0x80, 0x07, 0xff, 0xc0, 0x07, 0xff, 0xe0, 0x0f, 0x81, 0xf0, 0x0f, 0x00, 0xf0, 0x0e, 0x00, 0x70, 0x0e, 0x00, 0x70, 0x0e, 0x00, 0x70, 0x0f, 0x00, 0xf0, 0x0f, 0x81, 0xf0, 0x07, 0xff, 0xe0, 0x03, 0xff, 0xc0, 0x01, 0xff, 0x80


bitboxes1:
    db 00001111b, 11111111b, 11111111b, 11110000b ; Row 1
    db 00010000b, 00000000b, 00000000b, 00001000b ; Row 2
    db 00100000b, 00000000b, 00000000b, 00000100b ; Row 3
    db 01000000b, 00000000b, 00000000b, 00000010b ; Row 4
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 5
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 6
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 7
    db 10000000b, 00100000b, 00000000b, 00000001b ; Row 26
    db 10000000b, 01100000b, 00000000b, 00000001b ; Row 8
    db 10000000b, 11100000b, 00000000b, 00000001b ; Row 23
    db 10000001b, 11100000b, 00000000b, 00000001b ; Row 9
    db 10000011b, 11111111b, 11111110b, 00000001b ; Row 10
    db 100000001, 11100000b, 00000001b, 10000001b ; Row 11
    db 10000000b, 11100000b, 00000000b, 11000001b ; Row 12
    db 10000000b, 01100000b, 00000000b, 01100001b ; Row 13
    db 10000000b, 00100000b, 00000000b, 00110001b ; Row 14
    db 10000000b, 00000000b, 00000000b, 00110001b ; Row 15
    db 10000000b, 00000000b, 00000000b, 00110001b ; Row 16
    db 10000000b, 00000000b, 00000000b, 00110001b ; Row 17
    db 10000000b, 00000000b, 00000000b, 00110001b ; Row 18
    db 10000000b, 00000000b, 00000000b, 00110001b ; Row 19
    db 10000000b, 00000000b, 00000000b, 01100001b ; Row 20
    db 10000000b, 00000000b, 00000000b, 11000001b ; Row 21
    db 10000000b, 01111111b, 11111111b, 00000001b ; Row 22
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 24
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 25
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 27
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 28
    db 01000000b, 00000000b, 00000000b, 00000010b ; Row 29
    db 00100000b, 00000000b, 00000000b, 00000100b ; Row 30
    db 00010000b, 00000000b, 00000000b, 00001000b ; Row 31
    db 0001111b, 11111111b, 11111111b,  11110000b ; Row 32

bitboxes2:
    db 00001111b, 11111111b, 11111111b, 11110000b ; Row 1
    db 00010000b, 00000000b, 00000000b, 00001000b ; Row 2
    db 00100000b, 00000000b, 00000000b, 00000100b ; Row 3
    db 01000000b, 00000000b, 00000000b, 00000010b ; Row 4
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 5
    db 10000000b, 00000000b, 00100000b, 00000001b ; Row 6
    db 10000000b, 00000000b, 01010000b, 00000001b ; Row 7
    db 10000000b, 00000000b, 10001000b, 00000001b ; Row 8
    db 10000000b, 00000001b, 00000100b, 00000001b ; Row 9
    db 10000000b, 00000010b, 00000010b, 00000001b ; Row 10
    db 10000000b, 00000100b, 00000001b, 00000001b ; Row 11
    db 10000000b, 00001000b, 00000000b, 10000001b ; Row 12
    db 10000000b, 00010000b, 00000000b, 01000001b ; Row 13
    db 10000000b, 00110000b, 00000000b, 00100001b ; Row 14
    db 10000000b, 01001000b, 00000000b, 01000001b ; Row 15
    db 10000000b, 10000100b, 00000000b, 10000001b ; Row 16
    db 10000000b, 10000010b, 00000001b, 00000001b ; Row 17
    db 10000000b, 01000001b, 00000010b, 00000001b ; Row 18
    db 10000000b, 00100000b, 10000100b, 00000001b ; Row 19
    db 10000000b, 00010000b, 01001000b, 00000001b ; Row 20
    db 10000000b, 00001000b, 0110000b, 00000001b ; Row 21
    db 10000000b, 00000111b, 11100000b, 00000001b ; Row 22
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 23
    db 10000000b, 11111111b, 11111110b, 00000001b ; Row 24
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 25
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 26
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 27
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 28
    db 01000000b, 00000000b, 00000000b, 00000010b ; Row 29
    db 00100000b, 00000000b, 00000000b, 00000100b ; Row 30
    db 00010000b, 00000000b, 00000000b, 00001000b ; Row 31
    db 0001111b, 11111111b, 11111111b,  11110000b ; Row 32

bitboxes3:
    db 00001111b, 11111111b, 11111111b, 11110000b ; Row 1
    db 00010000b, 00000000b, 00000000b, 00001000b ; Row 2
    db 00100000b, 00000000b, 00000000b, 00000100b ; Row 3
    db 01000000b, 00000000b, 00000000b, 00000010b ; Row 4
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 5
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 6
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 7
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 8
    db 10000000b, 00000000b, 00010000b, 00000001b ; Row 9
    db 10000000b, 00000000b, 00101000b, 00000001b ; Row 10
    db 10000000b, 00000000b, 01000100b, 00000001b ; Row 11
    db 10000000b, 00000000b, 10000010b, 00000001b ; Row 12
    db 10000000b, 00000001b, 00000001b, 00000001b ; Row 13
    db 10000000b, 00000010b, 00000000b, 10000001b ; Row 14
    db 10000000b, 00000100b, 00000000b, 01000001b ; Row 15
    db 10000000b, 00001000b, 00000000b, 10000001b ; Row 16
    db 10000000b, 00010000b, 00000001b, 00000001b ; Row 17
    db 10000000b, 00100000b, 00000010b, 00000001b ; Row 18
    db 10000000b, 01000000b, 00000100b, 00000001b ; Row 19
    db 10000000b, 10100000b, 00001000b, 00000001b ; Row 20
    db 10000000b, 10010000b, 00010000b, 00000001b ; Row 21
    db 10000000b, 10001000b, 00100000b, 00000001b ; Row 22
    db 10000000b, 10000100b, 01000000b, 00000001b ; Row 23
    db 10000000b, 10000010b, 10000000b, 00000001b ; Row 24
    db 10000000b, 11111111b, 00000000b, 00000001b ; Row 25
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 26
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 27
    db 10000000b, 00000000b, 00000000b, 00000001b ; Row 28
    db 01000000b, 00000000b, 00000000b, 00000010b ; Row 29
    db 00100000b, 00000000b, 00000000b, 00000100b ; Row 30
    db 00010000b, 00000000b, 00000000b, 00001000b ; Row 31
    db 0001111b, 11111111b, 11111111b,  11110000b ; Row 32

bitboxes4:
    db 00001111b,11111111b,11111111b,11110000b
    db 00010000b,00000000b,0000000b,00001000b
    db 00100000b,00000000b,0000000b,00000100b
    db 01000000b,00000000b,0000000b,00000010b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 10000000b,00000000b,0000000b,00000001b
    db 01000000b,00000000b,0000000b,00000010b
    db 00100000b,00000000b,0000000b,00000100b
    db 00010000b,00000000b,0000000b,00001000b
    db 0001111b,11111111b,11111111b,11110000b