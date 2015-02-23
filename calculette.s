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
	CMP %eax, ln
	JNE lookforln

pushchiffres:
	MOV $calculPostfixe, %eax
	ADD i, %eax
	MOV (%eax), %eax
	MOV i, %ebx
	CMP i, %ebx
	JE calcul
	PUSH %eax
	DECL i
	JMP pushchiffres

calcul:
	POP %eax
	POP %ebx
	POP %ecx

	
