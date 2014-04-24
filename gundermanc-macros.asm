# Useful macros for printing to console, etc.
# By: Christian Gunderman

# Put at top of your source file to include this file:
#   .include "gundermanc-macros.asm"


.data
	menu_unknown_prompt:	.asciiz "Unknown menu option.\n\n"
	console_clear_prompt:	.asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	
# prints a TON of new lines so we get a clear console
.macro	clear_console
	print_string ( console_clear_prompt )
.end_macro
	
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

# read an integer in from the console
.macro	read_integer ( %register )
	li   $v0, 5
	syscall
	move  %register, $v0
.end_macro

# read a float in from the console
.macro	read_float ( %register )
	li   $v0, 6
	syscall
	#mov.s  %register, $f0
	
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

# calls a routine and saves the return address
.macro call ( %routine )
	jal	%routine
.end_macro 

# defines the beginning of a routine
.macro begin_routine
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
