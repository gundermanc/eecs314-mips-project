#Copied from Christian's :)

.include "ee-factorial.asm"
.include "ee-logarithm.asm"
.include "ee-powers.asm"

.data	# variable declarations follow this line
	ee_welcome_prompt:	.asciiz "\nYou have selected math functions library\n"
	
	ee_menu_option_quit:	.asciiz "(0) Return to main menu.\n"
	ee_menu_option_pow:	.asciiz "(1) Power \n"
	ee_menu_option_fact:	.asciiz "(2) Factorial \n"
	ee_menu_option_log:	.asciiz "(3) Logarithm \n"
	
	zero_ee: .float 0.0
	one_ee: .float 1.0
.text

# indicates start of code (first instruction to execute)		
ee_main:	
ee_menu_begin:
	print_string ( ee_welcome_prompt )	# prompt user for menu option
	
	# print menu options
	print_string ( ee_menu_option_quit )
	print_string ( ee_menu_option_pow )
	print_string ( ee_menu_option_fact )
	print_string ( ee_menu_option_log )
	
	# menu option select. bad runtime complexity, I know, but I don't know jump tables
	read_integer ( $t0 )			# read integer from console
	
	# PUT MENU OPTIONS HERE
	# use the $t1 as our comparison register
	# ---------------------------------------------------
	
	# (0) Quit
	li	$t1, 0				# key that must be pressed
	beq	$t1, $t0, menu_begin		# calling code, same for all options
	
	# (1) Power
	li	$t1, 1				# key that must be pressed
	la	$t2, pow_main			# library entry point address
	beq	$t1, $t0, ee_call_library	# calling code, same for all options
	
	# (2) Factorial
	li	$t1, 2				# key that must be pressed
	la	$t2, fact_main			# library entry point address
	beq	$t1, $t0, ee_call_library	# calling code, same for all options
	
	# (3) Logarithm
	li	$t1, 3				# key that must be pressed
	la	$t2, log_main			# library entry point address
	beq	$t1, $t0, ee_call_library	# calling code, same for all options
	
	# ---------------------------------------------------
	# no options matched, ask again
	print_string ( menu_unknown_prompt )
	j	ee_menu_begin
	
	jr	$t2		# jump to selected function
	j	menu_begin	# return to the menu

ee_call_library:
	jr	$t2	
