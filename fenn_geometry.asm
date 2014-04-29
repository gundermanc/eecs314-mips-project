# Joe Fennimore
# EECS 340
# 4/19/2014

.data
	geo_intro_str: .asciiz 		"\nWhich of the following shapes\nwould you like to work with?\n----------------------\n"
	shape_select: .asciiz 		"\nEnter the number contained in the square bracket\nthat corresponds with the shape you want\n"
	shapes: .asciiz 		"\nCube[1]\nPrism[2]\nSphere[3]\nCylinder[4]\nCone[5]\n----------------------\n"
	#pi: .double 3.14159265
	six: .double 6
	four_thirds_pi: .double		4.1887902
	one_third: .double		0.3333333
	four_pi: .double		12.566371
	three: .double			3
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
	give_sa: .asciiz		"\nEnter the surface area of your shape\n"
	volume: .asciiz			"\nVolume:  "
	surface_area: .asciiz		"\nSurface Area:  "
	height: .asciiz			"\nHeight:   "
	radius: .asciiz			"\nRadius:   "
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
	beq	$s0, 3, sphere
	beq	$s0, 4, cylinder
	beq	$s0, 5, cone
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

sphere:
	print_string find_radius
	read_integer ($s1)
	beq 	$s1, 1, sphere_vol
	beq	$s1, 2, sphere_sa
	beq	$s1, 3, sphere_find_r
	print_string improper
	j sphere

sphere_vol:				# Sphere vol = 4/3pi*r^3
	print_string give_r
	read_double
	mul.d 	$f2, $f0, $f0
	mul.d 	$f2, $f2, $f0
	l.d	$f4, four_thirds_pi
	mul.d 	$f12, $f2, $f4
	print_string volume
	j	geo_finish

sphere_sa:				# Sphere sa = 4pi*r^2
	print_string give_r
	read_double	
	mul.d 	$f2, $f0, $f0
	l.d	$f4, four_pi
	mul.d 	$f12, $f2, $f4
	print_string surface_area
	j	geo_finish
	
sphere_find_r:				# r = sqrt(sa/4pi)
	print_string give_sa
	read_double
	l.d	$f4, four_pi
	div.d	$f12, $f0, $f4
	sqrt.d	$f12, $f12
	print_string radius
	j	geo_finish
	
cylinder:
	print_string find_radius
	print_string find_height4
	read_integer ($s1)
	beq 	$s1, 1, cyl_vol
	beq	$s1, 2, cyl_sa
	beq	$s1, 3, cyl_find_r
	beq	$s1, 4, cyl_find_h
	print_string improper
	j cylinder

cyl_vol:
	jal	get_rh
	jal	cyl_cone_vol
	print_string volume
	j	geo_finish
	
cyl_cone_vol:				# Both cylinders and cones must compute this value - reduce redundancy
	l.d	$f4, pi			# f4 = pi
	mul.d	$f2, $f2, $f2		# f2 = r^2
	mul.d	$f12, $f2, $f4		# f12 = pi * r^2
	mul.d	$f12, $f12, $f0		# vol = pi * r^2 * h
	jr	$ra

cyl_sa:
	jal	get_rh
	l.d	$f4, two_pi		# f4 = 2pi
	mul.d	$f12, $f2, $f4		# f12 = 2pi * r
	mul.d	$f12, $f12, $f0		# f12 = 2pi * r * h
	mul.d	$f2, $f2, $f2
	mul.d	$f2, $f2, $f4		# f4 = 2pi * r^2
	add.d	$f12, $f12, $f2		# sa = 2pi*r*h + 2(pi*r^2)
	print_string surface_area
	j	geo_finish				
	
	
cyl_find_r:				# r = sqrt(vol/(h*pi))
	jal	cyl_cone_find_r
	print_string radius
	j	geo_finish
	
cyl_cone_find_r:			# Both cylinders and cones must compute this value - reduce redundancy
	print_string give_h
	read_double
	mov.d	$f2, $f0
	print_string give_v
	read_double
	l.d	$f4, pi
	div.d	$f12, $f0, $f2		# vol/h
	div.d	$f12, $f12, $f4		# vol/(h*pi)
	sqrt.d	$f12, $f12		# sqrt(vol/h*pi)
	jr	$ra
		
cyl_find_h:				# h = vol/(pi*r^2)
	jal	cyl_cone_find_h
	print_string height
	j	geo_finish
	
cyl_cone_find_h:			# Both cylinders and cones must compute this value - reduce redundancy
	print_string give_r
	read_double
	mov.d	$f2, $f0
	print_string give_v
	read_double
	l.d	$f4, pi
	mul.d	$f2, $f2, $f2		# r^2
	mul.d	$f2, $f2, $f4		# pi*r^2
	div.d	$f12, $f0, $f2		# vol/(pi*r^2)
	jr	$ra

get_rh:					# Gets the radius and height and puts them in f2 and f0 respectively
	print_string give_r
	read_double
	mov.d 	$f2, $f0		# f2 = r
	print_string give_h
	read_double			# f0 = h
	jr	$ra
	

cone:
	print_string find_radius
	print_string find_height4
	read_integer ($s1)
	beq 	$s1, 1, cone_vol
	beq	$s1, 2, cone_sa
	beq	$s1, 3, cone_find_r
	beq	$s1, 4, cone_find_h
	print_string improper
	j cone

cone_vol:
	jal	get_rh
	jal	cyl_cone_vol
	l.d	$f4, one_third
	mul.d	$f12, $f12, $f4
	print_string volume
	j	geo_finish

cone_sa:			# sa = pi*r * (r + sqrt(h^2 + r^2))
	jal	get_rh
	mul.d	$f6, $f2, $f2	# f6 = r^2
	mul.d	$f8, $f0, $f0	# f8 = h^2
	add.d	$f6, $f8, $f6	# f6 = r^2 + h^2
	sqrt.d	$f6, $f6	# f6 = sqrt(h^2 + r^2)
	add.d	$f6, $f6, $f2	# f6 = r + sqrt(h^2 + r^2)
	l.d	$f4, pi
	mul.d	$f2, $f2, $f4	# f2 = pi*r
	mul.d	$f12, $f2, $f6	# f12 = pi*r * (r + sqrt(h^2 + r^2))
	print_string surface_area
	j	geo_finish
	
cone_find_r:			# r = sqrt(3*vol/(pi*h))
	jal	get_rh
	jal	cyl_cone_find_r
	l.d	$f4, three
	sqrt.d	$f4, $f4
	mul.d	$f12, $f12, $f4
	print_string radius
	j	geo_finish
	
cone_find_h:			# h = 3*vol/(pi*r^2)
	jal	get_rh
	jal	cyl_cone_find_h
	l.d	$f4, three
	mul.d	$f12, $f12, $f4
	print_string radius
	j	geo_finish
	

geo_finish:			# finishes the program by printing out the double of whatever value was calculated then returns to main menu.
	print_double
# returns to the main menu
# TODO: this works, why does this work !?!?!
        print_string ( newline )
        j 	main_menu