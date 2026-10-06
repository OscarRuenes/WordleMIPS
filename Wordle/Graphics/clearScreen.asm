.text
# Sets the whole screen of 4x4 unit pixels with dimensions of screen 256 x 512 to be white
clearScreen:
	# Set the first address of bit map as bitmap is just an array of words to represent color
	addi $t4, $0, 0x10000000
	li $t1, 0
	background_r:
		# Loop control; keeps in range of rows; 128 rows
		slti $t3, $t1, 128
		beq $t3, 0, exit_background_r
		
		addi $t5, $t4, 0
		li $t2, 0
		background_c:
			# Loop control 64 columns
			slti $t3, $t2, 64
			beq $t3, 0, exit_background_c
			
			# Update address of cell to color
			addi $t6, $t2, 0
			sll $t6, $t6, 2
			add $t6, $t6, $t5
			
			# Set color to white
			li $s1, 0xFFFFFF
			sw $s1, ($t6)
			
			addi $t2, $t2, 1
			j background_c
		exit_background_c:
		addi $t4, $t4, 256
		
		addi $t1, $t1, 1
		j background_r
	exit_background_r:
	# Jump back
	jr $ra
