# Temperature Conversions Library
# By: Christian Gunderman

#.include "gundermanc-macros.asm"

.data	# variable declarations follow this line
	tempc_welcome_prompt:	.asciiz "You have selected the Temperature conversions library\n"
	tempc_from_unit_prompt:	.asciiz	"Pick FROM unit\n"
	tempc_to_unit_prompt:	.asciiz	"Pick TO unit\n"
	tempc_bad_unit_prompt:	.asciiz	"Invalid menu option\n"
	tempc_value_prompt:	.asciiz	"What value would you like to convert?\n"
	
	# temperature units
	tempc_unit_cel:		.asciiz "(0) Celsius\n"
	tempc_unit_fah:		.asciiz "(1) Fahrenheit\n"
	tempc_unit_kel:		.asciiz "(2) Kelvin\n"
.text
	
tempc_main:
	print_string ( tempc_welcome_prompt )	# print welcome message
tempc_from_unit:
	print_string ( tempc_from_unit_prompt ) # ask for "FROM" unit
	jal	tempc_unit_menu			# get the FROM unit from user, store in $v0
	move	$t0, $v0			# store FROM unit in $t0
	
	print_string ( tempc_to_unit_prompt )	# ask for "TO" unit
	jal	tempc_unit_menu			# get the TO unit from user, store in $v0
	move	$t1, $v0			# store TO unit in $t1
	
	print_string ( tempc_value_prompt )	# prompt user for the value
	read_float ( $f1 )			# read value from console
	
	#li	$t0, 0
	#beq	$v0, $t0, tempc_from_cel	# incoming number
	
	
	
	j	conv_menu_begin			# return to the conversions menu
	
	
# get the ID of the desired unit by prompting the user
tempc_unit_menu:
	begin_routine
	
	# print menu options
	print_string ( tempc_unit_cel )
	print_string ( tempc_unit_fah )
	print_string ( tempc_unit_kel )
	
	read_integer ( $v0 )			# prompt user for menu option
	
	# check menu option is within valid range
	li	$t0, 2
	bgt	$v0, $t0, tempc_bad_unit
	
	# check menu option is within valid range
	li	$t0, 0
	blt 	$v0, $t0, tempc_bad_unit
	
	end_routine
	
# invalid unit menu option
tempc_bad_unit:
	print_string ( tempc_bad_unit_prompt )
	j	tempc_unit_menu
	
	
	