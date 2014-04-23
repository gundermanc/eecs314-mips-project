.include "gundermanc-macros.asm"
	.data
	ln10: .float 2.302
	zero: .float 0.0
	one: .float 1.0
	two: .float 2.0
	almost1: .float 1.0001
	negone: .float -1.0
	ten: .float 10
	astring: .asciiz " a:"
	bstring: .asciiz " b:"
	zstring: .asciiz " z:"
	lnzstring: .asciiz " ln(z):"
	lnnstring: .asciiz " ln(num):"
	ansstring: .asciiz " result:"
	ask_num: .asciiz "Enter the numer[int]: "
	ask_base: .asciiz "Enter the base[int]: "
	sep: .asciiz "_"
	.text

log:
	print_string(ask_num)
	read_float($f0)
	mov.s $f1,$f0
	print_string(ask_base)
	li   $v0, 6
	syscall
	mov.s $f10,$f0
	mov.s $f0,$f1
			#num = a*10^b
			#ln(num) = ln(a) + b*ln(10)
	mov.s $f2,$f0
	###nlog(num)
	jal findab #t4/f8 = b, f2 = a
	move $t7,$t4 #move b to t7
	jal nlogloop #f4 is ln(a)
	jal calcln #f0 is ln(a)
	
	###print ln(num)
	print_string(lnnstring)
	mov.s $f12,$f0
	addi $v0,$zero,2
	syscall
	
	###move
	mov.s $f9,$f0 #ln(num) = $f9
	mov.s $f2,$f10
	###nlog(base)
	jal findab #t4/f8 = b, f2 = a
	move $t7,$t4 #move b to t7
	jal nlogloop #f4 is ln(a)
	jal calcln #f0 is ln(a)
	
	###print ln(base)
	print_string(lnnstring)
	mov.s $f12,$f0
	addi $v0,$zero,2
	syscall
	
	###divide
	div.s $f12,$f9,$f0 	#divide nlogs
	print_string(ansstring)
	addi $v0,$zero,2 	#print float
	syscall
	j done
			#done
calcln:	#b is in f8, a in f4
	l.s  $f1,ln10
	mul.s $f8,$f8,$f1 # b*ln(10)
	add.s $f0,$f8,$f4
	jr $ra 		#return

findab:
	l.s $f4,one
	l.s $f3,ten #f3 is 10
	l.s $f8,zero #f5 is 0
	addi $t3,$zero,10 #t3 is 10
	addi $t4,$zero,0 #t4 is 0
findabloop:
	div.s $f2,$f2,$f3
	addi $t4,$t4,1
	add.s $f8,$f8,$f4
	c.lt.s $f2,$f4 #n<1
	bc1f findabloop
			#b is t4
			#a is f2
	jr $ra

nlogloop: #f2 is a
	move $t6,$ra #save return point
	# a-1
	l.s $f3,negone 
	add.s $f3,$f2,$f3 #f3 is z
	l.s $f4,zero #f4 is ln(a)
	addi $t5,$zero,1 #t5 = divisor
	l.s $f5,one #f5 = divisor
	l.s $f7,one #f7 is one
nlogloop2:
	#add
	mov.s $f0,$f3 #^d
	move $t1,$t5
	jal power
	div.s $f6,$f0,$f5 #/p
	add.s $f4,$f4,$f6 #add to answer
	#increment
	add.s $f5,$f5,$f7
	addi $t5,$t5,1 #t5 = divisor
	#subtract
	mov.s $f0,$f3 #^d
	move $t1,$t5
	jal power
	div.s $f6,$f0,$f5 #/p
	sub.s $f4,$f4,$f6 #subtract from answer
	#increment
	add.s $f5,$f5,$f7
	addi $t5,$t5,1 #t5 = divisor
	#check
	bne $t5,5, nlogloop2
	jr $t6

###################################################

#uses up to t3,f2
power: #f0^t1 = f0
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
	j pdone
doneLoop:
	beq $t3,$zero,pdone
	#if negetive, invert answer
	l.s $f2,one
	div.s $f0,$f2,$f0
pdone:
	jr $ra
	
	
done: