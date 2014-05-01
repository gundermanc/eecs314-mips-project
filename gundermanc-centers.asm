# Measures of center Menus
# Connect's Laura's code to the Application
# By: Christian Gunderman

#.include "gundermanc-macros.asm"

.include "AverageCalculatorInteger"
.include "AverageCalculatorDouble"
.include "MedianCalculatorInteger"
.include "MedianCalculatorDouble"
.include "ModeCalculatorInteger"

.data	# variable declarations follow this line
	moc_welcome_prompt:	.asciiz "You have selected measures of center library\n"
	
	moc_menu_option_quit:	.asciiz "(0) Return to main menu.\n"
	moc_menu_option_avg:	.asciiz "(1) Average (Integers)\n"
	moc_menu_option_avgd:	.asciiz "(2) Average (Doubles)\n"
	moc_menu_option_med:	.asciiz "(3) Median (Integers)\n"
	moc_menu_option_medd:	.asciiz "(4) Median (Doubles)\n"
	moc_menu_option_mod:	.asciiz "(5) Mode (Integers)\n"
.text

# indicates start of code (first instruction to execute)		
moc_main:	
moc_menu_begin:
	print_string ( moc_welcome_prompt )	# prompt user for menu option
	
	# print menu options
	print_string ( moc_menu_option_quit )
	print_string ( moc_menu_option_avg )
	print_string ( moc_menu_option_avgd )
	print_string ( moc_menu_option_med )
	print_string ( moc_menu_option_medd )
	print_string ( moc_menu_option_mod )
	
	# menu option select. bad runtime complexity, I know, but I don't know jump tables
	read_integer ( $t0 )			# read integer from console
	
	# PUT MENU OPTIONS HERE
	# use the $t1 as our comparison register
	# ---------------------------------------------------
	
	# (0) Quit
	li	$t1, 0				# key that must be pressed
	beq	$t1, $t0, menu_begin		# calling code, same for all options
	
	# (1) Average (Integers)
	li	$t1, 1				# key that must be pressed
	la	$t2, avg_main			# library entry point address
	beq	$t1, $t0, moc_call_library	# calling code, same for all options
	
	# (2) Average (Doubles)
	li	$t1, 2				# key that must be pressed
	la	$t2, avgd_main			# library entry point address
	beq	$t1, $t0, moc_call_library	# calling code, same for all options
	
	# (3) Median (Integers)
	li	$t1, 3				# key that must be pressed
	la	$t2, med_main			# library entry point address
	beq	$t1, $t0, moc_call_library	# calling code, same for all options
	
	# (4) Median (Doubles)
	li	$t1, 4				# key that must be pressed
	la	$t2, medd_main			# library entry point address
	beq	$t1, $t0, moc_call_library	# calling code, same for all options
	
	# (5) Mode (Integers)
	li	$t1, 5				# key that must be pressed
	la	$t2, mod_main			# library entry point address
	beq	$t1, $t0, moc_call_library	# calling code, same for all options
	
	# ---------------------------------------------------
	# no options matched, ask again
	print_string ( menu_unknown_prompt )
	j	moc_menu_begin
	
	jr	$t2		# jump to selected function
	j	menu_begin	# return to the menu

moc_call_library:
	jr	$t2	
