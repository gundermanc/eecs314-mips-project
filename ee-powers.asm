.include "gundermanc-macros.asm"
	.data
	ask_base: .asciiz "Enter the base[+-float]: "
	ask_power: .asciiz "Enter the power[+-int]: "
	power_result: .asciiz "Result: "
	zero: .float 0.0
	one: .float 1.0
	.text
#finds $t0^$t1
#uses $t0-$t3
power:
	print_string(ask_base)
	read_float($f0)
	print_string(ask_power)
	read_integer($t1)
	move $t2,$t1	#t2 is num times to multiply
	mov.s $f1,$f0	#f0 is answer, f1 is base
	
	slt $t3,$t2,$zero #t3 is 1 if negetive pow
	beq $t2,$zero,powerzero
	beq $t3,$zero,powerloop
	#if negetive:
	addi $t4,$zero,-1 #make t2 positive
	mult $t2,$t4
	mflo $t2
powerloop:
	addi $t2,$t2, -1
	beq $zero,$t2,doneLoop
	mul.s $f0,$f0,$f1
	j powerloop
powerzero:
	l.s $f0,zero
	j done
doneLoop:
	beq $t3,$zero,done
	#if negetive, invert answer
	l.s $f2,one
	div.s $f0,$f2,$f0
done:
	print_string(power_result)
	mov.s $f12,$f0
	addi $v0,$zero,2 #print answer
	syscall	