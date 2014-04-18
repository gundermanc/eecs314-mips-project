# Temperature Conversions Library
# By: Christian Gunderman

#.include "gundermanc-macros.asm"

.data	# variable declarations follow this line
	tempc_welcome_prompt:	.asciiz "You have selected the Temperature conversions library\n"
	
	tempc_menu_option_quit:	.asciiz "(0) Return to menu."
.text

# indicates start of code (first instruction to execute)		
tempc_main:	
	begin_routine				# push return to stack
tempc_menu_begin:
	print_string ( tempc_welcome_prompt )	# prompt user for menu option
	
	# print menu options
	print_string ( tempc_menu_option_quit )
	
	# menu option select. bad runtime complexity, I know, but I don't know jump tables
	read_integer ( $t0 )			# read integer from console
	
	# PUT MENU OPTIONS HERE
	# use the $t1 as our comparison register
	# ---------------------------------------------------
	
	# (0) Quit
	li	$t1, 0				# key that must be pressed
	beq	$t1, $t0, conv_menu_begin	# calling code, same for all options
	
	# ---------------------------------------------------
	# no options matched, ask again
	print_string ( menu_unknown_prompt )
	j	tempc_menu_begin
	
	jr	$t2		# jump to selected function
	j	tempc_menu_begin # return to the main menu
	end_routine
	
