#In Game Sound
#Oscar Ruenes
#04/23/2024
#This program contains subroutines victorySound, defeatSound, errSound, 
#intoGameSound(when the user presses enter to go into game screen). No inputs needed

#plays victory sound
.macro playSound %1 %2 %3 %4 %5
li 	 $a0, %1
li 	 $a1, %2	 
li	 $a2, %3
li	 $a3, %4
li	 $v0, %5
.end_macro
victorySound:
	 subi	 $sp, $sp, 24
	 sw	 $ra, 0($sp)
	 sw	 $a0, 4($sp)
	 sw	 $a1, 8($sp)
	 sw	 $a2, 12($sp)
	 sw	 $a3, 16($sp)
	 sw	 $v0, 20($sp)
	 
	 playSound(67,0,12,100,33)
	 syscall
	 
	 playSound(64,1200,12,100,31) 	#pitch(60 - C), length (ms), instrument, vol, syscall
	 syscall
	 
	 li 	$a0, 900		# sleep between pitches, no overlap
	 li 	$v0, 32
	 syscall
	 
	 playSound(67,1000,12,100,31)
	 syscall
	 
	 li 	$a0, 600
	 li 	$v0, 32
	 syscall
	 
	 playSound(72,800,12,100,33)
	 syscall

	 lw 	 $v0, 20($sp)	 
	 lw 	 $a3, 16($sp)
	 lw 	 $a2, 12($sp)
	 lw 	 $a1, 8($sp)
	 lw 	 $a0, 4($sp)
	 lw 	 $ra, 0($sp)
	 addi 	 $sp, $sp, 24
	 jr	 $ra
	 
#error sound
errSound:
	 subi	 $sp, $sp, 24
	 sw	 $ra, 0($sp)
	 sw	 $a0, 4($sp)
	 sw	 $a1, 8($sp)
	 sw	 $a2, 12($sp)
	 sw	 $a3, 16($sp)
	 sw	 $v0, 20($sp)
	 
	 playSound(67,0,12,100,33)
	 syscall
	 
	 playSound(30,100,87,80,31)
	 syscall
	 
	 li 	$a0, 250
	 li 	$v0, 32
	 syscall
	 
	 playSound(30,450,87,80,33)
	 syscall 
	 
	 lw 	 $v0, 20($sp)	 
	 lw 	 $a3, 16($sp)
	 lw 	 $a2, 12($sp)
	 lw 	 $a1, 8($sp)
	 lw 	 $a0, 4($sp)
	 lw 	 $ra, 0($sp)
	 addi 	 $sp, $sp, 24
	 jr	 $ra
	 
defeatSound:	
	 subi	 $sp, $sp, 24
	 sw	 $ra, 0($sp)
	 sw	 $a0, 4($sp)
	 sw	 $a1, 8($sp)
	 sw	 $a2, 12($sp)
	 sw	 $a3, 16($sp)
	 sw	 $v0, 20($sp)
	 
	 playSound(64,0,56,100,33)
	 syscall
	
	 playSound(64,720,56,100,31)
	 syscall
	 
	 li 	$a0, 760
	 li 	$v0, 32
	 syscall
	 
	 playSound(63,780,56,100,31)
	 syscall
	 
	 li 	$a0, 850
	 li 	$v0, 32
	 syscall
	 
	 playSound(62,900,56,100,31)
	 syscall
	 
	 li 	$a0, 1000
	 li 	$v0, 32
	 syscall
	 
	 playSound(61,1100,56,100,33)
	 syscall
	 
	 lw 	 $v0, 20($sp)	 
	 lw 	 $a3, 16($sp)
	 lw 	 $a2, 12($sp)
	 lw 	 $a1, 8($sp)
	 lw 	 $a0, 4($sp)
	 lw 	 $ra, 0($sp)
	 addi 	 $sp, $sp, 24
	 jr	 $ra
