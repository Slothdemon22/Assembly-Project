timerunhook: dw 0


timer:
    push bp
    mov bp, sp
    push ax
    push bx
    push dx
    push cx

    ; Handle blinking logic (every 5 ticks)
    inc byte [blinkCount]
    cmp byte [blinkCount], 5
    jnz checkMainTimer
    
    ; Reset blink counter
    mov byte [blinkCount], 0
    
    ; Toggle blink state
    cmp word [blink], 0
    jnz clearCursorState
    
    ; Set cursor visible
    mov word [blink], 1
    push bitboxes4
    push 32
    push word [rowOffset]
    push word [colOffset]
    call clearCursor
    jmp checkMainTimer
    
clearCursorState:
    ; Set cursor invisible
    mov word [blink], 0
	push word 1
    push bitboxes4
    push 32
    push word [rowOffset]
    push word [colOffset]
    call functionGnericBitmaps

checkMainTimer:
    mov ah, 0x02         ; Set cursor position function
    mov bh, 0            ; Page number
    mov dh, 0            ; Row 0
    mov dl, 0            ; Column 0
    int 0x10
    ; Main timer logic (every 18 ticks)
    inc byte [tickCount]
    cmp byte [tickCount], 18
    jne endTimer
	inc word [timerunhook]


    ; Reset tickCount and increment seconds
    mov byte [tickCount], 0
    inc byte [seconds]
    
    ; Check if seconds reached 60
    cmp byte [seconds], 60
    jne displayTime
    
    ; Reset seconds and increment minutes
    mov byte [seconds], 0
    inc byte [minutes]

displayTime:
    ; Set cursor position
    mov ah, 0x02
    mov bh, 0
    mov dh, 0
    mov dl, 52
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

endTimer:
    mov al, 0x20
    out 0x20, al         ; Send EOI to PIC
    
    pop cx
    pop dx
    pop bx
    pop ax
    pop bp
    iret
	
kbsir:
    push bp
    mov bp, sp
    push ax
   
    in al, 0x60         ; Read the keycode from keyboard buffer

Undo:
    cmp al,0x16
jnz shift

jmp end


shift:
        ; Check for Left Shift press (0x2A)
    cmp al, 0x2A
    je set_toggle_on

    ; Check for Left Shift release (0xAA)
    cmp al, 0xAA
    je set_toggle_off

    ; Check for number scan codes (0x02 to 0x0B)
    cmp al, 0x02
    jb Tab
    cmp al, 0x0B
    ja Tab

    ; If toggle is on, process number
    cmp byte [toggle], 1
    jne Tab

    call checkNumberNotes

    jmp end

set_toggle_on:
    mov byte [toggle], 1
    jmp Tab

set_toggle_off:
    mov byte [toggle], 0
    jmp Tab

Tab:
   cmp al,0x0F
   jnz backSpace
   call HintFunction
   jmp end

backSpace:
    cmp al, 0Eh          ; Check for Backspace key
    jnz rightMatch
    call checkNonremoveableNUmber
    cmp dx,0
    jz end
    call removeNumber
    call clear_screenNotes
    call clr_box_Util
    call updateCardCounterOnScreen

    mov ax, 0A97h        ; Frequency for Backspace
    call play_tone
    jmp end

rightMatch:
    cmp al, 4Dh         ; Check for Right arrow key
    jnz leftMatch
    cmp byte [cs:colCount], 8    ; Changed from 9 to 8 for 0-8 range
    je end
    call clr_cursor_Util

    mov ax, [cs:rowOffset]
    add ax, 45                   ; Update position
    mov [cs:rowOffset], ax
    inc byte [cs:colCount]
    mov ax, 1FB4h
    call play_tone
    call printRowColUtil

    jmp draw_bitmap

leftMatch:
    cmp al, 4Bh         ; Check for Left arrow key
    jnz downMatch
    cmp byte [cs:colCount], 0    ; Changed from 1 to 0 for leftmost position
    je end
    call clr_cursor_Util

    mov ax, [cs:rowOffset]
    sub ax, 45
    mov [cs:rowOffset], ax
    dec byte [cs:colCount]
    mov ax, 152Fh
    call play_tone
    call printRowColUtil
    jmp draw_bitmap

downMatch:
    cmp al, 50h         ; Check for Down arrow key
    jnz upMatch
    cmp byte [cs:rowCount], 8    ; Correct - checking for bottom position
    je end
    call clr_cursor_Util

    mov ax, [cs:colOffset]
    add ax, 45
    mov [cs:colOffset], ax
    inc byte [cs:rowCount]
    mov ax, 0A97h
    call play_tone
    call printRowColUtil
    jmp draw_bitmap

upMatch:
    cmp al, 48h         ; Check for Up arrow key
    jnz checkNumber
    cmp byte [cs:rowCount], 0    ; Correct - checking for top position
    je end
    call clr_cursor_Util

    mov ax, [cs:colOffset]
    sub ax, 45
    mov [cs:colOffset], ax
    dec byte [cs:rowCount]
    mov ax, 1FB4h
    call play_tone
    call printRowColUtil
    jmp draw_bitmap


    checkNumber:
    sub al,1
    mov byte [cs:inputNum],al
     
     call checkNumberUtil

draw_bitmap:
    call draw_Bitmap_Util
    jmp end

end:
    pop ax
    pop bp
    jmp far [cs:oldKeyboardIsr]
;iret

	