fillTheBoard:
    push bp
    mov bp, sp
    push cx
    push bx
    push ax
    push dx

    ;base cases
    cmp word[bp+4], 9
    je case1

    case2:
        cmp word[bp+6], 9
        jne againandagain
        mov byte[returnFlagFillBoard], 1
        jmp return

    againandagain:
    mov cx, 1
    checkNextValue:
    push cx
    push word[bp+4]
    push word[bp+6]
    call insertNumber

    cmp word[returnFlagInsertNum], 1
    jne increment
    ;a[i][j] = cx
        mov bx, boardArraySolution
        push bx
        mov bx, 9
        mov ax, [bp + 6]
        mul bx
        pop bx
        add bx, ax
        add bx, [bp + 4]
        mov dx, cx
        mov [bx], dx

    ;fillboard(row, col+1)
        add word[bp+4], 1
        push word [bp+6]
        push word[bp+4]
        call fillTheBoard 
        cmp byte[returnFlagFillBoard], 1
        je return

    ;a[i][j] = 0
        sub word[bp+4], 1
        cmp word[bp+4], 0
        jb SomeCase
        basil:
        mov bx, boardArraySolution
        push bx
        mov bx, 9
        mov ax, [bp + 6]
        mul bx
        pop bx
        add bx, ax
        add bx, [bp + 4]
        mov word[bx], 0

    increment:
        inc cx
        cmp cx, 10
        jne checkNextValue
    return:
        pop dx
        pop ax
        pop bx
        pop cx
        pop bp
        ret 4

    case1:
        mov word[bp+4], 0
        add word [bp+6], 1
        jmp case2

    SomeCase:
        sub word[bp+6], 1
        mov word[bp+4], 8
        jmp basil

insertNumber:
    push bp
    mov bp, sp

    push cx
    push ax
    push si
    push di
    push bx


    mov ax, [bp + 8]    ;bp+8 = number

    xor cx, cx
    rowLoop:      
        mov bx, boardArraySolution                 ;this loop checks the whole row
        ;add bx, 9
        push bx
        mov bx, 9
        push ax
        mov ax, [bp + 4]       ;xindex
        mul bx
        mov di, ax
        pop ax
        pop bx
        add bx, di
        add bx, cx            ;array[i][j]
        cmp al, [bx]
        je returnFalseInsertNumber
        inc cx
        cmp cx, 9
        jne rowLoop


    xor cx, cx
    columnLooop:    
        mov bx, boardArraySolution 
        ;add bx, 9
                            ;this loop checks the whole column
        push ax    ;value
        mov ax, cx
        push bx
        mov bx, 9
        mul bx


        pop bx
        add bx, ax
        add bx, [bp + 6]  ;y index
        pop ax
        cmp al, [bx]
        je returnFalseInsertNumber
        inc cx
        cmp cx, 9
        jne columnLooop

    ;the loop starting from here checks the subgrid

    mov bx, 3
    mov dx, 0
    mov ax, [bp + 6]     ;col number
    div bx
    mov dx, 3
    mul dx   

    mov di, ax    ;di = j

    mov bx, 3
    mov dx, 0
    mov ax, [bp  + 4]    ;Row number
    div bx
    mov dx, 3
    mul dx

    mov si, ax    ;si = i


        ;initialization
    xor cx, cx
    mov dx, [bp + 8]
    mov cx, si
    outerLoop:
                ;initialization
        push cx
        mov cx, di
        innerLoop:
                    ;loop body
            mov bx, boardArraySolution
            push bx
            mov ax, 0
            mov bx, 9
            mov ax, si ;i
            mul bx
            add ax, cx ;j
            ;add ax, cx
            pop bx
            add bx, ax
            mov dx, [bp + 8]
            cmp dl, [bx]
            je returnSubgrid
                ;increment and condition
            inc cx
            mov ax, di
            add ax, 3
            cmp cx, ax
            jb innerLoop

        ;incremeent and condition
        pop cx
        inc si
        inc cx
        cmp cx, [bp + 4]
        jbe outerLoop


        ;move number into that array position
        

        mov word[returnFlagInsertNum], 1
        functionEnding:
        pop bx
        pop di
        pop si
        pop ax
        pop cx

        pop bp
        ret 6

    returnSubgrid:
        pop si
    returnFalseInsertNumber:
        mov word[returnFlagInsertNum], 0
        jmp functionEnding

generateRandomArray:
    push bp
    push cx
    push ax
    push bx
    push dx


    mov bp, 0
    mov bx, 9
    
    looop:
        mov di, 0
        rdtsc
        mov dx, 0
        mov ah, 0
        div bx
        inc dx
        myloop:
        cmp dl, [boardArraySolution + di]
        jz looop
        inc di
        cmp di, bp
        jbe myloop

        mov byte[boardArraySolution+bp], dl
            inc bp
            cmp bp, 9
            jne looop
        
    pop dx
    pop bx
    pop ax
    pop cx
    pop bp
    ret

generateRandomUserIndexes:
    push bp
    push cx
    push ax
    push bx
    push dx


    mov bp, 0
    mov bx, 81
                        ;Easy
    looop1:
        mov di, 0
        rdtsc
        mov dx, 0
        mov ah, 0
        div bx
        inc dx
        myloop1:
        cmp dl, [userIndexesEasy + di]
        jz looop1
        inc di
        cmp di, bp
        jbe myloop1

        mov byte[userIndexesEasy+bp], dl
            inc bp
            cmp bp, [numberIndexes]
            jne looop1

    ; mov bp, 0
                        ;Hard (goves hardddd)
        ; looop2:
        ; mov di, 0
        ; rdtsc
        ; mov dx, 0
        ; mov ah, 0
        ; div bx
        ; inc dx
        ; myloop2:
        ; cmp dl, [userIndexesEasy + di]
        ; jz looop1
        ; inc di
        ; cmp di, bp
        ; jbe myloop2

        ; mov byte[userIndexesHard+bp], dl
        ;     inc bp
        ;     cmp bp, 14
        ;     jne looop2
        
    pop dx
    pop bx
    pop ax
    pop cx
    pop bp
    ret

fillUser:
    push bp
    mov bp, sp
    push ax
    push di
    push dx

    call generateRandomUserIndexes
    ; cmp word[bp + 4], 0
    ; je hard                     ;jump to hard mode
                                ;else stay in easy mode
    mov si, 0
    easy:
        mov di, 0
        mov dx, 0
        mov dl, [userIndexesEasy + si]
        mov di, dx
        mov al, [boardArraySolution + di]
        mov [boardArray + di], al
        inc si
        cmp si, [numberIndexes]
        jne easy
        jmp exit

    ; mov si, 0
    ; hard:
    ;     mov di, 0
    ;     mov dx, 0
    ;     mov dl, [userIndexesHard + si]
    ;     mov di, dx
    ;     mov al, [boardArraySolution + di]
    ;     mov [boardArray + di], al
    ;     inc si
    ;     cmp si, 14
    ;     jne hard

    exit:
        pop dx
        pop di
        pop ax
        pop bp
        ret 2

clrscr:
    push ax 
    push es 
    push di 
    push cx

    mov ax , 0xb800
    mov es, ax
    mov di, 0
    mov ax, 0x0720
    mov cx, 2000
    cld
    rep stosw 

    pop cx 
    pop di
    pop es
    pop ax  
    ret 

printGridText:
    push bp
    mov bp, sp
    push si
    push cx
    push dx
    push ax
    push di

    ; Set up video memory segment
    mov ax, 0xB800
    mov es, ax
    xor di, di             ; Start at the top-left corner of the screen (row 0, column 0)

    mov si, 0              ; Index into array1
    mov cx, 9              ; Number of rows

row_loop:
    push cx                ; Save row count
    mov cx, 9              ; Number of columns

col_loop:
    xor ax, ax
    mov al, [boardArraySolution + si]  ; Get the value from array1
    cmp al, 0              ; Check if zero
    je skipZero

    add al, '0'            ; Convert number to ASCII
    mov ah, 0x07           ; White text attribute
    mov [es:di], ax        ; Write character and attribute to video memory

skipZero:
    inc si
    add di, 2              ; Move to the next character in the row
    loop col_loop          ; Process all columns

    add di, (160 - 18)     ; Move to the next row in video memory (80x2 - 9x2 bytes)
    pop cx                 ; Restore row count
    loop row_loop          ; Process all rows

    ; Cleanup
    pop di
    pop si
    pop cx
    pop dx
    pop ax
    pop bp
    ret



	
   