######################################################################################
# Square Matrix Multiplier
# by Phil Blackburn
# Multiplies square matrices up to size 10 x 10
# Can double-check correctness @ http://www.bluebit.gr/matrix-calculator/multiply.aspx
######################################################################################

#.include "gundermanc-macros.asm"	# include not needed when part of the bigger application

.data      
                                     
pabb_newline:
	.asciiz	"\n"
	.align	2
num_size:
	.space	40	# n*n : size of the square matrix to be computed
delimiter:
	.asciiz ","
input_size:
	.asciiz "Input the number of rows/columns for your matrices (max = 10):"
input_mat1:
	.asciiz "Input the elements of the first matrix sequentially (first row, second row...) and hit enter after each element: "
input_mat2:
	.asciiz "Input the elements of the second matrix sequentially (first row, second row...) and hit enter after each element: "
prompt:
	.asciiz "Enter next integer: "
	.align	2	# only have this so that Mat1 ends up on word boundary ... yeah, I don't know why that would be required either

# Each matrix can hold up to 100 elements (10 rows/cols)
.align	4
	Mat1:	.space 400	# input matrix
	Mat2:	.space 400	# input matrix
	Mat3:	.space 400	# result matrix

.text                                               

	j main
	
mat_mult_main:
	la $s0, num_size	# initialize the address of num_size
	la $s1, Mat1		# initialize Mat1 address
	la $s2, Mat2		# initialize Mat2 address
	la $s3, Mat3		# initialize Mat3 address
	li $s4, 0		# initialize i counter
	li $s5, 0		# initialize j counter
	li $s6, 0		# initialize k counter	
	li $t5, 0		# initialize $t5 as a counter for our input feed	
	j feed_input		# begin getting user input to fill matrices

feed_input:	
	# prompt to get row/col size
	la $a0, input_size
	li $v0, 4
	syscall
	
	# insert pabb_newline
	la $a0, pabb_newline
	li $v0, 4
	syscall
	
	# read in row/col size
	li $v0, 5
	syscall
	
	# store value in num_size
	sw $v0, ($s0)		# store row/col size in num_size 
	lw $s0, 0($s0)		# load the value contained in num_size
	
	# create stopping condition for getting input for a matrix : user will input num_size*num_size elements for each matrix
	li $t0, 0
	addi $t0, $s0, 0	# t0 = num_size ($t0 will be our counter's ceiling)
	mult $s0, $t0		# num_size^2
	mflo $t0		# move result to $t0	
	
	# prompt to get Mat1 elements
	la $a0, input_mat1
	li $v0, 4
	syscall
	
	# insert pabb_newline
	la $a0, pabb_newline
	li $v0, 4
	syscall
	
	mat1_input:
	# prompt for next integer
	la $a0, prompt
	li $v0, 4
	syscall
	
	# get next Mat1 element
	li $v0, 5
	syscall	
	 
	sw $v0, 0($s1)		# put integer into array
	addi $s1, $s1, 4	# increment array index

	# keep track with a counter, then reset counter before Mat2 prompt
	addi $t5, $t5, 1 
	bge $t5, $t0, mat2_reset	# while MAX >= COUNTER, keep looping, else begin filling Mat2

	j mat1_input		# need to keep prompting user input until user has input num_size*num_size elements

	mat2_reset:
		li $t5, 0	# reset COUNTER for Mat2 input
		
	# prompt to get Mat2 elements
	la $a0, input_mat2
	li $v0, 4
	syscall
	
	# insert pabb_newline
	la $a0, pabb_newline
	li $v0, 4
	syscall	
		
	mat2_input:
	# prompt for next integer
	la $a0, prompt
	li $v0, 4
	syscall
	
	# get next Mat2 element
	li $v0, 5
	syscall	
	
	sw $v0, 0($s2)		# put integer into array
	addi $s2, $s2, 4	# increment array index

	# keep track with a counter, then reset counter before Mat2 prompt
	addi $t5, $t5, 1 
	bge $t5, $t0, reset_count	# while MAX >= COUNTER, keep looping, else begin multiplying

	j mat2_input		# need to keep prompting user input until user has input num_size*num_size elements		
	
	# return $s1, $s2 to initial values, reset COUNTER, and start looping
	reset_count:
		mul $t9, $t5, 4	# multiply COUNTER * 4 to get amount we need to subtract to get to starting address of $s1, $2
		mflo $t9 	# move value to $t9
		sub $s1, $s1, $t9
		sub $s2, $s2, $t9
		li $t5, 0	# reset COUNTER	
		j loop_i

loop_i:
    	beq  $s4, $s0, loop_4	# if (i == num_size) goto print, else
    	addi $s5, $zero, 0		
    	j loop_j		# Jump to the j loop

loop_j:
    	beq  $s5, $s0, inc_i	# if (j == num_size) branch inc_i, else
    	addi $s6, $zero, 0		
    	j loop_k		# Jump to the k loop
    
loop_k:
    	beq  $s6, $s0, inc_j	# if (k == num_size) branch inc_j, else
    	j mult			# Jump to the actual multiply
    	
inc_i:
    	addi $s4, $s4, 1	# i++
    	j loop_i		# Jump to the i loop
    	
inc_j:
    	addi $s5, $s5, 1	# j++
    	j loop_j		# Jump to the j loop

inc_k:
	addi $s6, $s6, 1	# k++
    	j loop_k		# Jump to the k loop    	    	    	    	    	    	

mult:
	mult $s0, $s4		# s0 = num_size*i
	mflo $t0		# move result to $t0
    	add  $t0, $t0, $s6	# t0 = num_size*i + k
    	li   $t7, 4		# t7 = 4 (word offset)
    	mult $t0, $t7		# t0 = $t0 * 4 (offset of element Mat1[num_size*i+k])
    	mflo $t0		# move result to $t0
    	add  $t0, $t0, $s1	# t0 = address of Mat1[num_size*i+k]; get proper element from Mat1
    	lw   $t0, 0($t0)	# t0 = Mat1[num_size*i+k]
    
    	mult $s0, $s6		# s0 = num_size*k
    	mflo $t1		# move result to $t1
    	add  $t1, $t1, $s5	# t1 = num_size*k + j
    	mult $t1, $t7		# t1 = $t1 * 4 (offset of element Mat2[num_size*k+j])
    	mflo $t1		# move result to $t1
    	add  $t1, $t1, $s2	# t1 = address of Mat2[num_size*k+j]; get proper element from Mat2
    	lw   $t1, 0($t1)	# t1 = Mat2[num_size*k+j]
    
    	mult $s0, $s4		# s0 = num_size*i
    	mflo $t2		# move result to $t2
    	add  $t2, $t2, $s5	# t2 = num_size*i + j
    	mult $t2, $t7		# t2 = $t2 * 4 (offset of element Mat3[num_size*i+j])
    	mflo $t2		# move result to $t2
    	add  $t2, $t2, $s3	# t2 = address of Mat3[num_size*i+j]; get proper element from Mat3
    	lw   $t3, 0($t2)	# t3 = Mat3[num_size*i+j]
    
    	mult $t0, $t1		# t0 = Mat1[num_size*i+k] * Mat2[num_size*k+j]
    	mflo $t4		# move result to $t4
    	add  $t4, $t4, $t3	# t4 = address of Mat3[num_size*i+j]; get proper element from Mat3
    	sw   $t4, 0($t2)	# Mat3[num_size*i+j] = t4
    
    	j inc_k			# mult complete    

# Elements at Mat3[i*n+i]
loop_4:
	# num_size * num_size elements are contained in offsets of $s3
	# last element is at offset = 4*(num_size^2)-4
	
	addi $t0, $s0, 0	# t0 = num_size
	mult $s0, $t0		# num_size^2
	mflo $t0		# move result to $t0
	li   $t1, 4		# t1 = 4
	mult $t0, $t1		# 4*(num_size^2)
	mflo $t0		# move result to $t0
	subi $t0, $t0, 4	# 4*(num_size^2)-4; this will be our MAX                           
	 
	li $t2, 0		# clear $t2 to 0; this will be the OFFSET  
	li $t4, 0		# clear $t4 to be used to hold next element                                              
	li $t5, 0		# clear $t5 to be the ROW DELIMITER (for formatting more nicely)
	
	j print_loop                                                                          

print_loop:
	addu $t4, $t2, $s3	# t4 = Mat3 + OFFSET
	lw $t1, 0($t4)		# t1 = value of Mat3 + OFFSET
	
	li $v0, 1		# load the next Matrix element and print
	add $a0, $t1, $zero
	syscall
	li $v0, 4		# add comma delimiter between elements
	la $a0, delimiter
	syscall	
	
	# count until $t5 == num_size, then print pabb_newline (to print matrix-style format)
	addi $t5, $t5, 1		# increment the counter for the ROW DELIMITER
	post_break:			# use this label to return here if we need a row break
	beq $t5, $s6, line_break	# if we've printed num_size elements, go print a line break
	
	addi $t2, $t2, 4		# increment OFFSET counter by 4
	bge $t0, $t2, print_loop	# bge MAX, OFFSET, print_loop
	
	j done
    
line_break:
	li $t5, 0			# reset $t5 to 0
	
	li $v0, 4			# insert pabb_newline after each row
	la $a0, pabb_newline
	syscall			
	        
    	j post_break			# return to print_loop, continue execution after branch
            
done:
    	
# added by Chris, 4/23
# return to linear algebra menu
	print_string ( pabb_newline )
	j lalg_main
