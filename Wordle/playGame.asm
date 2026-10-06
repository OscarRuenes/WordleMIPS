.data
	# Stores keyboard location
	keyboard: .word 0xFFFF0000
	
	# Used for printing boxes
	boxes: .word
		0,0,0,   0,0,0,   0,0,0,   0,0,0,   0,0,0,
		0,0,0,   0,0,0,   0,0,0,   0,0,0,   0,0,0,
		0,0,0,   0,0,0,   0,0,0,   0,0,0,   0,0,0,
		0,0,0,   0,0,0,   0,0,0,   0,0,0,   0,0,0,
		0,0,0,   0,0,0,   0,0,0,   0,0,0,   0,0,0,
		0,0,0,   0,0,0,   0,0,0,   0,0,0,   0,0,0
	
	# Stroes how the guess compares to the wordle, an array of integers ranging form [0,2]
	guessSolutionMatch: .word 0,0,0,0,0
	
	# Strings for printing errors
	lengthErr:  	.asciiz "\nInvalid length. Please enter a five letter guess.\n"
	wordErr:     	.asciiz "\nNot in dictionary. Please try again.\n"

.text	
playGame:
	# store return address and $a0. Return address important for exiting the game
	addi $sp, $sp, -28
	sw $ra, 20($sp)
	sw $a0, 24($sp) 
	# Selects a random word from a smaller dictionary of words that can be wordles and sets the string to the label solution
	jal randomSelect
	la $a0, boxes
	# Draw the board by creating the 6 rows and 5 col. table
	jal createBoard
	li $s0, 0 # row
	li $s1, 0 # col
	la $s2, boxes # current box, trading a single word to get rid of multiplication operation
		
		# Waits for keyboard input here. If the program is not doing anything, it is likely waiting in this loop
		wait_for_keyboard:
		sw $s0, ($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		# check if game is over
		lw $t0, keyboard
		lw $t1, ($t0)
		andi $t1, $t1, 0x0001
		beq $t1, $zero, wait_for_keyboard
		
		lw $a0, 4($t0) # store keyboard input

		# check backspace key
		beq $a0, 8, backspace
		
		# check enter key
		beq $a0, 10, enter
		
		# check 5th column
		slti $t0, $s1, 5
		beq $t0, 0, wait_for_keyboard
		
			# check valid character
			slti $t0, $a0, 65
			slti $t1, $a0, 123
			
			# Out of range / not letter leads to invalid char handling
			beq $t0, 1, invalid_char
			beq $t1, 0, invalid_char
		
			
			slti $t0, $a0, 97
			slti $t1, $a0, 91
			
			# Out of range / not letter leads to invalid char handling
			beq $t0, 0, valid_char
			beq $t1, 0, invalid_char
			
			addi $a0, $a0, 32
			valid_char:
				# key is valid, col is valid			
				sw $a0, ($s2)
				addi $a0, $s2, 0
				
				# draw the box with the character entered by the user
				jal drawBox
				
				lw $s0, ($sp)
				lw $s1, 4($sp)
				lw $s2, 8($sp)

				addi $s1, $s1, 1
				addi $s2, $s2, 12

				j wait_for_keyboard
		backspace:
			# check 0th column to prevent negative column index			
			beq $s1, 0, do_not_go_left_col_out_of_bounds
			addi $s1, $s1, -1
			addi $s2, $s2, -12
			
			# Store before jumping
			sw $s0, ($sp)
			sw $s1, 4($sp)
			sw $s2, 8($sp)
			
			do_not_go_left_col_out_of_bounds:
			# Prevents from accessing less than 0th column
			li $t0, -1
			sw $t0, ($s2)
			addi $a0, $s2, 0
			jal drawBox
			
			lw $s0, ($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			
			# Wait for next input
			j wait_for_keyboard
		enter:
			# word is not 5 letters long
			slti $t0, $s1, 5
			beq $t0, 0, five_long
			not_five_long:
				# Error sound to indicate problem 
				jal errSound
				sw $s0, ($sp)
				sw $s1, 4($sp)
				sw $s2, 8($sp)
				
				# Create a flashing visual on the row with the error
				mul $t0, $s1, -12
				add $a0, $s2, $t0
				li $a1, 0x000000
				lw $a2, 4($s2)
				jal flashRow
				
				lw $s0, ($sp)
				lw $s1, 4($sp)
				lw $s2, 8($sp)
				
				sw $v0, ($sp)
				sw $a0, 4($sp)
				sw $a1, 8($sp)
				
				# Push a error message box displaying the reason for the error
				li 	$v0, 55
				la  	$a0, lengthErr
				li	$a1, 0
				syscall
				lw $v0, ($sp)
				lw $a0, 4($sp)
				lw $a1, 8($sp)
				
				# Wait for next input
				j wait_for_keyboard
			five_long:
				# The word entered is of valid lenght
				la $t0, guess
				addi $t1, $s2, -60
				li $t2, 0
				
				# Store the guess
				create_guess:
					beq $t2, 5, exit_create_guess
					
					add $t3, $t2, $t0
					lb $t4, ($t1)			
					sb $t4, ($t3)
					
					addi $t1, $t1, 12
					
					addi $t2, $t2, 1
					j create_guess
				exit_create_guess:
				sw $s0, ($sp)
				sw $s1, 4($sp)
				sw $s2, 8($sp)
				
				lw $a0, 24($sp)
				
				# Check if the word is in the list of 5 letter words using binSearch
				jal binSearch
				
				lw $s0, ($sp)
				lw $s1, 4($sp)
				lw $s2, 8($sp)
				
				# binsSearch returns 0 if not in dictionary and 1 otherwise	
				word_not_in_dict:
				beq $v0, 1, word_in_dict
				
				# guess is not in the dictionary; play error noice
				jal errSound
				sw $s0, ($sp)
				sw $s1, 4($sp)
				sw $s2, 8($sp)
				
				# Flash row to incidicate an error
				mul $t0, $s1, -12
				add $a0, $s2, $t0
				li $a1, 0x000000
				li $a2, 0xffffff
				jal flashRow
				
				lw $s0, ($sp)
				lw $s1, 4($sp)
				lw $s2, 8($sp)
				
				sw $s0, ($sp)
				sw $s1, 4($sp)
				sw $s2, 8($sp)
				
				# push a error message to indiate that the guess doesn't exists in the dictionary
				li 	$v0, 55
				la  	$a0, wordErr
				li	$a1, 0
				syscall
				lw $s0, ($sp)
				lw $s1, 4($sp)
				lw $s2, 8($sp)

				# Wait for next input
				j wait_for_keyboard
				
				# word is in dictionary
				word_in_dict:
				la $a0, guess
				la $a1, solution
				
				# Compare the guess with the wordle to check what chars in the right place, what exist in the wordle and what are wrong
				jal check_answer
				
				# $v0 the address of an array representing how well the guess matched with solution
				
				lw $s0, ($sp)
				lw $s1, 4($sp)
				lw $s2, 8($sp)
				
				# store how well the guess matched with the solution
				la $t1, guessSolutionMatch
				li $t9, 1 # boolean: whether or not the words matched
				li $t0, 0
				
				# Copy the output of check_answer to guessSolutionMatch array to 
				copy_array:
					beq $t0, 5, exit_copy_array
					
					sll $t2, $t0, 2
					add $t3, $t2, $t1 # address to save to
					add $t2, $t2, $v0 # address to copy from
					
					lw $t2, ($t2)
					sw $t2, ($t3)
					
					# If the letter is in the right place, jump to correct_letter
					beq $t2, 2, correct_letter
					li $t9, 0
					correct_letter:
					
					# loop control
					addi $t0, $t0, 1
					j copy_array
				exit_copy_array:
				
				# draw the boxes with solution indicators
				lw $s2, 8($sp)
				addi $s3, $s2, -60
				li $t0, 0
				update_boxes:
					beq $t0, 5, exit_update_boxes
					
					# Draw each box based on the stored values in guessSolutionMatch which indicate what color each box should be
					sll $t5, $t0, 2
					lw $t5, guessSolutionMatch($t5)
				
					# If it is 0, fill the boxes with grey
					bne $t5, 0, not_zero
						li $t2, 0xDDDDDD
						sw $t2, 4($s3)
						j finished_modifying_box_object
					not_zero:
				
					# else fill with yellow
					bne $t5, 1, not_one
						li $t2, 0xF0F080
						sw $t2, 4($s3)
						j finished_modifying_box_object
					not_one:
					
					# equal and aligned character; green
					li $t2, 0x80F080
					sw $t2, 4($s3)
					
					finished_modifying_box_object:
					
					# Draw the box based on the argument. Fill in the box based on the color argument
					sw $t0, 12($sp)
					sw $s3, 16($sp)
					addi $a0, $s3, 0
					
					jal drawBox

					lw $s0, ($sp)
					lw $s1, 4($sp)
					lw $s2, 8($sp)
					lw $t0, 12($sp)
					lw $s3, 16($sp)
					addi $s3, $s3, 12
				
					addi $t0, $t0, 1
					j update_boxes
				exit_update_boxes:
					# word is the solution -> you win
					bne $t9, 1, keep_guessing_1
						
						# Play the victory sound and load 1 as the return value to incidate victory
						li $v0, 1
						jal victorySound
						
						# Jump back to wordle.asm
						lw $ra, 20($sp)
						jr $ra
					keep_guessing_1:
					# last attempt and guess was incorrect -> you lose
					bne  $s0, 5, keep_guessing_2
					
						# Play the defeat sound and load 0 as the return value to incidate defeat
						li $v0, 0
						jal defeatSound
						
						# Load $ra to orginal return address and jump back
						lw $ra, 20($sp)
						jr $ra
					keep_guessing_2:
			
			addi $s0, $s0, 1
			li $s1, 0
			
			# Wait for further input
			j wait_for_keyboard
		invalid_char:
			# Just wait for keyboard
			j wait_for_keyboard
			
	# Jump back to wordle.asm if something errenous happens
	lw $ra, 20($sp)
	jr $ra
	
# Purpose of files in order: 	For inGame sounds such as victorySound, defeatSound, errSound
#			     	File for the flashrow subprocess for indicating an error
#				checkanswer.asm compares how a guess is in context of the wordle
#				binSearch to perform fast searching of the dictionary by using binary search
# 				drawBox to set up boxes
.include "Assets/Sounds/inGameSounds.asm"
.include "Graphics/flashRow.asm"
.include "GameUtilities/checkAnswer.asm"
.include "GameUtilities/binSearch.asm"
.include "Graphics/drawBox.asm"
