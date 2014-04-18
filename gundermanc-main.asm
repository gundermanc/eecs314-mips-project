# Math Library Entry Point
# Christian Gunderman

.include "gundermanc-macros.asm"


.data	# variable declarations follow this line
	welcome_prompt:		.asciiz "EECS314 Math Operations Library\n"
	author_prompt:		.asciiz "By: Christian, Laura, Elliot, and Phillip\n\n"
	
	menu_prompt:		.asciiz "\nPick a math library to work with:\n"
	
	menu_option_quit:	.asciiz	"(0) Quit\n"
	menu_option_conv:	.asciiz "(1) Conversions Functions\n"
	
	exit_prompt:		.asciiz "\n\nGood bye! :)"
	
.text 
# call entry point because MARS is lousy and doesn't do it for us
	jal	main
	exit

# library code should be included here:
.include "gundermanc-conversions.asm"

# entry point routine
main:
	begin_routine				# push return to stack
	
	# print welcome strings
	print_string ( welcome_prompt )		# print library welcome string
	print_string ( author_prompt )		# print library author string
	
	# enter the main menu
	call ( main_menu )
	
	end_routine				# pop and return
	
# main menu routine
main_menu:
	begin_routine				# push return to stack
menu_begin:
	print_string ( menu_prompt )		# prompt user for menu option
	
	# print menu options
	print_string ( menu_option_conv )	
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
	
	# ---------------------------------------------------
	# no options matched, ask again
	print_string ( menu_unknown_prompt )
	j	menu_begin
	
call_library:

	jr	$t2		# pseudo "jal" to library entry point
	j	menu_begin	# return to the menu
	
	end_routine
	
# exit program function
quit:
	print_string ( exit_prompt )
	exit
	