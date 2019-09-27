				.def	_dotp_func_v3
_dotp_func_v3:
				;PROLOG à compléter (init)
				ZERO	A3
;cycle 1
			 	LDH	*A4++,A7
			||	LDH	*B4++,B7
;cycle 2
				NOP
;cycle 3
			 	LDH	*A4++,A7
			||	LDH	*B4++,B7
;cycle 4
				NOP
;cycle 5
				LDH	*A4++,A7
			||	LDH	*B4++,B7
;cycle 6
				MPY	A7,B7,A8
;cycle 7
				LDH	*A4++,A7
			||	LDH	*B4++,B7
;cycle 8
				MPY	A7,B7,A8
			||	ADD	A8,A3,A3
;cycle 9
				LDH	*A4++,A7
			||	LDH	*B4++,B7
;cycle 10
				MPY	A7,B7,A8
			||	ADD	A8,A3,A3
;cycle 11
				LDH	*A4++,A7
			||	LDH	*B4++,B7
;cycle 12
				MPY	A7,B7,A8
			||	ADD	A8,A3,A3
;cycle 13
				NOP
;cycle 14
				MPY	A7,B7,A8
			||	ADD	A8,A3,A3
;cycle 15
				NOP
;cycle 16
				MPY	A7,B7,A8
			||	ADD	A8,A3,A3
;cycle 17
				NOP
;cycle 18
				ADD	A8,A3,A3

				;EPILOG à compléter (vidage pipeline et retour de paramètres)
				MV	A3,A4
				B	B3
				.end
