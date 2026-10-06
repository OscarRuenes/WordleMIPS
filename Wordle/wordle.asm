.data
	# Stores locaiton of keyboard driver
	kb: .word 0xFFFF0000
	
	# include gameScreens which has the color values for how the pixels should be set in the bitmap
	.include "Assets/Screens/gameScreens.asm"
	
	# dictionary that contains all 5 letter words to compare user guess to
	dictionary: .space	77832
.text
# home screen

# Clear bitmap to white to start drawing
jal clearScreen

# pass dictionary as argument and call loadDictionary which loads the dictionary into main memory
la $a3, dictionary
jal loadDictionary

# Draws the home screen on the bitmap (label in gameScreens.asm)
la $a0, home_screen
jal drawScreen

# wait for enter key
wait_for_enter_to_play:
lw $t0, kb
lw $t1, ($t0)
andi $t1, $t1, 0x0001

# If enter not recieved, keep looping until the user presses enter
beq $t1, $zero, wait_for_enter_to_play

	lw $a0, 4($t0) 
	# store keyboard input
	# check enter key
	bne $a0, 10, wait_for_enter_to_play
	
# Play the sound related to the opening of the game
jal openGameSound

# Transition from waiting for user to press enter to the playing of the game
game_start:

# Clear screen to all white
jal clearScreen

# Play the sound to signify that you are in the game or the game is starting
jal intoGameSound

# Start playing the game. Most of the core logic in playGame.asm
la $a0, dictionary
jal playGame

# Stores win/lose -> 1/0
addi $t0, $v0, 0

# draw win/lose screen and wait for enter key press to play again

# Sleep for 750 ms
li $v0, 32
li $a0, 750
syscall

# If 0 is returned, the player lost
beq $t0, 0, lose

# Draw the win screen and wait to see if the user wants to play again
win:
	la $a0, win_screen
	jal drawScreen
	j wait_for_enter_to_play_again

lose:
	# Draw lose screen and wait for it the user wants to play again
	la $a0, lose_screen
	jal drawScreen
wait_for_enter_to_play_again:

# Checking for enter as the keyboard input
lw $t0, kb
lw $t1, ($t0)
andi $t1, $t1, 0x0001
beq $t1, $zero, wait_for_enter_to_play_again

	lw $a0, 4($t0) # store keyboard input
	# check enter key
	bne $a0, 10, wait_for_enter_to_play_again
j game_start

# Exit 
li $v0, 10
syscall
# File Purpose in order:	sound includes; needed for playing sounds
#				holds subprocess for drawing the screen
#				creates the board by adding the table with 6 rows and 5 cols
#				Hold suprocess for clearing screen to all white
#				playGame.asm: core logic of the program
#				houses loadDictonary subprocess for loading words into memory
#				randomly selects the word for wordle 

.include "Assets/Sounds/intoGameSound.asm"
.include "Graphics/drawScreen.asm"
.include "Graphics/createBoard.asm"
.include "Graphics/clearScreen.asm"
.include "playGame.asm"
.include "GameUtilities/loadDictionary.asm"
.include "GameUtilities/randomselect.asm"

