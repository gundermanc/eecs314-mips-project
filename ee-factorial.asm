.include "gundermanc-macros.asm"
	.data
	factorial_result: .asciiz "Result: "
	ltzerror: .asciiz "Number must be a positive integer"
	.text
#finds $t0!
#uses $t0-$t3
power:
	######setup:
	addi $t0,$zero,4
	######
	move $t1,$t0
	
	slt $t2,$t0,$zero
	beq $t0,$zero,error
	bne $t2,$zero,error
factloop:
	addi $t1,$t1,-1
	beq $t1,$zero,success
	mult $t0,$t1
	mflo $t0
	j factloop
error:
	print_string(ltzerror)
	j done
success:
	print_integer($t0)
done:
	
