#	CS 2340 Term Project
#	Authors: Aima Salman and Sonal Sinha
#	Date: 11/22/2024


.include "SysCalls.asm"   # Include this file in all programs

.data
	str1:       	.asciiz "1 x 1"
	str2:       	.asciiz "2 x 1"
	str3:       	.asciiz "3 x 2"
	str4:       	.asciiz "4 x 2"
	str5:       	.asciiz "5 x 3"
	str6:       	.asciiz "3 x 1"
	str7:       	.asciiz "6 x 2"
	str8:       	.asciiz "2 x 5"
	str9:       	.asciiz "  1  "
	str10:      	.asciiz "  2  "
	str11:      	.asciiz "  6  "
	str12:      	.asciiz "  8  "
	str13:      	.asciiz " 15  "
	str14:      	.asciiz "  3  "
	str15:      	.asciiz " 12  "
	str16:      	.asciiz " 10  "
	question:	.asciiz "  ?  "
	newline: 	.asciiz "\n"
	pipe:		.asciiz "| "
	underscore_row: .asciiz "+- - - + - - -+- - - + - - -+\n"
	unmatched: 	.asciiz "\nUnmatched: "
	timer_space:	.asciiz "            "
	colon:		.asciiz ":"
	promptCard:	.asciiz "Enter card (0-15): "
	win:		.asciiz "\nWell done! You finished in "
	play_again:	.asciiz "\nWould you like to play again? (0 = exit game) "
	values:		.word str1, str2, str3, str4, str5, str6, str7, str8, str9, str10, str11, str12, str13, str14, str15, str16	# array holding addresses of strings

.text
    main:
    	li $s1, 16			# unmatched cards counter
    	la $s0, values			# save random_order's base address
    	
    	li $v0, SysTime 		# syscall to get the current time (milliseconds) 
    	syscall 			# run syscall
    	move $s2, $a0 			# save the starting time in $s2

    # RANDOMIZE ORDER
    shuffle:
    	la $s0, values    		# reset $t0 to point to the start of the array
    	li $t1, 15              	# set $t1 to the last index in the array (15)

    shuffle_loop:
    	li $v0, SysRandInt    		# system call for random integer
    	syscall               		# generate a random integer in $v0
    	andi $v0, $v0, 0x7FFF 		# mask to positive integer range
    	rem $t2, $v0, $t1     		# $t2 = random index in range [0, $t1+1]

    	# Calculate the addresses for swapping
    	mul $t3, $t1, 4       		# $t3 = $t1 * 4 (offset in bytes)
    	la $t4, values        		# load base address of values array
    	add $t3, $t3, $t4     		# address of array[$t1]
    
    	mul $t5, $t2, 4       		# $t5 = $t2 * 4 (offset in bytes)
    	add $t5, $t5, $t4     		# address of array[$t2]
    
    	# Swap values[array[$t1]] and values[array[$t2]]
    	lw $t6, 0($t3)        		# load array[$t1] into $t6
    	lw $t7, 0($t5)        		# Load array[$t2] into $t7
    	sw $t7, 0($t3)        		# Store array[$t1] at array[$t2]
    	sw $t6, 0($t5)        		# Store array[$t2] at array[$t1]
    
    	subi $t1, $t1, 1      		# Decrement $t1 for the next iteration
    	bgtz $t1, shuffle_loop 		# Continue if $t1 > 0
    	
    	
    # ADD HERE
    	# initializing blank card array
    	# finding some way to connect them?? maybe using another array to keep track of flipped vs unflipped
    
    # PRINT UNMATCHED CARDS AND TIMER
    print_start:
    	# print unmatched cards
    	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, unmatched		# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysPrintInt		# print prompt to get user's choice of card
    	move $a0, $s1			# load address of variable
    	syscall				# run system call
    	
    	# find time elapsed
    	li $v0, SysTime 		# syscall to get the current time (milliseconds) 
    	syscall 			# run syscall
    	move $t2, $a0 			# save the ending time in $t1
    	
    	sub $t2, $t2, $s2		# end - start time
    	div $t2, $t2, 1000		# milliseconds to seconds conversion
    	div $t1, $t2, 60		# seconds to minutes conversion
    	
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
    
    # PRINTING BOARD WITH VALUES
    init_board:
    	li $t0, 0           		# index for grid_values array
    	la $t4, values			# load values array to $t4

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
    	
    	beq $t0, 16, get_input		# if all 16 items are printed exit program

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
    	bge $t3, 4, check_board    	# check if row is full (4 items)

    check_board:
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
    	
    	
    # USER INPUT SCREENS
    get_input:
    	beqz $s1, win_screen
    	
    	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, promptCard		# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysReadInt		# load syscall number for reading an int
    	syscall                 	# run system call
    	move $t0, $v0			# saved card 1 in $t0
    	
	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, promptCard		# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysReadInt		# load syscall number for reading an int
    	syscall                 	# run system call
    	move $t1, $v0			# saved card 2 in $t1
    	
    	# jump to validate match section
    	
    	# FOR TESTING PURPOSES ONLY REMOVE LATER!!
    	subi $s1, $s1, 1		# see if win screen is correct
    	j print_start
 
    # MATCHING LOGIC
    	# check if cards match
    	# update unmatched card counter
    	# j print_start
    
    # while (unmatched != 0)
    	# jump to displaying updated board

    
    # END OF GAME SCREENS
    win_screen:
    	li $v0, SysPrintString		# print prompt of win message
    	la $a0, win			# load address of win message into a0
    	syscall				# run system call
    	
    	# display time
    	li $v0, SysTime 		# syscall to get the current time (milliseconds) 
    	syscall 			# run syscall
    	move $t2, $a0 			# save the ending time in $t1
    	
    	sub $t2, $t2, $s2		# end - start time
    	div $t2, $t2, 1000		# milliseconds to seconds conversion
    	div $t1, $t2, 60		# seconds to minutes conversion
    	
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
    
    
    game_restart:
    	li $v0, SysPrintString		# print prompt to get user's choice of card
    	la $a0, play_again		# load address of prompt into a0
    	syscall				# run system call
    	
    	li $v0, SysReadInt		# load syscall number for reading an int
    	syscall                 	# run system call
    	move $t0, $v0			# saved response in $t0
    	
    	beqz $t0, exit			# if user enters 0, exit game
    	j main				# otherwise, restart
    
    exit:
    	li $v0, SysExit                 # exit syscall
    	syscall
