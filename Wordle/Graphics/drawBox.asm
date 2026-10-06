# $a0 = box address
drawBox:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	lw $s0, 0($a0) # character
	lw $s1, 4($a0) # color
	lw $s2, 8($a0) # top-left corner in bitmap
	
	# draw background color
	addi $t4, $s2, 0
	li $t1, 0
	background_row:
		slti $t3, $t1, 12
		beq $t3, 0, exit_background_row
		
		addi $t5, $t4, 0
		li $t2, 0
		background_col:
			slti $t3, $t2, 12
			beq $t3, 0, exit_background_col
			
			addi $t6, $t2, 0
			sll $t6, $t6, 2
			add $t6, $t6, $t5
			sw $s1, ($t6)
			
			addi $t2, $t2, 1
			j background_col
		exit_background_col:
		addi $t4, $t4, 256
		
		addi $t1, $t1, 1
		j background_row
	exit_background_row:
	
	# draw border
	li $t1, 0
	loop_top_border:
		slti $t2, $t1, 12
		beq $t2, 0, exit_top_border
		
		li $t2, 0x000000
		addi $t3, $t1, 0
		sll $t3, $t3, 2
		add $t3, $t3, $s2
		sw $t2, ($t3)
		
		addi $t1, $t1, 1
		j loop_top_border
	exit_top_border:
	
	addi $t4, $s2, 0
	li $t1, 0
	loop_sides:
		slti $t2, $t1, 12
		beq $t2, 0, exit_sides
		
		li $t2, 0x000000
		
		sw $t2, ($t4)
		addi $t5, $t4, 0
		addi $t5, $t5, 44
		sw $t2, ($t5)
		addi $t4, $t4, 256
		
		addi $t1, $t1, 1
		j loop_sides
	exit_sides:
	
	
	addi $t4, $s2, 0
	addi $t4, $t4, 2816
	li $t1, 0
	loop_bottom_border:
		slti $t2, $t1, 12
		beq $t2, 0, exit_bottom_border
		
		li $t2, 0x000000
		addi $t3, $t1, 0
		sll $t3, $t3, 2
		add $t3, $t3, $t4
		sw $t2, ($t3)
		
		addi $t1, $t1, 1
		j loop_bottom_border
	exit_bottom_border:
	
	# draw character
	addi $a0, $s2, 0
	addi $a0, $a0, 520
	addi $a1, $s0, 0
	jal alphabetPrint

	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
.include "alphabetprint.asm"