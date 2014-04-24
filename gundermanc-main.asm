# Math Library Entry Point
# Christian Gunderman

.include "gundermanc-macros.asm"


.data	# variable declarations follow this line
	welcome_prompt:		.asciiz "EECS314 Math Operations Library\n"
	author_prompt:		.asciiz "By: Christian, Elliot, Laura, and Phillip\n\n"
	
	menu_prompt:		.asciiz "\nPick a math library to work with:\n"
	
	menu_option_quit:	.asciiz	"(0) Quit\n"
	menu_option_conv:	.asciiz "(1) Conversions Functions\n"
	menu_option_moc:	.asciiz "(2) Measures of Center (avg, median, etc)\n"
	menu_option_trig:	.asciiz "(3) Trigonometry\n"
	menu_option_math:	.asciiz "(4) Math (pow, fact, log)\n"
	
	exit_prompt:		.asciiz "\n\nGood bye! :)"
	
.text 
# call entry point because MARS is lousy and doesn't do it for us
	jal	main
	exit

# library code should be included here:
.include "gundermanc-conversions.asm"
.include "gundermanc-centers.asm"
.include "fenn_trig.asm"
.include "ee-menu.asm"

# entry point routine
main:
	begin_routine				# push return to stack
	
	# print welcome strings
	clear_console				# clear the console before welcome message
	print_string ( welcome_prompt )		# print library welcome string
	print_string ( author_prompt )		# print library author string
	
	# enter the main menu
	j	main_menu
	
	end_routine				# pop and return
	
# main menu routine
main_menu:
menu_begin:
	print_string ( menu_prompt )		# prompt user for menu option
	
	# print menu options
	print_string ( menu_option_conv )
	print_string ( menu_option_moc )
	print_string ( menu_option_trig )
	print_string ( menu_option_math )
	print_string ( menu_option_quit )
	
	# menu option select. bad runtime complexity, I know, but I don't know jump tables
	read_integer ( $t0 )			# read integer from console
	
	# PUT MENU OPTIONS HERE
	# use the $t1 as our comparison register
	# ---------------------------------------------------
	
	# (0) Quit
	li	$t1, 0				# key that must be pressed
	la	$t2, quit			# exit routine address
	beq	$t1, $t0, call_library		# calling code, same for all options
	
	# (1) Conversions Library
	li	$t1, 1				# key that must be pressed
	la	$t2, conv_main			# library entry point address
	beq	$t1, $t0, call_library		# calling code, same for all options
	
	# (2) Measures of Center Library
	li	$t1, 2				# key that must be pressed
	la	$t2, moc_main			# library entry point address
	beq	$t1, $t0, call_library		# calling code, same for all options
	
	# (3) Trigonometry
	li	$t1, 3				# key that must be pressed
	la	$t2, trig_main			# library entry point address
	beq	$t1, $t0, call_library		# calling code, same for all options
	
	# (4) Math
	li	$t1, 4				# key that must be pressed
	la	$t2, ee_main			# library entry point address
	beq	$t1, $t0, call_library		# calling code, same for all options
	
	# ---------------------------------------------------
	# no options matched, ask again
	print_string ( menu_unknown_prompt )
	j	menu_begin
	
call_library:
	jr	$t2	
	
	
# exit program function
quit:
	print_string ( exit_prompt )
	exit
	
