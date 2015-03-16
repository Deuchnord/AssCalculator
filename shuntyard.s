# shuntyard
# Converts the operation to infix notation
# Arguments:
#	- The string to convert
.globl shuntyard
.type  shuntyard function
shuntyard:
	POP return
	POP %eax
	MOV $0, %ebx

	MOV (%eax), %ebx
