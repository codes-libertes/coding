				.def	_dotp_func_v2
_dotp_func_v2:
				;PROLOG à compléter (init)
				MV	A6,A1
			||	MV	B4,A5
				ZERO	A3

LOOP:
				LDH	*A4++[1],A7
				NOP	4
				LDH	*A5++[1],A6
				NOP	4

				MPY	A7,A6,A6
				NOP
				ADD	A6,A3,A3

				LDH	*+A4[0],B4
				NOP	4
				STH	B4,*-A4[1]

				SUB	A1,1,A1
		[A1]	B	LOOP
				NOP	5

				;EPILOG à compléter (vidage pipeline et retour de paramètres)
				MV	A3,A4
				B	B3
				NOP	5
				.end
