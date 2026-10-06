.text
drawScreen:
	# Starting address of the bitmap array as bitmap is just an array representing colors of a pixel
	addi $sp, $sp, -4
	li $s0, 0x10000000
	li $s1, 0
	li $t9, 0
	draw_pixel:
		# 8192 Pixels to draw
		beq $s1, 8192, exit_draw_pixel
	
		# Shift left 2 for word offset as bitmap contains words
		sll $s2, $s1, 2
		add $s2, $s2, $a0
		lw $s2, ($s2)
		sw $s2, ($s0)
   		
   		# Animation delay. Dont print for 1 ms. 
   		# Makes it look like screen is rolling in from top to bottom
   		bne $t9, 20, do_not_wait
   		sw $a0, ($sp)
   		li $v0, 32
		li $a0, 1
		syscall
		lw $a0, ($sp)
		
		# Reset $t9 after 20 iterations or 20 prints
		li $t9, 0
		do_not_wait:
   		
   		# Update $t9 for animation delay
   		# Loop control
   		addi $s0, $s0, 4
   		addi $s1, $s1, 1
   		addi $t9, $t9, 1
   		j draw_pixel
   	exit_draw_pixel:
   	
   	# Jump Back
   	addi $sp, $sp, 4
	jr $ra
