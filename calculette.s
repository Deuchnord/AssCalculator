.data
	i: .int 99
.bss
	calculDemande: .space 100
	calculPostfixe: .space 100

.text
.globl _start

_start:
	# On récupère le calcul dans stdin
	MOV $3, %eax
	MOV $0, %ebx
	MOV $calculPostfixe, %ecx
	MOV $100, %edx
	INT $0x80

lookforln:
	MOV $calculPostfixe, %eax
	ADD i, %eax
	MOV (%eax), %eax
	CMP 

pushchiffres:
	MOV $calculPostfixe, %eax
	ADD i, %eax
	MOV (%eax), %eax
	CMP %eax, 0
	JE calcul
	PUSH %eax
	INCL i
	JMP pushchiffres

calcul:
	POP %eax
	POP %ebx
	POP %ecx
