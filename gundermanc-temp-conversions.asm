# Temperature Conversions Library
# By: Christian Gunderman

#.include "gundermanc-macros.asm"

.data	# variable declarations follow this line
	tempc_welcome_prompt:	.asciiz "You have selected the Temperature conversions library\n"
	tempc_from_unit_prompt:	.asciiz	"Pick FROM unit\n"
	tempc_to_unit_prompt:	.asciiz	"Pick TO unit\n"
	tempc_bad_unit_prompt:	.asciiz	"Invalid menu option\n"
	tempc_value_prompt:	.asciiz	"What value would you like to convert?\n"
	tempc_output_prompt:	.asciiz "Result : "
	
	# temperature units
	tempc_unit_cel:		.asciiz "(0) Celsius\n"
	tempc_unit_fah:		.asciiz "(1) Fahrenheit\n"
	tempc_unit_kel:		.asciiz "(2) Kelvin\n"
	
	# some temperature constants
	tempc_cel_to_kel: 	.double 273.15
	tempc_far_to_kel: 	.double 459.67
	tempc_far_to_keln:	.double 5
	tempc_far_to_keld:	.double 9
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
	read_double 				# read value from console to $f0
	
	# FROM unit branches..reduce to KELVIN:
	li	$t2, 0				# load 0
	beq	$t0, $t2, tempc_from_cel	# FROM unit == Celsius 
	
	li	$t2, 1				# load 1
	beq	$t0, $t2, tempc_from_far	# FROM unit == Fahrenheit
	
	li	$t2, 2				# load 2
	beq	$t0, $t2, tempc_from_kel	# FROM unit == Kelvin
	# Will be one of the above options...no error check neccessary
	
tempc_from_cel:
	la	$t2, tempc_cel_to_kel		# load address
	l.d	$f2, ($t2)			# load value
	add.d	$f2, $f2, $f0			# FROM += 273.15 -> $f2
	j	tempc_to

tempc_from_far:
	la	$t2, tempc_far_to_kel		# load address
	l.d	$f2, ($t2)			# load value
	add.d	$f2, $f2, $f0			# FROM += 459.67 -> $f2
	
	la	$t2, tempc_far_to_keln		# load address
	l.d	$f0, ($t2)			# load value
	mul.d	$f2, $f0, $f2			# FROM * 5 -> $f2
	
	la	$t2, tempc_far_to_keld		# load address
	l.d	$f0, ($t2)			# load value
	div.d	$f2, $f2, $f0			# FROM / 9 -> $f2
	
	j	tempc_to

tempc_from_kel:
	mov.d	$f2, $f0			# $f0 (FROM) -> $f2
	
tempc_to:
	# TO unit branches..convert to desired times:
	li	$t2, 0				# load 0
	beq	$t1, $t2, tempc_to_cel		# TO unit == Celsius 
	
	li	$t2, 1				# load 1
	beq	$t1, $t2, tempc_to_far		# TO unit == Fahrenheit
	
	li	$t2, 2				# load 2
	beq	$t1, $t2, tempc_to_kel		# TO unit == Kelvin
	# Will be one of the above options...no error check neccessary
	
tempc_to_cel:
	la	$t2, tempc_cel_to_kel		# load address
	l.d	$f0, ($t2)			# load value
	sub.d	$f2, $f2, $f0			# FROM += 273.15 -> $f2
	j	tempc_out

tempc_to_far:
	la	$t2, tempc_far_to_keld		# load address
	l.d	$f0, ($t2)			# load value
	mul.d	$f2, $f2, $f0			# TO *= 9
	
	la	$t2, tempc_far_to_keln		# load address
	l.d	$f0, ($t2)			# load value
	div.d	$f2, $f2, $f0			# TO /= 5
	
	la	$t2, tempc_far_to_kel		# load address
	l.d	$f0, ($t2)			# load value
	sub.d	$f2, $f2, $f0			# FROM -= 459.67 -> $f2

	j	tempc_out
	
tempc_to_kel:
tempc_out:
	print_string ( tempc_output_prompt )
	mov.d 	$f12, $f2
	print_double
	print_string ( newline )
	
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
	li	$t4, 2
	bgt	$v0, $t4, tempc_bad_unit
	
	# check menu option is within valid range
	li	$t4, 0
	blt 	$v0, $t4, tempc_bad_unit
	
	end_routine
	
# invalid unit menu option
tempc_bad_unit:
	print_string ( tempc_bad_unit_prompt )
	j	tempc_unit_menu
	
	
	
