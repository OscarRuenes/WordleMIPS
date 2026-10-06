.text
# $a0 = top left corner address, $a1 = flash color value, $a2 = original color
flashRow:
	addi $sp, $sp, -16
	sw $ra, ($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	
	jal setRowColor
	
	li $v0, 32
	li $a0, 250
	syscall
	
	lw $a0, 4($sp)
	lw $a1, 12($sp)
	jal setRowColor
	
	li $v0, 32
	li $a0, 350
	syscall
	
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	jal setRowColor
	
	li $v0, 32
	li $a0, 250
	syscall
	
	lw $a0, 4($sp)
	lw $a1, 12($sp)
	jal setRowColor
	
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $ra, ($sp)
	addi $sp, $sp, 16
	jr $ra
	
# $a0 = top left corner address, $a1 = color value
setRowColor:
	addi $sp, $sp, -16
	sw $ra, ($sp)
	
	addi $s0, $a0, 0
	li $t0, 0
	drawRow:
		beq $t0, 5, exit_drawRow

		sw $a1, 4($s0)

		sw $t0, 4($sp)
		sw $s0, 8($sp)
		sw $a1, 12($sp)
		addi $a0, $s0, 0
		jal drawBox
		
		lw $t0, 4($sp)
		lw $s0, 8($sp)
		lw $a1, 12($sp)
		
		addi $s0, $s0, 12
		addi $t0, $t0, 1
		
		j drawRow
	exit_drawRow:
	
	
	lw $ra, ($sp)
	addi $sp, $sp, 16
	jr $ra
