.data

.text
.globl main
main:
	
	-empiler par la fin les différents symboles du calcul
	-tant que taille < 2
		-depiler jusqu'au premier opérateur dans un tableau
		-"call calc" avec op et les 2 derniers entiers ( on remonte le tableau par la fin )
		-rempiler le tableau en remontant ( pour les entiers du début de tableau )
	-fin tant
	-afficher le résultat

/*calc:
	-depiler retourn
	-depiler g
	-traduire g (char2int)
	-depiler d
	-traduire d (char2int)
	-branchement sur op
	-appliquer op
	-traduire res (int2char)
	-empiler res
	-ret
*/





#######Fonctions###############
.globl char2int
.type char2int function
char2int:	popl return
		pop %ecx # le char a traduire
		sub $'0', %ecx # on traduit
		push %ecx
		push return
		ret

.globl int2char
.type int2char function
int2char:	popl return
		pop %ecx
		add $'0', %ecx
		push %ecx
		pushl return
		ret

.globl calc
.type calc function
calc:		popl return
		pop %eax # opérateur
		pop %ebx # d
		pop %ecx # g
		cmpb $'+', %eax
		je _add
		cmpb $'-', %eax
		je _sub
		cmpb $'*', %eax
		je _mul
		cmpb $'/', %eax
		je _div
		jmp error

_add:		add %ebx, %ecx
		jmp calc_end

_sub:		sub %ebx, %ecx
		jmp calc_end

_div:		idiv %ebx, %ecx
		jmp calc_end

_mul:		imul %ebx, %ecx
		jmp calc_end

error:		jmp calc_end

calc_end:	push %ecx
		pushl return
		ret
