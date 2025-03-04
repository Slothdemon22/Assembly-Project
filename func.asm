[org 0x0100]
jmp start          ; Jump to the start of the program
%include "dataArrays.asm"
%include "utils.asm"
%include "checkLogic.asm"
%include "ISR.asm"
%include "BitmapsPrint.asm"
%include "StringPrinting.asm"
%include "BoxPrinting.asm"
%include "random.asm"









start:
    mov ax, 0x0012       ; Set video mode to 640x480 16-color graphics mode
    int 0x10

;	jmp skipStart
 ;   jmp finsh
	call backGroundPrintingUtil
	call printScreenStartUtil

	mov ah,0
	int 16h
	
skiplabel:
	
	call clr_screen
	call backGroundPrintingUtil
    call printInstructionScreen


   
skipStart:
	call generateRandomArray
    push word[Xindex]
    push word[Yindex]
    call fillTheBoard
inputValidate:
         
    mov ah, 0
    int 0x16
    cmp al, '1'
    jne cmpMedium
    mov word [numberIndexes], 40
    jmp vga
cmpMedium:
    cmp al, '2'
    jne cmpHard
    mov word [numberIndexes], 35
    jmp vga
cmpHard:
    cmp al, '3'
    jne inputValidate
    mov word [numberIndexes], 20
vga:
    push ax
    call fillUser
    ; Set video mode
	call clr_screen
	call updateCardCount
	call updatNonRemovableNumber

	call backGroundPrintingUtil
	
    ; Initialize counters
 
	call printArray


 
    push word [boardColor]
    call printSudokoBox

    call printMessagesUtil

    call printTextOnMainGridScreenUtil

    ; This function uses address bitmapsDimension, x, and y coordinates to draw erase undo pencil 32x32 bitmaps
    call printBoxesGridScreen
    ; End of this part

    call updateCardCounterOnScreen

    ; This function prints count of numbers inside the notes that hold numbers
    call printBitBoxesNumbers

    ; End of this part

    ; ----- Print text messages -----
    mov ax, 0
    mov es, ax
    cli
    ; Save keyboard interrupt vector
    call hookTimerAndKeyboardUtil
    sti

endLoop:
    cmp word [timerunhook],0
	jnz skipunhookviva
	
	;call unhookTimerAndKeyboardUtil
	
skipunhookviva:
    cmp word [MistakesCounter],3
	jz LoseGame
    mov ah, 0
    int 16h

    call CompleteBoardChecker
    cmp dx, 1
    jz WinGame

	
    cmp al, 27
    jnz endLoop
    call autoCompletion

LoseGame:
  
     call clr_cursor_Util
	 call printGameOverMessagesScreen

     call loseBitmapUtil
	 jmp EndGame
	
	
WinGame:

	 call printGameOverMessagesScreen
	 call WinBitmapUtil



	 jmp EndGame
	
	
EndGame:
	call clr_cursor_Util
    cli
	;======unhooking=====;
    call unhookTimerAndKeyboardUtil
	sti
    call printEndGameMessgaesUtil

    
	mov ah, 0
    int 16h

 
finsh:
    call backGroundPrintingUtil
    call clr_screen
    call PrintEnd

    ; Unhooking interrupts
   
	
	mov ah,0
	int 16h
    mov ax, 03h         ; Set AX to 03h for 80×25 text mode
    int 10h
    mov ax, 0x4C00      ; Exit program
    int 0x21
