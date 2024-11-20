#.include "SysCalls.asm"
.globl win_screen

# END OF GAME SCREENS
    win_screen:
    	li $v0, SysPrintString		# print prompt of win message
    	la $a0, win			# load address of win message into a0
    	syscall				# run system call
    	
    	# display time
    	li $v0, SysTime 		# syscall to get the current time (milliseconds) 
    	syscall 			# run syscall
    	move $t2, $a0 			# save the ending time in $t1
    	
    	sub $t2, $t2, $s3		# end - start time
    	div $t2, $t2, 1000		# milliseconds to seconds conversion
    	div $t1, $t2, 60		# seconds to minutes conversion
    	mfhi $t2			# set t2 = remainder of division (num seconds)
    	
    	# print time elapsed
    	li $v0, SysPrintInt		# print prompt to get user's choice of card
    	move $a0, $t1			# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, colon			# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysPrintInt		# print prompt to get user's choice of card
    	move $a0, $t2			# load address of prompt into a0
    	syscall				# run system call
    
    
    	# GAME RESTART PROMPT
    	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, play_again		# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysReadInt		# load syscall number for reading an int
    	syscall                 	# run system call
    	move $t0, $v0			# saved response in $t0
    	
    	jr $ra				# back to main
