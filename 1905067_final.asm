.MODEL SMALL 
.STACK 100H 
.DATA
INV DW ?
N DW ?
M DW 0H    
GOTLEFT DB 10
CRETURN DB 13
CR EQU 0DH
LF EQU 0AH

INI DW 0
SEC DB ?
TEMP DW ?
COUNT DW ? 
NUMBER DB '00000$'
promt DB 'inversion point : $'
full DB  ' ',13,10,'$'
endl db 13,10,'$'
NUMBERS DW 100 DUP(0)  
SORTED DW 100 DUP(0)

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    
    ;input---stored in N   
    
    CALL INPUT
    
    ;------input finished
    
    ;Write code
     lea SI,NUMBERS
     MOV CX,N
     MOV M,CX
    INPUTLOOP:
     CMP CX,0
     JE THEN
     dec CX
     CALL INPUT 
     MOV DX,N
     MOV [SI],DX
     INC SI
     inc SI
     JMP INPUTLOOP 
    
    
    THEN:
    lea dx, promt
        mov ah, 09h
         int 21h
        CALL FIND_INV_POINT;
        
       
        MOV AX , INV
          
        CALL SHOW
    
      
      CALL SORT
    
    
    
    
    AFTER:
        ; PRINT
    
    lea dx, full
    mov ah, 09h
    int 21h
    
     lea SI,SORTED
     MOV CX,M
     OUTPUT_LOOP:
     CMP CX,0
     JE AFTER1
     dec CX   
     MOV AX,[SI] 
     CALL SHOW
     INC SI
     INC SI
     JMP OUTPUT_LOOP  
     AFTER1:
    ;Output starts--- prints AX
    ;CALL PRINT
    ;----Output ends
 
     
      
    
    
   
	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP  

SORT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH INV 
    
    MOV COUNT,0
    MOV INI , 0   
    
    MERGE:
    MOV SI , INI 
    MOV AX , NUMBERS[SI]
    
    MOV SI , INV
    
    MOV BX , NUMBERS[SI]
    
    CMP AX,BX
    JG IGNORE 
    MOV SI  , COUNT
    MOV SORTED[SI] , AX
    INC COUNT
     INC COUNT 
    INC INI
    JMP MERGE
    IGNORE:  
    MOV SI,COUNT
      MOV SORTED[SI] , BX
      INC COUNT 
       INC COUNT 
      INC INV
    
    
    
    
    POP INV
    POP SI
    POP CX
    POP BX
    POP AX
    RET
SORT ENDP



FIND_INV_POINT PROC
   PUSH AX 
   PUSH BX
   PUSH CX
   PUSH SI
   MOV SI , 0
   MOV INV , 0 
   JOTOKK:
    MOV AX , NUMBERS[SI] 
    INC SI
    INC SI
    MOV BX , NUMBERS[SI]  
    DEC SI
    DEC SI
    CMP AX,BX
    JG  OUTSIDE
    INC SI
    INC SI 
    INC INV
    JMP JOTOKK
   OUTSIDE:
   POP SI
   POP CX
   POP BX
   POP AX 
    RET
FIND_INV_POINT ENDP 









SHOW PROC  
    PUSH DX
    PUSH CX
    PUSH AX
    PUSH SI
    LEA SI , NUMBER 
    ADD SI  , 5 
    UNTIL:
        DEC SI ; 
        MOV DX,0 ; NOW DX IS 00000000 AND AX HAS THE FULL NUMBER 
        MOV CX , 10 ;
        DIV CX ; SO DX:AX IS DIVIDED BY 10 , REM IS IN DX ,ACTUALLY ON DL
        ;THE QUOTIENT IS IN AX 
        
        ADD DL,'0'
        MOV [SI] , DL 
        
        CMP AX , 0
        JNE UNTIL ;
        
        MOV DX , SI  
       
        MOV AH , 9 
        INT 21H 
        MOV DL , GOTLEFT
    MOV AH,2   
    INT 21H
    
    
    MOV DL , CRETURN
    MOV AH,2   
    INT 21H 
     POP SI
     POP AX 
     POP CX
     POP DX   
        RET
SHOW ENDP  

INPUT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
 ; fast BX = 0
    XOR BX, BX
    
    INPUT_LOOP:
    ; char input 
    MOV AH, 1
    INT 21H
    
    ; if \n\r, stop taking input
    CMP AL, CR    
    JE END_INPUT_LOOP
    
    CMP AL, 20H
    JE END_INPUT_LOOP
    
    ; fast char to digit
    ; also clears AH
    AND AX, 000FH
    
    ; save AX 
    MOV CX, AX
    
    ; BX = BX * 10 + AX
    MOV AX, 10
    MUL BX
    ADD AX, CX
    MOV BX, AX
    JMP INPUT_LOOP
    
    END_INPUT_LOOP:
    MOV N, BX
    ; NEWLINE
    lea dx, endl
    mov ah, 09h
    int 21h
      
     
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET

INPUT ENDP 

END MAIN