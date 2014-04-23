# Joe Fennimore
# EECS 340
# 4/19/2014

.data
	intro_str: .asciiz 		"\nWhich of the following shapes\nwould you like to work with?\n----------------------\n"
	newline: .asciiz 		"\n"
	shape_select: .asciiz 		"\nEnter the number contained in the square bracket\nthat corresponds with the shape you want\n"
	shapes: .asciiz 		"\nCube[1]\nPrism[2]\nSphere[3]\nCylinder[4]\nCone[5]\n----------------------\n"
	pi: .double 3.14159265
	func_select: .asciiz		"Enter the number in square brackets that corresponds\nto the function you'd like to perform on this shape\n"
	functions: .asciiz		"\nVolume[1]\nSurface Area[2]"
	find_radius: .asciiz		"\nFind Radius[3]"
	find_height: .asciiz		"\nFind Height[4]"
	give_x: .asciiz			"\nEnter width x"

printdb:			# Prints what is stored in f12 as a double
	li $v0, 3
	syscall
	jr $ra

readint:			# Reads the value in a0 into v0
	li $v0, 5
	syscall
	jr $ra

readDouble:		# Read double value in a0 into f0
	li $v0, 7
	syscall
	jr $ra
