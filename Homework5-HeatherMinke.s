* Homework5 ARM Program Framework
	
	AREA	Homework5, CODE, READONLY
	EXPORT	main		;required by the startup code
	ENTRY

main					;required by the startup code. This is a label as well.
	MOV R4, #0			;moves the number 0 to R4
	LDR	R2, =HexStr		;loads the memory address of HexStr to R2
LoopBeginning
	LDRB R3, [R2], #1	;loads the content of the memory location in R2. Also has a post index of 1
	CMP R3, #'0'		;Compares the contents of R3 with the ASCII of 0
	BLO DoneRead		;branches to DoneRead if R3 is lower than or equal to the ASCII of 0
	CMP R3, #'9'		;compares the contexts of R3 with the ASCII of 9
	BLS IsADigit		;branches to IsADigit if R3 is lower than the ASCII of 9
	CMP R3, #'A'		;compares the contents of R3 with the ASCII of A
	BLO DoneRead		;branches to DoneRead if R3 is lower than or equal to the ASCII of A
	CMP R3, #'F'		;compares the contents of R3 with the ASCII of F
	BHI DoneRead		;branches to DoneRead if R3 is higher than the ASCII of F
	SUB R3, #'A'		;subtract the contents of R3 and the ASCII of A
	ADD R3, #0xA		;Add the contents of R3 and hexidecimal A
	B ValidHexSym		;branch to ValidHexSym
IsADigit
	SUB R3, #'0'		;subtracts R3 and the ASCII of 0
ValidHexSym
	LSL R4, R4, #4		;logic shift left of R4 4 bytes
	ADD R4, R3			;add R4 and R3
	B	LoopBeginning	;branch to LoopBeginning
DoneRead
	LDR R3, =TwosComp	;load the memory location of TwosComp to R3
	STR R4, [R3]		;Store a word from R4 to the memory location in R3
	LDR R5, =RvsDecStr	;load the memory location of RvsDecStr to R5
	LDR R6, =DecStr		;load the memory location of DecStr to R6
	TST R4, #0x80000000	
	BEQ IsPos
	MOV R3, #'-'		;move - to R3
	STRB R3, [R6], #1	;store a byte of R3 to the memory location in R6. post index of 1
	MVN R4, R4			;move negate R4
	ADD R4, #1			;add R4 and 1
IsPos
	BL DivByTen			;branch to DivByTen
	ADD R7, R7, #'0'	;add R7 and the ASCII of 0
	STRB R7, [R5], #1	;store a byte of R7 in the memory location of R5. post index of 1
	TEQ R4, #0			;test if R4 is equal to 0
	BNE IsPos			;branch to IsPos if net equal
DoneRvsDecStr
	SUB R5, #1			;subtract R5 and 1
	LDR R8, =RvsDecStr	;load the memory location of RvsDecStr to R8
LoadLoop
	CMP R5, R8			;compare R5 and R8
	BLO DoneDecStr		;branch to DoneDecStr if R5 is lower than or equal to R8
	LDRB R3, [R5], #-1	;load a byte of the memory location in R5 to R3. post index of -1
	STRB R3, [R6], #1	;store a byte of R3 to the memory location of R6. post index of 1
	B LoadLoop			;branch to LoadLoop
DoneDecStr
	MOV R3, #0			;move 0 to R3
	STRB R3, [R6]		;store a byte of R3 in the memory location of R6
	SVC	#0x11 			;this ends the main routine
	
DivByTen
	MOV R3, #0			;move 0 to R3
SubLoop
	CMP R4, #0xA		;compare R4 with hexidecimal A
	BLO DoneSubByTen	;brach to DoneSubByTen if R4 is below or equal to hexidecimal A
	SUB R4, #0xA		;subtract R4 and hexidecimal A
	ADD R3, #1			;add R3 and 1
	B SubLoop			;brach to SubLoop
DoneSubByTen
	MOV R7, R4			;move R4 to R7
	MOV R4, R3			;move R3 to R4
	BX LR				;branch back to main
	ALIGN				;BX LR is a two byte instruction. This is telling the computer to skip the last two bytes.

	AREA	Homework5Data, DATA, READWRITE
		
	EXPORT	adrHexStr		;needed for displaying addr in command-window
	EXPORT	adrTwosComp		;needed for displaying addr in command-window
	EXPORT	adrRvsDecStr	;needed for displaying addr in command-window
	EXPORT	adrDecStr		;needed for displaying addr in command-window

adrHexStr DCD HexStr		;needed for displaying addr in command-window. DCD is for a four byte word.
adrTwosComp	DCD TwosComp	;needed for displaying addr in command-window. DCD is for a four byte word.
adrRvsDecStr DCD RvsDecStr	;needed for displaying addr in command-window. DCD is for a four byte word.
adrDecStr DCD DecStr		;needed for displaying addr in command-window. DCD is for a four byte word.

	
HexStr DCB	"FFF4B3FA", 0		;the string that holds the hexadecimal number
TwosComp DCD 0x00000000, 0

	ALIGN

RvsDecStr SPACE	11	;This creates a space of memory that has a length of 11.
DecStr SPACE 12		;This creates a space of memory that has a length of 12.
	
	END
