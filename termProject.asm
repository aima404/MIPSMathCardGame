#	CS 2340 Term Project
#	Authors: Aima Salman and Sonal Sinha
#	Date: 11/22/2024


.include "SysCalls.asm"
.include "shuffleBoard.asm"
.include "displayBoard.asm"
.include "getInput.asm"
.include "checkMatch.asm"
.include "endGame.asm"

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
	tryAgainCard:	.asciiz "Card already matched! Try again.\n\n"
	invalidMsg:	.asciiz "Invalid input. Please try again.\n\n"
	win:		.asciiz "\nWell done! You finished in "
	play_again:	.asciiz "\nWould you like to play again? (0 = exit game): "
	mismatchMsg:   	.asciiz "\nNo match! Try again.\n"
    	matchMsg:      	.asciiz "\nMatch found!\n"
	
	values:		.word str1, str2, str3, str4, str5, str6, str7, str8, 		# array holding addresses of questions
	answers:	.word str9, str10, str11, str12, str13, str14, str15, str16 	# array holding addresses of answers
	display:	.word question, question, question, question, question, question, question, question, question, question, question, question, question, question, question, question
    	allNums:	.word str1, str2, str3, str4, str5, str6, str7, str8, str9, str10, str11, str12, str13, str14, str15, str16

.text
    main:
    	li $s2, 16			# unmatched cards counter
    	
    	li $v0, SysTime 		# syscall to get the current time (milliseconds) 
    	syscall 			# run syscall
    	move $s3, $a0 			# save the starting time in $s2
    	
    	jal shuffle			# shuffle the allNums array to get a different order everytime
    	
    main_loop:
    	jal display_board		# display board to screen
    	jal get_input			# get input from user
    	jal match			# see if user's cards match
    	
    	beqz $s2, end_game		# if all cards are matched, go to win screen
    	j main_loop			# otherwise, keep going		
    
    end_game:
    	jal win_screen			# go to win screen
    	
    	beqz $t0, exit			# if user enters 0, exit game
    	j main				# otherwise, restart
    
    exit:
    	li $v0, SysExit                 # exit syscall
    	syscall
