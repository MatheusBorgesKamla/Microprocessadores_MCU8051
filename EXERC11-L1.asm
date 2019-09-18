;Exercício 11

	ORG	0
	SJMP	prog

;carrega os parametros iniciais
charg:	MOV	TMOD, #00100101b
	MOV	SCON, #01000000b
	SETB	REN
	MOV	TH1, #0FAh
	MOV	TL1, #0FAh
	SETB	TR1

atraso:	DJNZ	R0, $
	DJNZ	R1, $-5
	DJNZ	R2, $-9
	DJNZ	R3, $-13
	MOV	R0, #061h
	DJNZ	R0, $
	NOP
	RET

;sub-rotina 1
sub1:	MOV	TH0, #0h
	MOV	TL0, #0h
	SETB	TR0
	MOV	R3, #002h
	MOV	R2, #0ADh
	MOV	R1, #007h
	MOV	R0, #0BCh
	NOP
	ACALL	atraso
	CLR	TR0
	MOV	SBUF, TH1
	JNB	TI, $
	MOV	SBUF, TL1
	JNB	TI, $
	SJMP	sub1

;main
prog:	ACALL	charg
	ACALL	sub1

	END