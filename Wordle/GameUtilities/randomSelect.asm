.data
solution: .asciiz "seven"
fin:		.asciiz	"Assets/Dictionary/wordle-La.txt"
word:		.space	12
.text
randomSelect:	
	# update stack pointed and store registers that will be update
	addi $sp, $sp, -32
	sw $s6, 28($sp)
	sw $s5, 24($sp)
	sw $v0, 20($sp)
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $t0, 4($sp)
	sw $t1, 0($sp)
	
	# syscall for system time. return $a0 = low order 32 bits of system time. $a1 = high order 32 bits for system time
	# Lower order bits to be used to set the seed to ensure that results differ with time
	li $v0, 30
	syscall
	
	# $a0 is the id of pseduorandom nubmer gnerator and seed for corresponding number generator
	# syscall for setting seed for number generator
	move $a1, $a0
	li $v0, 40
    	syscall
	
	# Pick a random number in the range [0, 2314]. Using the same id
    	li $v0, 42
    	li $a1, 2314
    	syscall
	
	# Random num stored in $s5
	move $s5, $a0
	
	
	li   $v0, 13       # system call for open file
  	la   $a0, fin      # input file name
  	li   $a1, 0        # Open for reading (flags are 0: read, 1: write)
	li   $a2, 0        # mode is ignored
  	syscall            # open a file (file descriptor returned in $v0)
	move $s6, $v0      # save the file descriptor
	
	add $t0, $zero, $zero	
	move $a0, $s6      # file descriptor 
	la   $a1, word     # address of buffer t0 which to write
	li   $a2, 6        # hardcoded buffer length as the \n is included
	
	
iterate:
	li   $v0, 14 
	syscall            # read from file
	
	# Word has been picked
	beq $s5, $t0, picked
	
	# Loop control
	addi $t0, $t0, 1
	j iterate
	
picked:
	# Important: close file
	li $v0, 16
	syscall
	li $t0, 0
	
set:
	# store the word into memory
	lb $t1, word($t0)
	sb $t1, solution($t0) #wordle
	beq $t0, 5, done
	addi $t0, $t0, 1
	j set

done: 
	# set last char as null 
	sb $zero, solution+5
	
	# Restore and jump back
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $v0, 20($sp)
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $t0, 4($sp)
	lw $t1, 0($sp)
	addi $sp, $sp, 32
	
	
	# End
	jr $ra
	
	
