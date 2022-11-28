.MODEL SMALL


.STACK 100H


.DATA 
X DB ?
GOTLEFT DB 10
CRETURN DB 13

INPUTPROMT db 'Enter characters : $' 
OUTPROMT db 'Corresponding value is : $'

.CODE

MAIN PROC  
    
    MOV AX , @DATA
    MOV DS , AX 
    
    LEA DX , INPUTPROMT
    
    
	MOV AH,09H 
	INT 21H 
	
	
	
	MOV AH , 1 
	INT 21H ; first input done 
	MOV CL , AL ; first input is now in CL 
	
	WHILE: 
	    MOV AH,1 
	    INT 21H 
	    ;second input is in AL 
	    
	    
	    ;first have to check if it is in rules 
	     CMP AL , 'a' 
	     JNGE END_LOOP
	     CMP AL,'z'
	     JNLE END_LOOP
	    
	    
	    
	    
	    ;NOW TIME TO COMPARE AND STORE THE SMALLEST ONE IN A VARIABLE 
	    
	    CMP AL , CL 
	    JNGE storeAL  ;means AL < CL  
	    MOV X,CL 
	    JMP RESTORE_THE_SMALLEST
	    
	    
	    
	    storeAL:
	        MOV X,AL  
	        
	    RESTORE_THE_SMALLEST:
	        MOV CL , X  
	        
	    JMP WHILE;  
	        
	
	END_LOOP:
	
	
	
	
	;NOW X HAS THE SMALLEST LETTER 
	
	
	
	
    MOV DL , GOTLEFT
    MOV AH,2   
    INT 21H
    
    
    MOV DL , CRETURN
    MOV AH,2   
    INT 21H
    
	 
        
    LEA DX , OUTPROMT
    
    
	MOV AH,09H 
	INT 21H
	
	
	MOV DL , X 
	SUB DL , 32
	MOV AH , 2 
	INT 21H
    
   
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN