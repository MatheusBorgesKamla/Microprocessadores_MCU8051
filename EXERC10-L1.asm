;****************************************
;*		EXERCÍCIO 10		*
;****************************************

;****************************************

	ORG	0			; Início da memória (se houver um RESET, o programa volta para cá)
	SJMP	PROG			; Primeiro, vai até o programa principal

;****************************************
PROG:
	CLR	P1.4			; Começaremos com o bit P1.4 zerado, por default que o Forfs escolheu
LOOP:
	JNB	P1.3, LOOP		; Se o bit P1.3 for zero, ficamos na mesma. Se o bit P1.3 for um, emitimos a onda
	ACALL	T50MS			; Chamada para a sub-rotina da onda positiva, com delay de 50 ms
	ACALL	T50S			; Chamada para a sub-rotina da onda negativa, com delay de 50 segundos
	SJMP	LOOP			; O loop é retomado

;****************************************

T50MS:
	; Devemos contabilizar o total de ciclos do nosso timer. Para até 113 ms, usamos dois registradores.
	; 1 ciclo = 1 microssegundo (12 MHz/12 = 1 MHz = 1us)
	; (R0*2 + 3)*R1 + 4 = 50000 ciclos
	; R0 = 251, R1 = 99, (251*2 + 3)*99 + 4 = 49999 microssegundos
	SETB	P1.4			; 1 ciclo
	MOV	R1, #063h		; 1 ciclo
LOOPT50MS:
	MOV	R0, #0FBh		; 1 ciclo
	DJNZ	R0, $			; 2 ciclos
	DJNZ	R1, LOOPT50MS		; 2 ciclos

	NOP

	RET				; 2 ciclos


;****************************************

T50S:
	; Mesma coisa que o delay de 50 ms, mas, nesse caso, como são 50 segundos, precisaremos de fucking 4 registradores.
	; 1 ciclo = 1 microssegundo (12MHz/12 = 1 MHz = 1us)
	; (((R0*2+3)*R1 + 3)*R2 + 3)*R3 + 4 = 50.000.000 ciclos
	; R0 = 216, R1 = 230, R2 = 10, R3 = 50, (((216*2 + 3)*230 + 3)*10 + 3)*50 + 4 = 50.025.150 ciclos
	CLR	P1.4			; 1 ciclo
	MOV	R3, #50d		; 1 ciclo
LOOP50S0:
	MOV	R2, #10d		; 1 ciclo
LOOP50S1:
	MOV	R1, #230d		; 1 ciclo
LOOP50S2:
	MOV	R0, #216d		; 1 ciclo
	DJNZ	R0, $			; 2 ciclos
	DJNZ	R1, LOOP50S2		; 2 ciclos
	DJNZ	R2, LOOP50S1		; 2 ciclos
	DJNZ	R3, LOOP50S0		; 2 ciclos

	RET				; 2 ciclos

;****************************************