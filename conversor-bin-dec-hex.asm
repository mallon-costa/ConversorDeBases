;1 PROJETO
;MICROPROCESSADORES E MICROCONTROLADORES
;PROFESSOR: ELTON ALVES

;ALUNOS: LUANA BATISTA, MANOEL MALON COSTA,JOSE ARTHUR ALVES
;CONVERSOR DE BASES NUMERICAS 


INCLUDE 'emu8086.inc'

org 100h
.DATA
contador DW 0d 
contador2 DW 0d
msg DB 'Numero em hexadecimal: ', 0
caractA DB 41h, 0
caractB DB 42h, 0
caractC DB 43h, 0
caractD DB 44h, 0 
caractE DB 45h, 0
caractF DB 46h, 0

.CODE
;**************** MENU ******************* 
menu: 
CALL CLEAR_SCREEN
PRINTN '**************************************************'
PRINTN '***** CONVERSOR BINARIO-DECIMAL-HEXADECIMAL ******'
PRINTN '**************************************************'
PUTC 13d 
PUTC 10d 
PRINTN '(1) Conversao Binario->Decimal' 
PRINTN '(2) Conversao Binario->Hexadecimal'
PRINTN '(3) Conversao Decimal->Binario'
PRINTN '(4) Conversao Decimal->Hexadecimal' 
PUTC 13d 
PUTC 10d
PUTC 13d 
PUTC 10d
PRINT 'Selecione a opcao desejada: ' 
CALL SCAN_NUM                       
PUTC 13d
PUTC 10d
PUTC 13d
PUTC 10d


CMP CX, 1d
JE bindec
JL inv
CMP CX, 2d
JE binhex
CMP CX, 3d
JE decbin
CMP CX, 4d
JE dechex
JG inv



;**************** OPCAO (1) *******************
bindec PROC 
CALL CLEAR_SCREEN
PRINTN '********* CONVERSAO BINARIO->DECIMAL *********'

PUTC 13d 
PUTC 10d 
PRINT 'Digite o numero em binario (ate 4 digitos): '
CALL SCAN_NUM
MOV AX, CX
MOV BL, 10d
MOV CX, 0d
MOV DX, 0d

divisaoSuc:
    DIV BL
    MOV DL, AH
    PUSH DX
    MOV AH, 0d
    INC CX
    CMP AL, 0d
    JNE divisaoSuc 
    JE cont
        
cont:
MOV DL, 0d
MOV BH, 0d
MOV BL, 0d
MOV DX, CX
MOV AL, 1d
MOV BL, 2d

CMP CX, 1d
JE cont2

DEC CX
mult:
MUL BL

LOOP mult
cont2:

MOV CX, DX
MOV BL, AL
MOV AL, 0d

MOV AL, BL
MOV BL, 2d 

retiraPilha:
    MOV SI, AX
    POP DX
    MUL DL
    ADD BH,AL
    MOV AX, SI 
    MOV AH, 0d
    DIV BL    
    
LOOP retiraPilha 

PUTC 13d 
PUTC 10d
PRINT 'Numero em decimal: ' 
MOV AH, 0d 
MOV AL, BH
CALL PRINT_NUM_UNS
 
CALL finalizar   
    
RET                  ; return to caller.
bindec ENDP
 
 
 
;**************** OPCAO (2) *******************
binhex PROC 
CALL CLEAR_SCREEN
PRINTN '********* CONVERSAO BINARIO->HEXADECIMAL *********'

PUTC 13d 
PUTC 10d
PRINT 'Digite o numero em binario (ate 4 digitos): '
CALL SCAN_NUM
MOV AX, CX
MOV BL, 10d
MOV CX, 0d
MOV DX, 0d

divisaoSuc2:
    DIV BL
    MOV DL, AH
    PUSH DX
    MOV AH, 0d
    INC CX
    CMP AL, 0d
    JNE divisaoSuc2 
    JE cont3
        
cont3:
MOV DL, 0d
MOV BH, 0d
MOV BL, 0d
MOV DX, CX
MOV AL, 1d
MOV BL, 2d

CMP CX, 1d
JE cont4

DEC CX
mult2:
MUL BL

LOOP mult2
cont4:

MOV CX, DX
MOV BL, AL
MOV AL, 0d

MOV AL, BL
MOV BL, 2d 

retiraPilha2:
    MOV SI, AX
    POP DX
    MUL DL
    ADD BH,AL
    MOV AX, SI 
    MOV AH, 0d
    DIV BL    
    
LOOP retiraPilha2 
 
MOV AH, 0d 
MOV AL, BH

JMP convdechex
 
CALL finalizar
RET                   ; return to caller.
binhex ENDP

;**************** OPCAO (3) *******************
decbin PROC
CALL CLEAR_SCREEN
PRINTN '***** CONVERSAO DECIMAL->BINARIO *****'

PUTC 13d 
PUTC 10d 
PRINT 'Digite o numero em decimal: '
CALL SCAN_NUM  
MOV AX, CX
MOV BL, 2           
                  
divisaoSuc3:
    INC contador
    DIV BL
    MOV DH, AH
    PUSH DX
    CMP AL, 1d
    MOV AH, 0d
    JGE divisaoSuc3
    JL cont5
cont5: 
    MOV CX, contador

PUTC 13d
PUTC 10d

PRINT 'Numero em binario: '
  
impressao:
    POP DX 
    MOV DL, 0d
    MOV BL, DH
    MOV BH, 0d
    MOV AX, BX
    CALL PRINT_NUM_UNS
LOOP impressao

CALL finalizar
RET                   ; return to caller.
decbin ENDP



;**************** OPCAO (4) *******************
dechex PROC
CALL CLEAR_SCREEN
PRINTN '***** CONVERSAO DECIMAL->HEXADECIMAL *****'

PUTC 13d 
PUTC 10d 
PRINT 'Digite o numero em decimal: '
CALL SCAN_NUM
MOV AX, CX
convdechex:
MOV BL, 16d

divisao:
    INC contador2
    DIV BL
    MOV DH, AH
    PUSH DX
    CMP AL, 15d
    MOV AH, 0d
    JGE divisao
    JL cont6

cont6: 
    MOV CL, AL
    MOV AH, CL
    MOV AL, 0d
    MOV CX, 0d
    CMP AH, 0d
    JE movContador
    
    colocaPilha:
    INC contador2
    PUSH AX
    
    movContador:
    MOV CX, contador2
    
PUTC 13d
PUTC 10d 

LEA SI, msg
CALL PRINT_STRING

impressao2:
    POP DX 
    MOV DL, 0d
    
    num10:
        CMP DH, 0Ah
        JE apresentaA
        JMP num11
        
        apresentaA:
        LEA SI, caractA
        CALL PRINT_STRING
        JMP verifica
    
    num11:
        CMP DH, 0Bh
        JE apresentaB
        JMP num12
        
        apresentaB:
        LEA SI, caractB
        CALL PRINT_STRING
        JMP verifica
    
    num12:
        CMP DH, 0Ch
        JE apresentaC
        JMP num13
        
        apresentaC:
        LEA SI, caractC
        CALL PRINT_STRING
        JMP verifica
        
    num13:
        CMP DH, 0Dh
        JE apresentaD
        JMP num14
        
        apresentaD:
        LEA SI, caractD
        CALL PRINT_STRING
        JMP verifica

    num14:
        CMP DH, 0Eh
        JE apresentaE
        JMP num15
        
        apresentaE:
        LEA SI, caractE
        CALL PRINT_STRING
        JMP verifica
        
    num15:
        CMP DH, 0Fh
        JE apresentaF
        JMP apresentaNum
        
        apresentaF:
        LEA SI, caractF
        CALL PRINT_STRING
        JMP verifica
    
    apresentaNum:
    MOV BL, DH
    MOV BH, 0d
    MOV AX, BX
    CALL PRINT_NUM_UNS
    
    verifica:
    DEC CX
    CMP CL, 0d
    JNE impressao2
      
CALL finalizar
RET                   ; return to caller.
dechex ENDP


;************* OPCAO INVALIDA *****************
inv PROC  
PUTC 13d PUTC 10d 
PUTC 13d PUTC 10d
PRINTN 'Opcao invalida'
PUTC 13d PUTC 10d
CALL menu
RET                   ; return to caller.
inv ENDP

final:
finalizar PROC
INT 20h
RET                   ; return to caller.
finalizar ENDP

DEFINE_SCAN_NUM
DEFINE_PRINT_NUM_UNS
DEFINE_PRINT_STRING 
DEFINE_CLEAR_SCREEN


