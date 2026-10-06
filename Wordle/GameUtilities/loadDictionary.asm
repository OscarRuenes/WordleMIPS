
################################################################
#	Load Dictionary to memory
################################################################
.data
fulldict: 	.asciiz "Assets/Dictionary/combinedDictionary.txt" 
.text
loadDictionary:
	# Open file pointed to by fulldict label in read mode
	la $a0, fulldict
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	
	# Load all the words at once
	# read all the characters in dictionary file into memory location labeled dictonary
	move $a0, $v0
	la $a1, ($a3) # $a3 = dictionary address
	li $a2, 77832
	li $v0, 14
	syscall
	 
	# load the address of dictionary array into return array $v0
	li $v0, 16
	syscall
	la $v0, dictionary
	
	# jump back
	jr $ra
