# consider putting box initialize in a separate file
# Box (12-byte object):
# 	word - character in box
# 	word - color
# 	word - address
createBoard:
	addi $sp, $sp, -20
	sw, $ra, ($sp)
	addi $s0, $a0, 0
	# create game board and box objects
	
	# The top left most corner of the top left most box. 
	li $s1, 0x10001E10
	li $t0, 0
	row:
		# Loop contorl 6 rows of boxes
		slti $t2, $t0, 6
		beq $t2, 0, row_exit
	
		li $t1, 0
		col:
			# 5 columns of boxes ineach row
			slti $t2, $t1, 5
			beq $t2, 0, col_exit
			
			# set 0($s0) 1($s1) 2($s2) -> character. color, address	

			li $t3, -1
			sw $t3, 0($s0)
			
			# Set to white
			li $t3, 0xFFFFFF
			sw $t3, 4($s0)
			
			sw $s1, 8($s0)
			
			
			sw $s0, 4($sp)
			sw $s1, 8($sp)
			sw $t0, 12($sp)
			sw $t1, 16($sp)
			
			addi $a0, $s0, 0
			
			# Draws the box on top of the cleared white section
			jal drawBox
			
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $t0, 12($sp)
			lw $t1, 16($sp)

			addi $s0, $s0, 12	# add size of Box object in bytes
			addi $s1, $s1, 44	# number pixels in bitmap to next box top left corner by column
		
			addi $t1, $t1, 1
			j col
		col_exit:
		
		addi $s1, $s1, 2560	# number pixels in bitmap to next box top left corner by row
		addi $s1, $s1, 36
	
		addi $t0, $t0, 1
		j row
	row_exit:
	# restore ra and return
	lw $ra, ($sp)
	addi $sp, $sp, 20
	jr $ra
