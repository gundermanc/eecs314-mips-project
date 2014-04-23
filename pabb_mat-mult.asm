######################################################################################
# Square Matrix Multiplier
# by Phil Blackburn
# TODO: Add user input for rows of Mat1 and Mat2
# Can double-check correctness @ http://www.bluebit.gr/matrix-calculator/multiply.aspx
######################################################################################
.include "gundermanc-macros.asm"

.data      
                                     
newline:
	.asciiz	"\n"
	.align	2
num_size:
	.word	10	# n*n : size of the square matrix to be computed
delimiter:
	.asciiz ","

# To multiply different size, change Mat1/2/3 accordingly, and change num_size to number of elements per row/col

Mat1:    
	.word 1,1,1,1,1,1,1,1,1,1
        .word 2,2,2,2,2,2,2,2,2,2
        .word 3,3,3,3,3,3,3,3,3,3
        .word 4,4,4,4,4,4,4,4,4,4
        .word 5,5,5,5,5,5,5,5,5,5
       	.word 6,6,6,6,6,6,6,6,6,6
        .word 7,7,7,7,7,7,7,7,7,7
        .word 8,8,8,8,8,8,8,8,8,8
        .word 9,9,9,9,9,9,9,9,9,9
        .word 10,10,10,10,10,10,10,10,10,10

Mat2:
	.word 1,1,1,1,1,1,1,1,1,1
	.word 1,1,1,1,1,1,1,1,1,1
        .word 1,1,1,1,1,1,1,1,1,1
        .word 1,1,1,1,1,1,1,1,1,1
        .word 1,1,1,1,1,1,1,1,1,1
       	.word 1,1,1,1,1,1,1,1,1,1
        .word 1,1,1,1,1,1,1,1,1,1
        .word 1,1,1,1,1,1,1,1,1,1
        .word 1,1,1,1,1,1,1,1,1,1
        .word 1,1,1,1,1,1,1,1,1,1

Mat3:
	.word 0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0

.text                                               

	j main
	
main:
	la $s0, num_size	# Load the address of num_size
	lw $s0, 0($s0)		# Load the value contained in num_size
	la $s1, Mat1		# Load Mat1; $s1 points to Mat1
	la $s2, Mat2		# Load Mat2; $s2 points to Mat2
	la $s3, Mat3		# Load Mat3; $s3 points to Mat3
	li $s4, 0		# initialize i counter
	li $s5, 0		# initialize j counter
	li $s6, 0		# initialize k counter
	j loop_i		# start the nested loops

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

# Output format: FIRST ROW, SECOND ROW, ..., NUM_SIZE ROW
print_loop:
	addu $t4, $t2, $s3	# t4 = Mat3 + OFFSET
	lw $t1, ($t4)		# t1 = value of Mat3 + OFFSET
	
	li $v0, 1		# load the next Matrix element and print
	add $a0, $t1, $zero
	syscall
	li $v0, 4		# add comma delimiter between elements
	la $a0, delimiter
	syscall	
	
	# count until $t5 == num_size, then print newline (to print matrix-style format)
	addi $t5, $t5, 1		# increment the counter for the ROW DELIMITER
	post_break:			# use this label to return here if we need a row break
	beq $t5, $s6, line_break	# if we've printed num_size elements, go print a line break
	
	addi $t2, $t2, 4		# increment OFFSET counter by 4
	bge $t0, $t2, print_loop	# bge MAX, OFFSET, print_loop
	
	j done
    
line_break:
	li $t5, 0			# reset $t5 to 0
	
	li $v0, 4			# insert newline after each row
	la $a0, newline
	syscall			
	        
    	j post_break			# return to print_loop, continue execution after branch
    
done:
    	li $v0, 10		
    	syscall
