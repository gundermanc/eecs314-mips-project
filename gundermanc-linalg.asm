# Linear Algebra Library Menus
# Connect's Phil's code to the Application
# By: Christian Gunderman

#.include "gundermanc-macros.asm"

.include "pabb_mat-mult.asm"

.data	# variable declarations follow this line
	lalg_welcome_prompt:	.asciiz "You have selected linear algebra library\n"
	
	lalg_menu_option_quit:	.asciiz "(0) Return to main menu.\n"
	lalg_menu_option_mul:	.asciiz "(1) Square Matrix Multiplier\n"
.text

# indicates start of code (first instruction to execute)		
lalg_main:	
lalg_menu_begin:
	print_string ( lalg_welcome_prompt )	# prompt user for menu option
	
	# print menu options
	print_string ( lalg_menu_option_quit )
	print_string ( lalg_menu_option_mul )
	
	# menu option select. bad runtime complexity, I know, but I don't know jump tables
	read_integer ( $t0 )			# read integer from console
	
	# PUT MENU OPTIONS HERE
	# use the $t1 as our comparison register
	# ---------------------------------------------------
	
	# (0) Quit
	li	$t1, 0				# key that must be pressed
	beq	$t1, $t0, menu_begin		# calling code, same for all options
	
	# (1) Square Matrix Multiplier
	li	$t1, 1				# key that must be pressed
	la	$t2, mat_mult_main		# library entry point address
	beq	$t1, $t0, lalg_call_library	# calling code, same for all options
	
	# ---------------------------------------------------
	# no options matched, ask again
	print_string ( menu_unknown_prompt )
	j	lalg_menu_begin
	
	jr	$t2		# jump to selected function
	j	menu_begin	# return to the menu

lalg_call_library:
	jr	$t2	
