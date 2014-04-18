# Useful macros for printing to console, etc.
# By: Christian Gunderman

# Put at top of your source file to include this file:
#   .include "gundermanc-macros.asm"



# prints the string at the specified address to the console
.macro	print_string (%string_label )
	la  $a0, %string_label
	li   $v0, 4
	syscall
.end_macro

# prints the integer in a register
.macro	print_integer ( %register )
	move  $a0, %register
	li   $v0, 1
	syscall
.end_macro

# pushes a return value to the stack
.macro	push_return_value
	addi	$sp, $sp, -4		# move stack pointer
	sw 	$ra, ($sp)		# store return address
.end_macro

# pop return value from stack
.macro pop_return_value
	lw	$ra, ($sp)		# load return address to $ra
	addi	$sp, $sp, 4		# move stack pointer
.end_macro

# defines a routine
.macro begin_routine (%name)
	%name:
	push_return_value
.end_macro

.macro end_routine
	pop_return_value
	jr	$ra
.end_macro 

# ends the program 
.macro	exit
	li	$v0, 10
	syscall
.end_macro