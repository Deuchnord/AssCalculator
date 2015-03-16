.data
	nbre: .long 3, '+', 4
.bss
	queue: .space 20

.text
# shuntyard
# Converts the operation to infix notation
# Arguments:
#	- The string to convert

.globl _start
_start:
	MOV nbre, %eax
	PUSH %eax
	CALL shuntyard

.globl shuntyard
.type  shuntyard function
shuntyard:
	POP return
	POP %eax
	MOV queue, %ecx

loop:
	MOV (%eax), %bl

	CMPB %bl, '\0'
		JE endofloop

	CMPB %bl, '+'
		JE operator
	CMPB %bl, '-'
		JE operator
	CMPB %bl, '*'
		JE operator
	CMPB %bl, '/'
		JE operator
	
	MOVB %bl, (%ecx)
	INC %ecx

	INC %eax
	JMP loop
	
operator:
	PUSH %ebx
	INC %eax
	JMP loop

endofloop:
	POP %ebx
	MOVB %bl, (%ecx)
