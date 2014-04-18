# Conversions Program Module
# By: Christian Gunderman

.data	# variable declarations follow this line
	conv_welcome_prompt:	.asciiz ""
	
	# Macros:

	
.text       # instructions follow this line
# indicates start of code (first instruction to execute)		
conv_main:	
	# push return address to stack
	#addi	$sp, $sp, -4		# move stack pointer
	#sw 	$ra, ($sp)		# store return address

	#print_string welcome_prompt
	li	$t0, 2342424
	print_integer ( $t0 )

	# pop return address to return address register
	#lw	$ra, ($sp)		# load return address to $ra
	#addi	$sp, $sp, 4		# move stack pointer
	
	# since this is MARS and MARS doesn't call main, we have no return value,
	# so we just exit instead
	exit
