# Joe Fennimore
# EECS 340
# 4/19/2014

# Perform various math functions
.include "proj.asm"

.data
	intro_str: .asciiz 		"\nWhich of the following functions\nwould you like to use?\n----------------------\n"
	newline: .asciiz 		"\n"
	func_select: .asciiz 		"\nEnter the number contained in the square bracket\nthat corresponds with the function you want\n"
	functions: .asciiz 		"\nSin(x)[1]\nCos(x)[2]\nTan(x)[3]\nSec(x)[4]\n----------------------\n"
	give_x: .asciiz 		"\nPlease give your value of x\n"
	tol: .double 1.0e-15       	# tolerance for sqrt
	zero: .double 0.0
	one:  .double 1.0
	neg_one: .double -1.0
	pi: .double 3.14159265		
	two_pi: .double 6.28318531
	pi_div_2: .double 1.57079632
	c1: .double 1.27323954
	c2: .double .405284735
	c3: .double .225

.text

	printstr intro_str
		
	printstr func_select
	
	printstr functions
	
	jal 	readint		# read the function selection
	move	$s0, $v0	# store it in s0
		
	printstr give_x
	jal 	readDouble	# x is stored in f0
	beq	$s0, 1, high_pres_sin	# check which function was selected
	beq	$s0, 2, cos
	beq	$s0, 3, tan
	beq	$s0, 4, sec
	beq	$s0, 5, csc
	beq	$s0, 6, cot

	mov.d 	$f12, $f0	# result in f0 is moved to f12 for the print double syscall	
	jal	printdb
	jr 	$ra

normalize_x:			# Put x in the range between -PI and PI
	l.d	$f2, pi		# Load in constants
	l.d	$f4, neg_one
	mul.d	$f4, $f4, $f2	# -3.14
	c.lt.d	$f4, $f0	# if (x < -3.14)
	bc1f	add_two_pi	# x += 6.28
	c.lt.d	$f0, $f2	# else if (x > 3.14)
	bc1f	sub_two_pi	# x -= 6.28
	jr	$ra

add_two_pi:			# x += 2 * PI
	l.d	$f6, two_pi
	add.d	$f0, $f0, $f6
	j	normalize_x

sub_two_pi:			# x -= 2 * PI
	l.d	$f6, two_pi
	sub.d	$f0, $f0, $f6
	j	normalize_x

sin:
	move	$s0, $ra	# store the return address
	jal 	normalize_x	# Normalize x to a range between -PI and PI
	move	$ra, $s0	# Restore return address
	l.d	$f6, c1		# Use f6 as a holder for constants
	mul.d	$f2, $f0, $f6	# 1.27323954 * x
	mul.d	$f4, $f0, $f0	# x^2
	l.d	$f6, c2		# f6 = .405284735
	mul.d	$f4, $f4, $f6	# .405284735 * x^2
	l.d	$f6, zero	# f6 = 0
	c.lt.d 	$f6, $f0	# if (x < 0)
	bc1f	sinlt		# go to label sinlt
	sub.d	$f0, $f2, $f4	# else 1.27323954 * x - .405284735 * x^2
	jr	$ra
sinlt:
	add.d	$f0, $f2, $f4	# 1.27323954 * x + .405284735 * x^2
	jr	$ra	
	
high_pres_sin:			# the first approximation of sin was not accurate enough, so this
	move	$s4, $ra	# increases the accuracy.
	jal	sin		# calculate sin(x) and put it in f0
	move	$ra, $s4	
	l.d	$f6, zero
	c.lt.d	$f6, $f0	# if sin(x) < 0
	bc1f	high_pres_sin_lt# go to the less than label
	mul.d	$f2, $f0, $f0	# else f2 = sin^2
	sub.d	$f4, $f2, $f0	# f4 = sin^2 - sin
	l.d	$f6, c3
	mul.d	$f8, $f4, $f6	# .225 (sin^2 - sin)
	add.d	$f0, $f8, $f0	# .225 (sin^2 - sin) + sin
	jr	$ra
	
high_pres_sin_lt:
	mul.d	$f2, $f0, $f0	# f2 = sin^2
	l.d	$f6, neg_one
	mul.d	$f2, $f2, $f6	# -(sin^2)
	sub.d	$f4, $f2, $f0	# f4 = -(sin^2) - sin
	l.d	$f6, c3
	mul.d	$f8, $f4, $f6	# .225 * (-sin^2 - sin)
	add.d	$f0, $f8, $f0	# .225 * (-sin^2 - sin) + sin
	jr	$ra
	
cos:				# cos(x) = sin(x + pi/2)
	move	$s1, $ra
	l.d	$f6, pi_div_2
	add.d	$f0, $f0, $f6 	# x = x + pi/2
	jal 	high_pres_sin
	move	$ra, $s1
	jr	$ra

tan:
	move	$s2, $ra	# store return address
	mov.d	$f8, $f0	# save original value of x
	jal	high_pres_sin	# compute sin(x)
	mov.d	$f10, $f0	# store sin(x) in f10
	mov.d	$f0, $f8	# restore f0 to x
	jal	cos		# compute cos(x)
	mov.d	$f4, $f0	# store cos(x) in f4
	div.d	$f0, $f10, $f4	# compute tan(x) = sin(x)/cos(x)
	move	$ra, $s2	# restore return address
	jr	$ra

sec:	
	move 	$s3, $ra
	l.d	$f10, one	# f10 = 1
	jal	cos		# f0 = cos(x)
	div.d	$f0, $f10, $f0	# sec(x) = 1/cos(x)
	move	$ra, $s3
	jr	$ra

csc:
	move	$s5, $ra
	l.d	$f10, one	# f10 = 1
	jal	high_pres_sin	# f0 = sin(x)
	div.d	$f0, $f10, $f0	# csc(x) = 1/sin(x)
	move	$ra, $s5
	jr	$ra
	
cot:
	move	$s6, $ra
	l.d	$f14, one	# f14 = 1 -not f10 this time b/c it is used in calculating tan(x)
	jal	tan		# f0 = tan(x)
	div.d	$f0, $f14, $f0	# cot(x) = 1/tan(x)
	move	$ra, $s6
	jr	$ra
	
	

#####################################################################
#   Square Root using Newton-Raphson Iteration  (Newton's Method)
#####################################################################
#   x' = x - f(x)/f'(x)
#   x' = x - (x^2 - D) / (2*x)  -  to calculate Sqrt(D)
#####################################################################
sqrt:
	l.d   $f10, tol
    	mov.d   $f2, $f0
subsqrt:
    	mov.d   $f8, $f2        # save old x in $f8
   	mul.d   $f4, $f2, $f2   # $f4 = x^2
    	sub.d   $f4, $f4, $f0   # $f4 = x^2 - D
    	add.d   $f6, $f2, $f2   # $f6 = 2*x
    	div.d   $f4, $f4, $f6   # $f4 = (x^2 - D) / (2*x)
    	sub.d   $f2, $f2, $f4   # $f2 = x - (x^2 - D) / (2*x)
    	sub.d   $f8, $f8, $f2   # $f8 = oldX - x
    	abs.d   $f8, $f8        # $f8 = | oldX - x |
    	c.lt.d  $f8, $f10       # if | oldX - x | < tol, then set flag
    	bc1f    subsqrt         # if flag not set, jump to sqrt
    	mov.d   $f0, $f2        # result = $f0
    	jr	$ra             # return to caller




	
