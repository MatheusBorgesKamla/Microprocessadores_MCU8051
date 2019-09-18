;****************************************
;*		EXERCÍCIO 9		*
;****************************************

;****************************************

	ORG	0			; Início da memória (se houver um RESET, o programa volta para cá)
	SJMP	PROG			; Primeiro, vai até o programa principal

;****************************************

	ORG	0003h			; Posição de memória para quando a interrupção externa 0 é ativada
	ACALL	EXT0			; Tratamento da interrupção externa 0
	RETI

;****************************************

	ORG	000Bh			; Posição de memória para quando a interrupção do overflow no timer 0 é ativada
	ACALL	TIM0			; Tratamento da interrupção do overflow no timer 0
	RETI

;****************************************

	ORG	0013h			; Posição de memória para quando a interrupção externa 1 é ativada
	ACALL	EXT1			; Tratamento da interrupção externa 1
	RETI

;****************************************

	ORG	01BH			; Posição de memória para quando a interrupção do overflow no timer 1 é ativada
	ACALL	TIM1			; Tratamento da interrupção do overflow no timer 1
	RETI

;****************************************

PROG:
	SETB EX0			;HABILITA A INTERRUPCAO EXTERNA NO PORT INT0
	SETB PX0			;DEFINE A PRIORIDADE DA EX0 COMO ALTA
	SETB EX1			;HABILITA A INTERRUPCAO EXTERNA NO PORT INT1
	CLR  PX1			;DEFINE A PRIORIDADE DA EX1 COMO BAIXA
	SETB ET0			;HABILITA A INTERRUPCAO EXTERNA DO TIMER 0
	SETB PT0			;DEFINE A PRIORIDADE DA ET0 COMO ALTA
	SETB ET1			;HABILITA A INTERRUPCAO EXTERNA DO TIMER 1
	CLR  PT1			;DEFINE A PRIORIDADE DA EX1 COMO BAIXA
	SETB EA				;HABILITA AS INTERRUPCOES

	MOV TMOD, #11H			;HABILITA TANTO O TIMER 0 QUANTO O 1 NO MODO 1

	MOV TH0, #0D8H			;INICIALIZA TH0 E TL0 PARA CONTAR 10 MS
	MOV TL0, #0EFH

	MOV TH1, #015H			;INICIALIZA TH1 E TL1 PARA CONTAR 60 MS
	MOV TL1, #09FH

	SETB TR0			;DISPARA O TIMER 0
	SETB TR1			;DISPARA O TIMER 1

	SJMP $				;LOOP DO PROGRAMA

EXT0:	CLR EA
	MOV DPTR, #5000H
	MOVX A, @DPTR
	MOV R0, P1
	MOV P1, A
	MOV A, R0
	MOVX @DPTR, A
	SETB EA
	RET

EXT1:	CLR EA
	MOV DPTR, #5000H
	MOVX A, @DPTR
	MOV 7FH, A
	SETB EA
	RET

TIM0:	CLR EA
	CLR TR0
	MOV A, 7FH
	MOV DPTR, #5200H
	MOVX @DPTR, A
	MOV TH0, #0D8H
	MOV TL0, #0EFH
	SETB TR0
	SETB EA
	RET

TIM1:	CLR EA
	CLR TR1
	MOV DPTR, #5200H
	MOVX A, @DPTR
	MOV DPTR, #5000H
	MOVX @DPTR, A
	MOV TH1, #015H
	MOV TL1, #09FH
	SETB TR1
	SETB EA
	RET
	END