#.include "SysCalls.asm"
.globl display_board

    # PRINT UNMATCHED CARDS AND TIMER
    display_board:
    	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, unmatched		# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysPrintInt		# print prompt to get user's choice of card
    	move $a0, $s2			# load address of unmatched counter
    	syscall				# run system call
    	
    	# find time elapsed
    	li $v0, SysTime 		# syscall to get the current time (milliseconds) 
    	syscall 			# run syscall
    	move $t2, $a0 			# save the ending time in $t1
    	
    	sub $t2, $t2, $s3		# end - start time
    	div $t2, $t2, 1000		# milliseconds to seconds conversion
    	div $t1, $t2, 60		# seconds to minutes conversion
    	mfhi $t2			# set t2 = remainder of division (num seconds)
    	
    	# print time elapsed
    	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, timer_space		# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysPrintInt		# print prompt to get user's choice of card
    	move $a0, $t1			# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, colon			# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysPrintInt		# print prompt to get user's choice of card
    	move $a0, $t2			# load address of prompt into a0
    	syscall				# run system call
    	
    	# print newline after each row
    	la $a0, newline			# load address for newline string
    	li $v0, SysPrintString		# load syscall for printing a string
    	syscall				# run syscall
    
    
    # PRINTING BOARD
    init_board:
    	li $t0, 0           		# index for grid_values array
    	la $t4, display			# load values array to $t4

    print_board:
    	# print underscore row separator for specific rows
    	beq $t0, 0, print_underscore
    	beq $t0, 4, print_underscore
    	beq $t0, 8, print_underscore
    	beq $t0, 12, print_underscore
    	beq $t0, 16, print_underscore
    	
    	j print_board			# jump to printing board

    print_underscore:
    	la $a0, underscore_row     	# print the row separator
    	li $v0, SysPrintString     	# syscall to print string
    	syscall				# run syscall
    	
    	beq $t0, 16, done_print		# if all 16 items are printed exit loop

    init_col:
    	li $t3, 0                  	# column counter for current row

    col_loop:
    	# print the pipe separator
    	la $a0, pipe			# load pipe string
    	li $v0, SysPrintString		# load syscall to print string
    	syscall				# run syscall
    
    	# print grid_values[index]
    	lw $a0, 0($t4)             	# load the random index from random_order[$t2]
    	li $v0, SysPrintString     	# syscall to print string
    	syscall				# run syscall

    	addi $t4, $t4, 4		# move to next item in values array
    	addi $t3, $t3, 1           	# increment column counter
    	addi $t0, $t0, 1           	# increment values array counter
    	bge $t3, 4, check_cols    	# check if row is full (4 items)

    check_cols:
    	# check if we've printed 4 columns (1 row)
   	bne $t3, 4, col_loop     	# if not end of row, keep printing columns
    	
    	# print pipe separator at the end of each row
    	la $a0, pipe			# load address for pipe string
    	li $v0, SysPrintString		# load syscall for printing a string
    	syscall				# run syscall
    	
    	# print newline after each row
    	la $a0, newline			# load address for newline string
    	li $v0, SysPrintString		# load syscall for printing a string
    	syscall				# run syscall
    	
    	j print_board			# move to the next row
    	
    # jump back to driver	
    done_print:
    	jr $ra
