
################################################################
#	Binary Search
################################################################
#	a0	address of array of words
#	a1	(0 or 1) for outcome, 0 = not found
#
#	s1	start = 0
#	s2	end = length of array
#	s3	start + 1
#	s4	temp (end - start) / 2, floor
#	s5	mid = start+(end-start)/2
#	s6	offset for mid (mid * 6)
#	s7	address of array[mid] ( first char of array[mid] )
#
#	t1 storing compResult for comparison
################################################################
.data
	# The length of the dicitonary in the number of 5 letter words it contains
	dict_len:	.word 12972
	comp_addr:	.word 0
	comp_flag:	.word 0
	# Guess of the user
	guess: .asciiz "_____"
.text
binSearch:
	addi 	$sp, $sp, -44			# Move stack pointer out of the way
	sw	$ra, ($sp)				# Save $ra from the stack
	sw 	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$s1, 12($sp)
	sw	$s2, 16($sp)
	sw	$s3, 20($sp)
	sw	$s4, 24($sp)
	sw	$s5, 28($sp)
	sw	$s6, 32($sp)
	sw	$s7, 36($sp)
	sw	$t1, 40($sp)

	la		$a0, dictionary			# Load address of array of words
	li		$s1, 0				# Store 0 for start value (start => element distance from first array element)
	lw		$s2, dict_len			# Store array size for end value (end => element distance from first array element)
	
binLoop:		
	addi	$s3, $s1, 1				# Add 1 to start for start/end checking
	bge 	$s3, $s2, binLoopExit	# If (start + 1 >= end) exit the loop, else continue
	
	sub		$s4, $s2, $s1			# Calculate (end - start)
	div 		$s4, $s4, 2			# Calculate floor of (end - start) / 2 to get the half the distance between start and end
	add		$s5, $s1, $s4			# Mid = start + this half-distance (mid => element distance from first array element)
	
	mul		$s6, $s5, 6			# Multiply mid by word length in bytes (6 including null-termination) to offset it for memory calculations
	add 	$s7, $a0, $s6			# Get the address of array[mid] by adding this offset to the address of the first element
	
	sw		$s7, comp_addr			# Store the address of array[mid] for comparison
	jal		compareWords			# Execute the word comparison, sets compResult = 0 if guess < array[mid]
	
	lw		$t1, comp_flag			# Get comparison flag
	beq		$t1, $zero, inLower		# If (compResult == 0), guess is inLower, else it's inHigher

inHigher:
	add		$s1, $zero, $s5			# start = mid (target is higher than or equal to mid)
	j		binLoop
	
inLower:
	add		$s2, $zero, $s5			# end = mid (target is lower than mid)
	j 		binLoop
	
binLoopExit:						# Go here when (start + 1) >= end, searched all items save for start and end
	mul		$s6, $s1, 6				# Multiply start by word length to use as offset
	
	add 	$s7, $a0, $s6			# Get the address of array[start]
	sw		$s7, comp_addr			# Store address of array[start] for comparison
	
	jal		compareWords			# Compare guess and array[start]
	
	lw		$t1, comp_flag			# Load comparison flag
	beq		$t1, 2, found			# If (compresult == 2) target found, else is notStart
	
notStart:							# Guess != start
	mul		$s6, $s2, 6				# Multiply end by word length to use as offset
				
	add 	$s7, $a0, $s6			# Get the address of array[end]
	sw		$s7, comp_addr			# Store address of array[end] for comparison
	
	jal		compareWords			# Compare guess and array[end]
	
	lw		$t1, comp_flag			# Load comparison flag
	beq		$t1, 2, found			# If (compresult == 2) target found, else is notEnd

notEnd:								# Guess != end AND target != start
	addi	$a1, $zero, 0			# Store 0 in register $a1, indicating guess was not found
	j		finish
	
found:
	addi	$a1, $zero, 1 			# Store 1 in register $a1, indicating guess was found

finish:
	j		exitBinSearch			# End binary search, print correct output message
	
################################################################
#	String Comparison
################################################################
#	t1	condition, 0 = less than, 1 = greater than , 2 = equal
#
#	t4	address of guess
#	t5	address of comparison word
#
#	t2	char of guess
#	t3	char of comparison word
################################################################

compareWords:
	la		$t4, guess				# Load address of guess
	lw		$t5, comp_addr			# Load address of second comparison word

compLoop:
	lb		$t2, ($t4)				# Get char from guess
	lb		$t3, ($t5)				# Get char from comp word
	
	beq     $t2, 10, compEq			# If (char == \n) strings are equal, go to compEq
	beq     $t2, 0, compEq			# If (char == \0) strings are equal, go to compEq
	
	blt		$t2, $t3, compLt		# If (guess < word) go to compLt
	bgt		$t2, $t3, compGt		# If (guess > word) go to compGt

	addi	$t4, $t4, 1				# Move guess to next char
	addi	$t5, $t5, 1				# Move word to next char
	j		compLoop
	
compLt:								# Guess < word
	li		$t0, 0					# Thus, set to 0
	j		compEnd
	
compGt:								# Guess > word
	li		$t0, 1					# Thus, set to 1
	j		compEnd

compEq:								# Guess == word
	li		$t0, 2					# Thus, set to 2
	j       compEnd
    
compEnd:	
	sw		$t0, comp_flag			# Save 1 or 0 as comparison flag
	jr		$ra						# Return to call locaiton
	
################################################################
#	Final Output
################################################################

exitBinSearch:	
	
	# Restore resigers and jump back to return address
	move 	$v0, $a1
	lw		$ra, ($sp)
	lw 	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$s1, 12($sp)
	lw	$s2, 16($sp)
	lw	$s3, 20($sp)
	lw	$s4, 24($sp)
	lw	$s5, 28($sp)
	lw	$s6, 32($sp)
	lw	$s7, 36($sp)
	lw	$t1, 40($sp)
	addi	$sp, $sp, 44
	jr		$ra
