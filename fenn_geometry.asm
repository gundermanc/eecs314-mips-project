# Joe Fennimore
# EECS 340
# 4/19/2014

.data
	geo_intro_str: .asciiz 		"\nWhich of the following shapes\nwould you like to work with?\n----------------------\n"
	shape_select: .asciiz 		"\nEnter the number contained in the square bracket\nthat corresponds with the shape you want\n"
	shapes: .asciiz 		"\nCube[1]\nPrism[2]\nSphere[3]\nCylinder[4]\nCone[5]\n----------------------\n"
	#pi: .double 3.14159265
	six: .double 6
	geo_func_select: .asciiz	"Enter the number in square brackets that corresponds\nto the function you'd like to perform on this shape\n"
	geo_functions: .asciiz		"\nVolume[1]\nSurface Area[2]\n"
	find_radius: .asciiz		"Find Radius[3]\n"
	find_height3: .asciiz		"Find Height[3]\n"
	find_height4: .asciiz		"Find Height[4]\n"
	give_w: .asciiz			"\nEnter width w\n"
	give_r: .asciiz			"\nEnter radius r\n"
	give_l: .asciiz			"\nEnter length l\n"
	give_h: .asciiz			"\nEnter height h\n"
	give_v: .asciiz			"\nEnter the volume of your shape\n"
	volume: .asciiz			"\nVolume:  "
	surface_area: .asciiz		"\nSurface Area:  "
	height: .asciiz			"\nHeight:   "
	improper: .asciiz		"\nI'm sorry, but you have entered an\nimproper value.  Please try again.\n"
	
.text
geometry_main:	
	print_string geo_intro_str
	print_string shape_select
	print_string shapes
	
	read_integer ($s0)
	
	print_string geo_func_select
	print_string geo_functions
	
	
	beq	$s0, 1, cube
	beq	$s0, 2, prism	# check which function was selected
	#beq	$s0, 3, sphere
	#beq	$s0, 4, cylinder
	#beq	$s0, 5, cone
	print_string improper
	j geometry_main
	
	
cube:
	read_integer ($s1)
	beq 	$s1, 1, cube_vol
	beq	$s1, 2, cube_sa
	print_string improper
	j cube			
							
cube_vol:
	print_string give_w
	read_double		# loads x into f0
	mul.d 	$f2, $f0, $f0	# f1 = x^2
	mul.d 	$f12, $f2, $f0	# f12 = x^3
	print_string volume
	j 	geo_finish
	
cube_sa:
	print_string give_x
	read_double		# loads x into f0
	mul.d 	$f2, $f0, $f0	# f1 = x^2
	l.d 	$f4, six
	mul.d 	$f12, $f2, $f4	# x^2 * 6
	print_string surface_area
	j 	geo_finish
	
prism:
	print_string find_height3
	read_integer ($s1)
	beq 	$s1, 1, prism_vol
	beq	$s1, 2, prism_sa
	beq	$s1, 3, prism_find_h
	print_string improper
	j prism			
	
prism_vol:
	jal prism_wlh
	mul.d $f2, $f2, $f4	# width * length
	mul.d $f12, $f2, $f0	# width * length * height
	print_string volume
	j	geo_finish
	
prism_sa:
	jal prism_wlh
	mul.d $f6, $f2, $f4	# width * length
	mul.d $f8, $f2, $f0	# width * height
	mul.d $f10, $f4, $f0	# length * height
	add.d $f6, $f6, $f6	# multiply each of those by 2
	add.d $f8, $f8, $f8
	add.d $f10, $f10, $f10
	add.d $f12, $f6, $f8
	add.d $f12, $f12, $f10 	# sa = 2wl + 2wh + 2lh
	print_string surface_area
	j	geo_finish

prism_find_h:
	print_string give_w	# f2 = width, f4 = length, f0 = volume
	read_double
	mov.d	$f2, $f0
	print_string give_l
	read_double
	mov.d	$f4, $f0
	print_string give_v
	read_double
	mul.d	$f4, $f4, $f2
	div.d	$f12, $f0, $f4
	print_string height
	j	geo_finish
	

prism_wlh:			# Gets the values for width, length, and height and stores them in f2, f4, and f0 respectively
	print_string give_w
	read_double
	mov.d	$f2, $f0
	print_string give_l
	read_double
	mov.d	$f4, $f0
	print_string give_h
	read_double
	jr	$ra
	

geo_finish:			# finishes the program by printing out the double of whatever value was calculated then returns to main menu.
	print_double
# returns to the main menu
# TODO: this works, why does this work !?!?!
        print_string ( newline )
        j 	main_menu