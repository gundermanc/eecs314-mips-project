# Conversions Program Module
# By: Christian Gunderman

#.include "gundermanc-macros.asm"

.include "gundermanc-temp-conversions.asm"

.data	# variable declarations follow this line
	conv_welcome_prompt:	.asciiz "You have selected the conversions library\n"
	
	conv_menu_option_quit:	.asciiz "(0) Return to main menu.\n"
	conv_menu_option_tempc: .asciiz "(1) Temperature Conversions\n"
.text

# indicates start of code (first instruction to execute)		
conv_main:	
conv_menu_begin:
	print_string ( conv_welcome_prompt )	# prompt user for menu option
	
	# print menu options
	print_string ( conv_menu_option_quit )
	print_string ( conv_menu_option_tempc )
	
	# menu option select. bad runtime complexity, I know, but I don't know jump tables
	read_integer ( $t0 )			# read integer from console
	
	# PUT MENU OPTIONS HERE
	# use the $t1 as our comparison register
	# ---------------------------------------------------
	
	# (0) Quit
	li	$t1, 0				# key that must be pressed
	beq	$t1, $t0, menu_begin		# calling code, same for all options
	
	# (1) Temperature Conversions
	li	$t1, 1				# key that must be pressed
	la	$t2, tempc_main			# library entry point address
	beq	$t1, $t0, conv_call_library	# calling code, same for all options
	
	# ---------------------------------------------------
	# no options matched, ask again
	print_string ( menu_unknown_prompt )
	j	conv_menu_begin
	
	jr	$t2		# jump to selected function
	j	menu_begin	# return to the menu

conv_call_library:
	jr	$t2	
