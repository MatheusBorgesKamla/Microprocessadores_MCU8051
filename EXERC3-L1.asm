	ORG     0000H
        SJMP    PROG
        
        ORG    000BH
        SJMP    TIM0

TIM0:
        CLR    EA
        SETB	25H.0
        MOV     TH0, #3CH
        MOV    TL0, #0AFH
        SETB    EA
        RETI

PROG:
        MOV    TMOD, #00000001B
        MOV    TH0, #3CH
        MOV    TH1, #0AFH
        MOV 	25H, #00
        MOV 	IE, #1000010B
        MOV    A, #100
        SETB    TR0
       
LOOP:	JNB	25H.0, $
	CLR	25H.0
	DJNZ	A, LOOP
FIM:	SJMP	FIM 
        END