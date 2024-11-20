#.include "SysCalls.asm"
.globl get_input

    # USER INPUT SCREENS
    get_input:
    	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, promptCard		# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysReadInt		# load syscall number for reading an int
    	syscall                 	# run system call
    	move $t0, $v0			# saved card 1 in $t0
    	
    	# input validation for t0
    	bgt $t0, 15, invalid_input	# check if num is more than 15
    	blt $t0, 0, invalid_input	# check if num is less than 0
	
	la $t7, question		# load address of ? string
	la $t8, display			# load address of allNums
	mul $t9, $t0, 4       		# calculate offset for t0
    	add $t9, $t8, $t9		# add offset to base address
    	lw $t2, 0($t9)        		# load value of 
    	bne $t2, $t7, card_used		# check if t0 has already been used
	move $s4, $t0			# if good, save index of t0 in allNums
	
	
	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, promptCard		# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysReadInt		# load syscall number for reading an int
    	syscall                 	# run system call
    	move $t1, $v0			# saved card 2 in $t1
    	
    	# input validation for t1
    	bgt $t1, 15, invalid_input	# check if num is more than 15
    	blt $t1, 0, invalid_input	# check if num is less than 0
    	
    	mul $t9, $t1, 4       		# calculate offset for t0
    	add $t9, $t8, $t9		# add offset to base address
    	lw $t2, 0($t9)        		# reveal t0 in display
    	bne $t2, $t7, card_used		# check if t1 has already been used
    	move $s5, $t1			# if good, save index of t1 in allNums
    	
    	jr $ra
 
   card_used:
   	li $v0, SysPrintString		# load syscall for printing a string
   	la $a0, tryAgainCard		# load address of try again message
   	syscall				# run syscall
   	
   	j get_input			# jump back to input entry
   	
   invalid_input:
   	li $v0, SysPrintString		# load syscall for printing a string
   	la $a0, invalidMsg		# load address of try again message
   	syscall				# run syscall
   	
   	j get_input			# jump back to input entry
