	ORG 0
	MOV DPTR, #1200H
INI:	JNB P1.0, ZERO
	MOV A, #7FH
	MOVX @DPTR, A
	SETB P3.1
	CLR P3.0
	SJMP INI
ZERO:	MOV A, #0FFH
	MOVX @DPTR, A
	SETB P3.0
	CLR P3.1
	SJMP INI
	END