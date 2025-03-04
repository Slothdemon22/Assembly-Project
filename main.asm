org 0x0100

jmp start

str: db 'Hello, World!',0 ; Define the string, terminated with '$'

start:
    ; Clear the screen directly
    mov ax, 0xB800         ; Video memory segment for text mode
    mov es, ax             ; Load the segment into ES
    xor di, di             ; Start at offset 0
    mov cx, 2000           ; 80 columns x 25 rows = 2000 characters

clear_loop:
    mov al, ' '            ; Character: space
    mov ah, 0x07           ; Attribute: white on black
    stosw                  ; Write AL and AH to ES:[DI], increment DI by 2
    loop clear_loop        ; Repeat until CX is 0

    ; Set cursor position to the top-left corner (row 0, column 0)
    mov ah, 0x02           ; BIOS function to set cursor position
    mov bh, 0x00           ; Video page number (0 for default)
    mov dh, 0x10         ; Row number (top row)
    mov dl, 0x00          ; Column number (leftmost column)
    int 0x10               ; Call BIOS interrupt

    ; Print the string
    mov dx,  str     ; Load the address of the string into DX
    mov ah, 0x09           ; DOS interrupt for printing a string
    int 0x21               ; Call DOS interrupt

    ; Terminate the program
    mov ax, 0x4C00         ; Terminate program
    int 0x21               ; Call DOS interrupt
