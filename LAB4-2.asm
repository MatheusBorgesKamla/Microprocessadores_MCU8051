	ORG 0
	SJMP PROG

	ORG 0013H
	SJMP EXT1

	ORG 001BH
	SJMP TIM1

PROG:	SETB EX1
	SETB ET1
	SETB IT1
RESET:	MOV P1, #00H
	MOV TMOD, #01010000B
	MOV 25H, #00H
	MOV TH1, #0F8H ;VAI COMECAR CONTANDO 20000
	MOV TL1, #2FH 
	SETB EA
	SETB TR1

VERDE:	JB 25H.1, AMARE
	JB 25H.3, RESET
	SETB 25H.0
	SJMP VERDE

AMARE:	JB 25H.2, VERME
	JB 25H.3, RESET
	SETB 25H.1
	CLR 25H.0
	SJMP AMARE

VERME:	JB 25H.0, FIM
	JB 25H.3, RESET
	SETB 25H.2
	CLR 25H.1
	SJMP VERME

FIM:	JB 25H.3, RESET
	SJMP FIM

TIM1:	CLR EA
	JB 25H.0, PASVE ;TESTO SE ACABOU A CONTAGEM DO VERDE
	JB 25H.1, PASAM	;TESTO SE ACABOU A CONTAGEM DO AMARELO
	SETB 25H.0	;SE NAO O QUE PASSOU FOI O VERMELHO
	SETB P1.2
	SETB EA		;AGORA IRA PARAR A CONTAGEM 
	RETI
PASAM:	SETB 25H.2
	SETB P1.1
	MOV TH1, #0E8H
	MOV TL1, #8FH
	CLR 25H.1
	SETB TR1
	SETB EA
	RETI
PASVE:	SETB 25H.1
	SETB P1.0
	MOV TH1, #0F0H
	MOV TL1, #5FH
	CLR 25H.0
	SETB TR1
	SETB EA
	RETI

EXT1:	CLR EA
	SETB 25H.3
	SETB EA
	RETI
	
	END
	