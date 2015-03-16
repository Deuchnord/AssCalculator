.data
chaine: .space 100
testline: .asciz "2 1 +"
chars:  .rept 20
        .byte 0
        .endr
taille: .long 0
osef:	.long 0
g:	.long 0
d:	.long 0
resultat:.byte 0
.text
.globl main
main:		 
lire:		movl testline, 	%eax

to_end:		cmpb $0,	(%eax)
		je piler
		incl %eax
		incl taille
		jmp to_end
		decl taille
		movl taille, 	%ecx
		incl %ecx # pour le premier tour de piler, taille+1 est requis

piler:		decl %eax 
		decl %ecx
		cmpl $0, 	%ecx
		je calc_start
		movb (%eax),	%ebx
		push %ebx
		jmp piler

calc_start:	movl taille, 	%ecx #compteur de boucle
		movl chars,  	%edx #
calc_main:	cmpl $3, 	%ecx
		jl calc_stop
		
depiler:	pop %eax
		cmpb $42, 	%eax # Entre * et 9 dans la table ascii
		jl depiler_bis
		cmpb $57, 	%eax
		jg depiler_bis
		movb %eax, 	(%edx)
		cmpb $'+', 	%eax
		je to_calc
		cmpb $'/', 	%eax
		je to_calc
		cmpb $'*', 	%eax
		je to_calc
		cmpb $'-', 	%eax
		je to_calc
depiler_bis:	incl %edx
		jmp calc_main

to_calc:	movb (%edx), 	%ebx # op
		push %ebx
		movb $0, 	(%edx)
		decl %edx
		movb (%edx), 	%ebx # d
		push %ebx
		movb $0, 	(%edx)
		decl %edx
		movb (%edx), 	%ebx # g
		push %ebx
		movb $0, 	(%edx)
		decl %edx
		subl $3, 	taille # on retire g d et op
		call calc
		popl osef
		pop %ecx
		incl %edx
		movb %ecx, 	(%edx) # on remet le resultat dans chars
		incl taille # du coup on a un char de plus

repile_start:	movl chars, 	%ecx # addresse de chars[0]

repile:		cmpl %ecx, 	%edx # si on est revenu à l'addresse de 0 on arrête
		jl calc_start
		movb (%edx), 	%ebx
		push %ebx
		movb $0,	(%edx)
		decl %edx
		jmp repile

calc_stop:	pop %eax # resutat final
		movb %eax,	resultat

afficher:	movl $4,	%eax
		movl $1, 	%ebx
		movl resultat, 	%ecx
		movl $5, 	%ebx
		int $0x80
		movl $1,	%eax
		movl $0,	%ebx
		int $0x80

#######Fonctions###############
.globl char2int
.type char2int function
char2int:	popl return
		pop %ecx # le char a traduire
		sub $'0', %ecx # on traduit
		pushl %ecx
		pushl return
		ret

.globl int2char
.type int2char function
int2char:	popl return
		popl %ecx
		add $'0', %ecx
		push %ecx
		pushl return
		ret

.globl calc
.type calc function
calc:		popl return
		pop %ecx # d : char
		pop %ebx # g : char
		pop %eax # op

tradd:		push %ecx
		call char2int
		popl %ecx
		popl %ecx # d : long
		movl %ecx, d

tradg:		push %ebx
		call char2int
		popl %ebx
		popl %ebx # g : long
		movl %ebx, g

op_start:	movl g, %ebx
		movl d, %ecx

op:		cmpb $'+', %eax
		je _add
		cmpb $'-', %eax
		je _sub
		cmpb $'*', %eax
		je _mul
		cmpb $'/', %eax
		je _div
		jmp error

_add:		addl %ebx, %ecx
		jmp calc_end

_sub:		subl %ebx, %ecx
		jmp calc_end

_div:		movl %ebx, %eax
		movl $0  , %edx
		idiv %ecx
		movl %eax, %ecx # resultat
		jmp calc_end

_mul:		imul %ebx, %ecx
		jmp calc_end

error:		jmp calc_end

trad_res:	pushl %ecx
		call int2char
		popl %ecx
		pop %ecx

calc_end:	push %ecx
		pushl return
		ret
