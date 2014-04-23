# Joe Fennimore
# EECS 340
# 4/19/2014

# Perform various math functions

.macro printstr	(%string)	# Prints what is stored in a0 as a string
	la $a0, %string
	li $v0, 4
	syscall
.end_macro
 






