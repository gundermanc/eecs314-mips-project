	.data
	factorial_result: .asciiz "Result: "
	ask_fact: .asciiz "Enter a number[+int]: "
	ltzerror: .asciiz "Number must be a positive integer"
	.text
#finds $t0!
#uses $t0-$t3
fact_main:
	print_string(ask_fact)
	read_integer($t0)
	######setup:
	#addi $t0,$zero,4
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
	j factdone
success:
	print_integer($t0)
factdone:
	j ee_main