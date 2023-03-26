.DEVICE ATMEGA8535
.include "m8535def.inc"
.def COL = r16
.def DATA = r20

.def Delay =r17 ; Delay variable 1
.def Delay2 =r18 ; Delay variable 2

.DSEG
ROW: .BYTE 16
.CSEG
.ORG 0x000
		RJMP	RESET
.ORG 0x00B
		RJMP	USART_RXC

RESET:	SER	COL
		OUT	DDRA,COL
		OUT	DDRC,COL
		LDI COL, 0xC0
		OUT DDRD, COL

		;USART INIT
		; Set baud rate
		LDI	r17, 0x00
		LDI r16, 25
		out UBRRH, r17
		out UBRRL, r16
		; Enable Receiver and Transmitter
		ldi r16, (1<<RXEN)|(0<<TXEN)
		out UCSRB,r16
		; Set frame format: 8data, 2stop bit
		ldi r16, (1<<URSEL)|(1<<USBS)|(3<<UCSZ0)
		out UCSRC,r16
		;Enable interrupt
		SBI	UCSRB, RXCIE	;USART interrupt enable
		SEI

		LDI r19, 0x11
		STS	ROW, r19
		LDI r19, 0x22
		STS	ROW+0x1, r19
		LDI r19, 0x33
		STS	ROW+0x2, r19
		LDI r19, 0x44
		STS	ROW+0x3, r19
		LDI r19, 0x55
		STS	ROW+0x4, r19
		LDI r19, 0x66
		STS	ROW+0x5, r19
		LDI r19, 0x77
		STS	ROW+0x6, r19
		LDI r19, 0x88
		STS	ROW+0x7, r19
		LDI r19, 0x99
		STS	ROW+0x8, r19
		LDI r19, 0xAA
		STS	ROW+0x9, r19
		LDI r19, 0xBB
		STS	ROW+0xA, r19
		LDI r19, 0xCC
		STS	ROW+0xB, r19
		LDI r19, 0xDD
		STS	ROW+0xC, r19
		LDI r19, 0xEE
		STS	ROW+0xD, r19
		LDI r19, 0xFF
		STS	ROW+0xE, r19
		LDI r19, 0x00
		STS	ROW+0xF, r19
		LDI r19, ROW-0x1
		LDI COL, 0x00
		LDI XH, 0x00
MAIN:	INC r19
		CPI r19, ROW+0x10
		BRLO	COLUMN
		SUBI	r19, 0x10
		SUBI	COL, 0x10
COLUMN:	MOV XL, r19
		LD	r24, X
		LDI r21, 0x07
COLUM:	MOV r23, r24
		ANDI	r23, 0x01
		LDI	r22, 0x00
		OUT PORTD, r22
		OUT	PORTC, r23
		LDI	r22, 0x80
		OUT PORTD, r22
		ROR	r24
		SUBI	r21, 0x01
		BRGE	COLUM
		LDI	r22, 0x40
		OUT PORTA, COL
		OUT	PORTD, r22

		LDI	r22, 0x00
		OUT PORTD, r22
		INC COL
		LDI r25, 0x04
		RJMP MAIN

;USART RECIEVE INTERRUPT
USART_RXC:
		MOV r15, r16
		LDI	r16, 0x01
		CP	r0, r16
		BREQ	CHANGE
		IN	r16, UDR
		MOV r0, r16
		MOV r16, r15
		RETI
CHANGE:	LDI r16, 0xFF
		CP r1, r16
		BRNE	CHANGE1
		IN	r16, UDR
		MOV	r1, r16
		LDI r16, 0x60
		ADD	r1, r16
		MOV r16, r15
		RETI
CHANGE1:IN	r16, UDR
		MOV XL, r1
		LD	r2, X
		MOV r3, r16
		AND	r3, r2
		TST r3
		BREQ	S
		OR	r2, r16
		ST	X, r2
		CLR	r0
		LDI r16, 0xFF
		MOV	r1, r16
		CLR	r2
		CLR	r3
		MOV r16, r15
		RETI
S:		SUB	r2, r16
		ST	X, r2
		CLR	r0
		LDI r16, 0xFF
		MOV	r1, r16
		CLR	r2
		CLR	r3
		MOV r16, r15
		RETI
