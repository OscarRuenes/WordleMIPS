# input: guess, answer (5-letter precondition)
# $v0 output: int[5] 0=letter not in word, 1=letter not in right place. 2=letter in right place
.text
check_answer:
	addi $sp, $sp, -44
	sw $ra, 0($sp)
	
	la $t0, ($a0)	# guess address  -> $t0
	la $t1, ($a1)	# answer address -> $t1
	la $v0, 4($sp)  # $vo contains start addess of int[5]
	la $v1, 24($sp)	# $v1 contains start address of int[5] for yellow
	
	li $t2, 0				# i=0
	check_green_loop_one:
		slti $t4, $t2, 5		# i < 5
		beq $t4, 0, check_green_exit_one
		
		add $t5, $t0, $t2		# $t5 contains address of char at guess indexed by i
		lb $t5, ($t5)			# $t5 contains char of guess[i]
		
		li $t7, 0 			# initial status of char comparison = 0
		add $t6, $t1, $t2		# $t6 contains address of char at answer indexed by i
		lb $t6, ($t6)			# $t6 contains char of answer[i]
		# check for character existence and alignment
		beq $t5, $t6, check_green_equal	# if guess[i] == answer[i], the char should be green
		j check_green_not_equal
		check_green_equal:		
			li $t7, 2
		check_green_not_equal:
		
		# save character status to array
		sll $t5, $t2, 2
		add $t5, $v0, $t5		# $t5 contains address of int[5] at i
		sw $t7, ($t5)			# store status, 0 for not green, 2 for green
		
		addi $t2, $t2, 1
		j check_green_loop_one
	check_green_exit_one:
	
	li $t2, 0				# i=0
	check_answer_loop_one:
		# i < 5
		beq $t2, 5, check_answer_exit_one
						# green letter at i, we do not check
		sll $t5, $t2, 2
		add $t5, $v0, $t5		# $t5 contains address of int[5] at i
		lw $t9, ($t5)			# $t9 contains status of char, 0 for not green, 2 for green
		seq $t8, $t9, 2			
		beq $t8, 0, not_green		# if $t9 != 2, jump to not_green, else 
		
		addi $t2, $t2, 1		# skip green char
		j check_answer_loop_one
		
		not_green:
		move $t5, $t2
		add $t5, $t0, $t5
		lb $t5, ($t5)			# t5 has guess[i]
		
		li $t7, 0 			# initial status of char comparison = 0
		
		li $t3, 0			# j=0
		check_answer_loop_two:
	 		# j < 5
			beq $t3, 5, check_answer_exit_two
						# dont check green chars
			sll $t4, $t3, 2
			add $t4, $v0, $t4	# $t4 contains address of int[j]
			lw $t9, ($t4)		# $t9 contains status of char
			seq $t8, $t9, 2		# $t9 == 2 => char is green at index j
			beq $t8, 1, check_answer_checking_green
						# dont check used yellow slots
			sll $t4, $t3, 2
			add $t4, $v1, $t4
			lw $t9, ($t4)
			seq $t8, $t9, 1		# $t9 == 1 => char is yellow at index j
			beq $t8, 1, check_answer_checking_yellow
			
			add $t6, $t1, $t3	# $t6 contains address of answer[j]
			lb $t6, ($t6)		# $t6 contains char answer[j]

			beq $t5, $t6, check_answer_equal	# if guess[i] == answer[j] (j!=i), char is yellow
			j check_answer_not_equal
			check_answer_equal:			
				li $t7, 1	
				sw $t7, ($t4)			# store 1 at j index so we dont check that char again
				j check_answer_exit_two
					
			check_answer_not_equal:
			check_answer_checking_green:
			check_answer_checking_yellow:
				addi $t3, $t3, 	1		# check next char since this char is 0
			j check_answer_loop_two
		check_answer_exit_two:
		# save character status to array, only necessary when char is yellow
		sll $t5, $t2, 2
		add $t5, $v0, $t5	# $t5 contains address of int[i]
		sw $t7, ($t5)		# store 1 at int[i] indicating yellow
		
		addi $t2, $t2, 1
		j check_answer_loop_one
	check_answer_exit_one:
	li $t7, 0
	li $t3, 0
	clear_loop:
		beq $t3, 5, clear_loop_done
		sll $t4, $t3, 2
		add $t4, $v1, $t4
		sw $t7, ($t4)
		addi $t3, $t3, 1
		j clear_loop
	clear_loop_done:
	addi $sp, $sp, 44
	jr $ra
