;****************************************
;*		EXERCÍCIO 12		*
;****************************************

;****************************************

	ORG	0			; Início da memória (se houver um RESET, o programa volta para cá)
PAR	EQU	30h			; Flag setada quando o número analisado é par, e dado clear caso contrário
IMPAR	EQU	31h			; Flag setada quando o número analisado é ímpar, e dado clear caso contrário
	SJMP	PROG			; Primeiro, vai até o programa principal

;****************************************

PROG:
	MOV	SCON, #40h		; Programar a interface serial (seta como modo 1)
	MOV	TMOD, #20h		; Programar o timer 1 (seta como modo 2)
	MOV	DPTR, #TAB		; Aponta para o primeiro valor de TAB, que está na memória de programa
	CLR	A			; Limpa o conteúdo em A
	MOV	R0, #0h			; R0 será o contador de números pares. Começa com 0
	MOV	R1, #0h			; R1 será o contador de números ímpares. Começa com 0
	MOV	R2, #09d		; R2 é a contagem de iterações (no caso, 9 porque são 10 números e vai até 0)
LOOP:
	MOVC	A, @A+DPTR		; Coloca o valor apontado na memória de programa e insere em A
	INC	DPTR			; Aponta para o próximo valor da memória de programa
	CLR	PAR			; Limpa a flag PAR
	CLR	IMPAR			; Limpa a flag IMPAR

	ACALL	IMPAROUPAR		; Chama sub-rotina para determinar se é par ou ímpar, com o retorno nas flags

	CJNE	R2, #0d, NACABO		; Verifica se as iterações não acabaram. Se acabaram, continua. Se não, pula.
	SJMP	ACABO			; Se acabou, pula para a label ACABO

NACABO:
	DEC	R2			; Decrementa o valor de R2 (avança na iteração)
	JB	PAR, LOOPAR		; Se A é par, o comportamento é tratado em LOOPAR
	JB	IMPAR, LOOPIMPAR	; Se A é impar, o comportamento é tratado em LOOPIMPAR

LOOPAR:
	ACALL	PARSERIAL		; Chama sub-rotina para a interface serial de quando o número é par
	MOV	P1, A			; Copia o valor de A para P1, como pede o enunciado
	CLR	A			; Limpa o valor de A para a próxima iteração
	SJMP	LOOP			; Retoma o loop

LOOPIMPAR:
	ACALL	IMPARSERIAL		; Chama sub-rotina para a interface serial de quando o número é ímpar
	MOV	P2, A			; Copia o valor de A para P2, como pede o enunciado
	CLR	A			; Limpa o valor de A para a próxima iteração
	SJMP	LOOP			; Retoma o loop

ACABO:
	MOV	DPTR, #2030h		; Insere o endereço da memória externa no registrador DPTR
	MOV	A, R0			; Move o número de números pares em A para ser inserido em DPTR (endereço 2030h)
	MOVX	@DPTR, A		; Insere o número de números pares no endereço 2030h, apontador por DPTR
	MOV	DPTR, #2031h		; Mesmo procedimento para o número de números impares, mas na posição 2031h
	MOV	A, R1
	MOVX	@DPTR, A

	SJMP	$			; Fim do programa

;****************************************
; Sub-rotina para determinar se um número é par ou ímpar
;****************************************

IMPAROUPAR:
	MOV	B, #2d			; Carrega o valor 2 decimal em B
	DIV	AB			; Divide A por B (ou seja, por 2). Em A fica a parte inteira e em B fica o resto
	MOV	A, #0d			; Move o valor 0 para A
	CJNE	A, B, RESULTIMPAR	; Se A e B são zero, o valor é par. Caso contrário, é ímpar

RESULTPAR:
	SETB	PAR			; A flag PAR é setada, ou seja, o número é par
	CLR	IMPAR			; A flag IMPAR é dada clear, ou seja, o número não é ímpar
	INC	R0			; Incrementa o número de números pares, que está no registrador R0
	SJMP	CONT			; Continua o programa

RESULTIMPAR:
	SETB	IMPAR			; A flag IMPAR é setada, ou seja, o número é impar
	CLR	PAR			; A flag PAR é dada clear, ou seja, o número não é par
	INC	R1			; Incrementa o número de números ímpares, que está no registrador R1

CONT:
	RET				; Retorna da chamada da sub-rotina

;****************************************
; Sub-rotinas para tratamento da interface serial
;****************************************

PARSERIAL:
	MOV	TH1, #253		; Configuração do timer para determinar
	MOV	TL1, #253		; o baud rate para números pares
	SJMP	FIMSERIAL		; Continua o procedimento da interface


IMPARSERIAL:
	MOV	TH1, #250		; Configuração do timer para determinar
	MOV	TL1, #250		; o baud rate para números impares

FIMSERIAL:
	SETB	TR1			; Liga o timer para fazer a interface serial

	MOV	SBUF, A			; Move o valor de A para o buffer serial
	JNB	TI, $			; Espera até que seja carregado o valor de A no buffer serial
					; Ou seja, enquanto o valor do bit de interrupção TI for 0, mantém no mesmo lugar
					; Quando o bit TI recebe 1, significa que a interface serial foi concluída
	CLR	TI			; Permite que haja interfaces seriais futuras, pois o bit foi zerado
	RET				; Retorna para o programa principal

;****************************************
; Valores na memória de programa
;****************************************

TAB:	DB	030d, 128d, 201d, 83d, 12d, 112d, 210d, 43d, 2d, 91d

;****************************************

	END