##Open game sound/ New game sound##
.macro playSound %1 %2 %3 %4 %5
li 	 $a0, %1
li 	 $a1, %2	 
li	 $a2, %3
li	 $a3, %4
li	 $v0, %5
.end_macro
.text
openGameSound:
	 subi	 $sp, $sp, 24
	 sw	 $ra, 0($sp)
	 sw	 $a0, 4($sp)
	 sw	 $a1, 8($sp)
	 sw	 $a2, 12($sp)
	 sw	 $a3, 16($sp)
	 sw	 $v0, 20($sp)
	 
	 playSound(65,0,87,100,33)
	 syscall
	 
	 playSound(65,800,87,100,31) 	# pitch(60 - C), length (ms), instrument, vol, syscall
	 syscall
	 
	 li 	$a0, 350		# sleep between pitches, no overlap
	 li 	$v0, 32
	 syscall
	 
	 playSound(65,350,87,100,31)
	 syscall
	 
	 li 	$a0, 400
	 li 	$v0, 32
	 syscall
	 
	 playSound(65,250,87,100,31)
	 syscall
	 
	 li 	$a0, 270
	 li 	$v0, 32
	 syscall
	 
	 playSound(60,270,87,60,31)
	 syscall
	 
	 li 	$a0, 200
	 li 	$v0, 32
	 syscall
	 
	 playSound(65,270,87,100,31)
	 syscall
	 
	 li 	$a0, 270
	 li 	$v0, 32
	 syscall
	 
	 playSound(67,350,87,100,33)
	 syscall
	 
	 lw 	 $v0, 20($sp)	 
	 lw 	 $a3, 16($sp)
	 lw 	 $a2, 12($sp)
	 lw 	 $a1, 8($sp)
	 lw 	 $a0, 4($sp)
	 lw 	 $ra, 0($sp)
	 addi 	 $sp, $sp, 24
	 jr $ra
intoGameSound:
	 subi	 $sp, $sp, 24
	 sw	 $ra, 0($sp)
	 sw	 $a0, 4($sp)
	 sw	 $a1, 8($sp)
	 sw	 $a2, 12($sp)
	 sw	 $a3, 16($sp)
	 sw	 $v0, 20($sp)
	 
	 playSound(60,0,87,60,33)
	 syscall
	 
	 playSound(60,700,87,60,31)
	 syscall
	 
	 li 	$a0, 600
	 li 	$v0, 32
	 syscall
	 
	 playSound(72,300,56,60,33)
	 syscall
	 
	 lw 	 $v0, 20($sp)	 
	 lw 	 $a3, 16($sp)
	 lw 	 $a2, 12($sp)
	 lw 	 $a1, 8($sp)
	 lw 	 $a0, 4($sp)
	 lw 	 $ra, 0($sp)
	 addi 	 $sp, $sp, 24
	 jr $ra
