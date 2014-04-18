# Useful macros for printing to console, etc.
# By: Christian Gunderman

# Put at top of your source file to include this file: .include "gundermanc-macros.asm"



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

# ends the program 
.macro	exit
	li	$v0, 10
	syscall
.end_macro