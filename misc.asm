
	.equ COEF1, 3483
	.equ COEF2, 11718
	.equ COEF3, 1183

	.text

	.global rgb2gray
	.global div16384
	.global apply_gaussian
rgb2gray:
		PUSH {R4,R5,LR}
		//R0 -> puntero a pixel
		LDRB R1, [R0]	//R
		LDR R2, =COEF1
		MUL R3, R1, R2
		MOV R1, R3
		ADD R0, #1

		LDRB R2, [R0]	//G
		LDR R3, =COEF2
		MUL R4, R2, R3
		MOV R2, R4
		ADD R0, #1

		LDRB R3, [R0]	//B
		LDR R4, =COEF3
		MUL R5, R3, R4
		MOV R3, R5

		ADD R0, R1, R2
		ADD R0, R0, R3

		BL div16384

		POP {R4,R5,LR}

		MOV PC, LR

div16384: 
		MOV R1, #0
while:	CMP R0, #16384
		BLT fin_while
		SUB R0, #16384
		ADD R1, R1, #1
		B while
fin_while:
		MOV R0, R1
		MOV PC, LR

				//R0 -> im1[], R1 -> im2[], R2 -> width, R3 -> height
apply_gaussian:
		PUSH {R4 - R7, LR}
		MOV R4, #0	//i
		MOV R5, #0	//j
fori:	CMP R4, R3
		BGE fin_fori
forj:	CMP R5, R2
		BGE fin_forj

		//calculo desplazamiento direccion
		MUL R6, R4, R2
		ADD R6, R6, R5

		//llamada a funcion
		PUSH {R0 - R3}
		MOV R1, R2
		MOV R2, R3
		MOV R3, R4
		PUSH {R5}
		BL gaussian
		MOV R7, R0
		ADD SP, SP, #4
		POP {R0 - R3}

		//guardar
		STRB R7, [R1, R6]

		ADD R5, R5, #1
		B forj
fin_forj:
		MOV R5, #0
		ADD R4, R4, #1
		B fori
fin_fori:
		POP {R4 - R7, LR}
		MOV PC, LR
		.end
