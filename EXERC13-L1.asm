;****************************************
;*		EXERCÍCIO 13		*
;****************************************

;****************************************

	ORG	0			; Início da memória (se houver um RESET, o programa volta para cá)
	SJMP	PROG			; Primeiro, vai até o programa principal

;****************************************

	ORG	0003h			; Posição de memória para quando a interrupção externa 0 é ativada
	SJMP	INTERRUPT0		; Tratamento da interrupção externa 0, que é quando um obstáculo é detectado

;****************************************

PROG:
	SETB	P1.0			; Liga a alimentação na roda esquerda
	SETB	P1.2			; Liga a alimentação na roda direita

	SETB	EX0			; Liga o bit que permite que a interrupção externa 0 seja utilizada
	SETB	IT0			; A interrupção externa 0 será criada quando houver uma descida de borda
	SETB	EA			; Habilita as interrupções

	SETB	P1.1			; Robô movimenta-se
	SETB	P1.3			; para frente

	CLR	P1.4			; Convenção: P1.4 = 0 => próximo movimento será a direita
					;	     P1.4 = 1 => próximo movimento será a esquerda

	SJMP	$			; Aguarda até que um obstáculo seja encontrado

;****************************************

INTERRUPT0:
	CLR	EA			; Desabilita as interrupções enquanto a interrupção está sendo atendida

	CLR	P1.1			; Robô movimenta-se
	CLR	P1.3			; para trás
	ACALL	DELAY2S			; Espera 2 segundos para concluir o movimento

	JB	P1.4, ESQ		; Vemos se o robô irá para a esquerda ou para a direita

DIR:
	SETB	P1.1			; Robô movimenta-se
	CLR	P1.3			; para a direita
	ACALL	DELAY2S			; Espera 2 segundos para concluir o movimento
	SETB	P1.4			; Setamos P1.4 para que o próximo movimento seja para a esquerda
	SJMP	CONT			; Continua no programa

ESQ:
	CLR	P1.1			; Robô movimenta-se
	SETB	P1.3			; para a esquerda
	ACALL	DELAY2S			; Espera 2 segundos para concluir o movimento
	CLR	P1.4			; Damos clear em P1.4 para que o próximo movimento seja para a direita

CONT:
	SETB	P1.1			; O Robô movimenta-se para frente
	SETB	P1.3			; até que se encontre outro obstáculo

	SETB	EA			; Reabilita as interrupções

	RETI				; Retorna da interrupção

;****************************************

DELAY2S:
	; Frequência do oscilador é 12 MHz
	; 12MHz/12 = 1 MHz = 1 us/ciclo
	; 2 segundos = 2.000.000 micro segundos = 2.000.000 ciclos
	; ((R0*2 + 3)*R1 + 3)*R2 + 3 = 2.000.000
	; R0 = 240, R1 = 230, R2 = 18, ((240*2 + 3)*230 + 3)*18 + 3 = 1.999.674
	MOV	R2, #18d		; 1 ciclo
LOOP1:
	MOV	R1, #230d		; 1 ciclo
LOOP2:
	MOV	R0, #240d		; 1 ciclo
	DJNZ	R0, $			; 2 ciclos
	DJNZ	R1, LOOP2		; 2 ciclos
	DJNZ	R2, LOOP1		; 2 ciclos

	RET				; 2 ciclos

;****************************************