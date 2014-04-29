# Lengths Conversions Library
# By: Christian Gunderman

#.include "gundermanc-macros.asm"

.data	# variable declarations follow this line
	len_welcome_prompt:	.asciiz "You have selected the lengths conversions library\n"
	len_from_unit_prompt:	.asciiz	"Pick FROM unit\n"
	len_to_unit_prompt:	.asciiz	"Pick TO unit\n"
	len_bad_unit_prompt:	.asciiz	"Invalid menu option\n"
	len_value_prompt:	.asciiz	"What value would you like to convert?\n"
	len_output_prompt:	.asciiz "Result : "
	
	# length units
	len_unit_feet:		.asciiz "(0) Feet\n"
	len_unit_inch:		.asciiz "(1) Inches\n"
	len_unit_mile:		.asciiz "(2) Miles\n"
	len_unit_yard:		.asciiz "(3) Yards\n"
	len_unit_metr:		.asciiz "(4) Meters\n"
	len_unit_kimr:		.asciiz "(5) Kilometers\n"
	
	# some length constants for conversion to feet
	len_const_feet:	 	.double 1
	len_const_inch:	 	.double .08333333333333  # 1/12
	len_const_mile:		.double 5280
	len_const_yard:		.double 3 # 1/3
	len_const_metr:		.double 3.280839895
	len_const_kimr:		.double 3280.839895
.text
	
len_main:
	print_string ( len_welcome_prompt )	# print welcome message
len_from_unit:
	print_string ( len_from_unit_prompt )	# ask for "FROM" unit
	jal	len_unit_menu			# get the FROM unit from user, store in $v0
	move	$t0, $v0			# store FROM unit in $t0
	
	print_string ( len_to_unit_prompt )	# ask for "TO" unit
	jal	len_unit_menu			# get the TO unit from user, store in $v0
	move	$t1, $v0			# store TO unit in $t1
	
	print_string ( len_value_prompt )	# prompt user for the value
	read_double 				# read value from console to $f0
	mov.d	$f2, $f0
	
	# FROM unit branches..reduce to FEET:
	li	$t2, 0				# load 0
	beq	$t0, $t2, len_from_feet		# FROM unit == Feet 
	
	li	$t2, 1				# load 1
	beq	$t0, $t2, len_from_inch		# FROM unit == Inches
	
	li	$t2, 2				# load 2
	beq	$t0, $t2, len_from_mile		# FROM unit == Miles
	
	li	$t2, 3				# load 3
	beq	$t0, $t2, len_from_yard		# FROM unit == Yard
	
	li	$t2, 4				# load 4
	beq	$t0, $t2, len_from_metr		# FROM unit == Meter
	
	li	$t2, 5				# load 5
	beq	$t0, $t2, len_from_kimr		# FROM unit == Kilometer
	# Will be one of the above options...no error check neccessary
	
len_from_feet:
	la	$t2, len_const_feet		# load address
	l.d	$f0, ($t2)			# load value
	mul.d	$f2, $f2, $f0			# multiply by ratio
	j	len_to
	
len_from_inch:
	la	$t2, len_const_inch		# load address
	l.d	$f0, ($t2)			# load value
	mul.d	$f2, $f2, $f0			# multiply by ratio
	j	len_to
	
len_from_mile:
	la	$t2, len_const_mile		# load address
	l.d	$f0, ($t2)			# load value
	mul.d	$f2, $f2, $f0			# multiply by ratio
	j	len_to
	
len_from_yard:
	la	$t2, len_const_yard		# load address
	l.d	$f0, ($t2)			# load value
	mul.d	$f2, $f2, $f0			# multiply by ratio
	j	len_to
	
len_from_metr:
	la	$t2, len_const_metr		# load address
	l.d	$f0, ($t2)			# load value
	mul.d	$f2, $f2, $f0			# multiply by ratio
	j	len_to
	
len_from_kimr:
	la	$t2, len_const_kimr		# load address
	l.d	$f0, ($t2)			# load value
	mul.d	$f2, $f2, $f0			# multiply by ratio
	j	len_to
	
len_to:
	# TO unit branches..convert to desired times:
	li	$t2, 0				# load 0
	beq	$t1, $t2, len_to_feet		# TO unit == FEET
	
	li	$t2, 1				# load 1
	beq	$t1, $t2, len_to_inch		# TO unit == INCH
	
	li	$t2, 2				# load 2
	beq	$t1, $t2, len_to_mile		# TO unit == MILE
	
	li	$t2, 3				# load 3
	beq	$t1, $t2, len_to_yard		# TO unit == YARD
	
	li	$t2, 4				# load 4
	beq	$t1, $t2, len_to_metr		# TO unit == METER
	
	li	$t2, 5				# load 5
	beq	$t1, $t2, len_to_kimr		# TO unit == KILOMETER
	# Will be one of the above options...no error check neccessary
	
len_to_feet:
	la	$t2, len_const_feet		# load address
	l.d	$f0, ($t2)			# load value
	div.d	$f2, $f2, $f0			# multiply by ratio
	j	len_out
	
len_to_inch:
	la	$t2, len_const_inch		# load address
	l.d	$f0, ($t2)			# load value
	div.d	$f2, $f2, $f0			# multiply by ratio
	j	len_out
	
len_to_mile:
	la	$t2, len_const_mile		# load address
	l.d	$f0, ($t2)			# load value
	div.d	$f2, $f2, $f0			# multiply by ratio
	j	len_out
	
len_to_yard:
	la	$t2, len_const_yard		# load address
	l.d	$f0, ($t2)			# load value
	div.d	$f2, $f2, $f0			# multiply by ratio
	j	len_out
	
len_to_metr:
	la	$t2, len_const_metr		# load address
	l.d	$f0, ($t2)			# load value
	div.d	$f2, $f2, $f0			# multiply by ratio
	j	len_out
	
len_to_kimr:
	la	$t2, len_const_kimr		# load address
	l.d	$f0, ($t2)			# load value
	div.d	$f2, $f2, $f0			# multiply by ratio
	j	len_out
	
len_out:
	print_string ( len_output_prompt )
	mov.d 	$f12, $f2
	print_double
	print_string ( newline )
	
	j	conv_menu_begin			# return to the conversions menu
	
	
# get the ID of the desired unit by prompting the user
len_unit_menu:
	begin_routine
	
	# print menu options
	print_string ( len_unit_feet )
	print_string ( len_unit_inch )
	print_string ( len_unit_mile )
	print_string ( len_unit_yard )
	print_string ( len_unit_metr )
	print_string ( len_unit_kimr )
	
	read_integer ( $v0 )			# prompt user for menu option
	
	# check menu option is within valid range
	li	$t4, 5
	bgt	$v0, $t4, len_bad_unit
	
	# check menu option is within valid range
	li	$t4, 0
	blt 	$v0, $t4, len_bad_unit
	
	end_routine
	
# invalid unit menu option
len_bad_unit:
	print_string ( len_bad_unit_prompt )
	j	len_unit_menu
	
	
	
