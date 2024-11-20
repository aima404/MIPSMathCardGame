#.include "SysCalls.asm"
.globl match

    # CHECK IF USER CHOICES MATCH
   match:
    	# initialize variables for determining which arrays t0 and t1 belong to
    	li $t4, -1            		# $t4: index of t0 in values (-1 means not found)
    	li $t5, -1            		# $t5: index of t1 in values (-1 means not found)
    	li $t6, -1            		# $t6: index of t0 in answers (-1 means not found)
    	li $t7, -1            		# $t7: index of t1 in answers (-1 means not found)
    
    	# init t0 and t1
    	la $t8, allNums       		# load display array
    	mul $t9, $t0, 4       		# calculate offset for t0
    	add $t9, $t8, $t9		# add offset to base address
    	lw $t0, 0($t9)			# t0 = actual string of card chosen
    	
    	mul $t9, $t1, 4       		# calculate offset for t1
    	add $t9, $t8, $t9		# add offset to base address
    	lw $t1, 0($t9)			# t1 = actual string of card chosen
    	
    	# find t0 in values array
    	la $t8, values        		# load base address of values array
    	li $t9, 0             		# index counter

    find_t0_values:
    	beq $t9, 8, find_t0_answers 	# exit if all elements checked
    	lw $t2, 0($t8)       		# t2 = values[t9]
    	
    	beq $t0, $t2, found_t0_values 	# if user input matches item in array, save index
    	
    	addi $t8, $t8, 4      		# move to next element
    	addi $t9, $t9, 1      		# increment index
    	
    	j find_t0_values		# loop again

    found_t0_values:
    	move $t4, $t9         		# save index of t0 in values
    	j check_t1            		# move on to checking where t1 is

    find_t0_answers:
    	la $t8, answers       		# load base address of answers array
    	li $t9, 0             		# reset index counter
    
    find_t0_answers_loop:
    	beq $t9, 8, check_t1  		# exit if all elements checked
    	lw $t2, 0($t8)        		# t2 = answers[t9]
    	
    	beq $t0, $t2, found_t0_answers 	# if t0 matches, save index
    	
    	addi $t8, $t8, 4      		# move to next element
    	addi $t9, $t9, 1      		# increment index
    	
    	j find_t0_answers_loop		# loop again

    found_t0_answers:
    	move $t6, $t9         		# save index of t0 in answers

    check_t1:
    	# find t1 in values array
    	la $t8, values        		# load base address of values array
    	li $t9, 0             		# reset index counter

    find_t1_values:
    	beq $t9, 8, find_t1_answers 	# exit if all elements checked
    	lw $t2, 0($t8)        		# t2 = values[t9]
    	
    	beq $t1, $t2, found_t1_values 	# if t1 matches, save index
    	
    	addi $t8, $t8, 4      		# move to next element
    	addi $t9, $t9, 1      		# increment index
    	
    	j find_t1_values		# loop again
    
    found_t1_values:
    	move $t5, $t9         		# save index of t1 in values
    	j check_match         		# skip checking answers for t1

    find_t1_answers:
    	la $t8, answers       		# load base address of answers array
    	li $t9, 0             		# reset index counter
    
    find_t1_answers_loop:
    	beq $t9, 8, check_match 	# exit if all elements checked
    	lw $a0, 0($t8)        		# load answers[t9]
    	
    	beq $t1, $a0, found_t1_answers 	# if t1 matches, save index
    	
    	addi $t8, $t8, 4      		# move to next element
    	addi $t9, $t9, 1      		# increment index
    	
    	j find_t1_answers_loop		# loop again
    
    found_t1_answers:
    	move $t7, $t9        		# save index of t1 in answers

    # check if they form a matching pair
    check_match:
    	li $v0, 0             		 # default: no match
    	bge $t4, 0, match_values_answers # case 1: t0 in values, t1 in answers
    	bge $t6, 0, match_answers_values # case 2: t0 in answers, t1 in values
    	j no_match            		 # if neither case, no match

    match_values_answers:
    	beq $t4, $t7, found_match	# if values index = answers index, the cards match!
    	j no_match			# else, they don't

    match_answers_values:
    	beq $t6, $t5, found_match	# if answers index = values index, the cards match
    	j no_match			# else, they don't

    found_match:
    	# update display array to reveal the cards
    	la $t8, display       		# load display array
    	mul $t9, $s4, 4       		# calculate offset for t0
    	add $t9, $t8, $t9		# add offset to base address
    	sw $t0, 0($t9)        		# reveal t0 in display

    	mul $t9, $s5, 4       		# calculate offset for t1
    	add $t9, $t8, $t9		# add offset to base address
    	sw $t1, 0($t9)        		# reveal t1 in display
    	
    	li $v0, SysPrintString		# load syscall for printing a string
    	la $a0, matchMsg		# load string into a0
    	syscall				# run syscall

    	subi $s2, $s2, 2      		# decrement unmatched cards counter
    	j exit_match			# go back to main page

    no_match:
    	li $v0, SysPrintString		# load syscall for printing a string
    	la $a0, mismatchMsg		# load string into a0
    	syscall				# run syscall
    	
    	# update display array to reveal the cards TEMPORARILY
    	la $t8, display       		# load display array
    	mul $t9, $s4, 4       		# calculate offset for t0
    	add $t9, $t8, $t9		# add offset to base address
    	sw $t0, 0($t9)        		# reveal t0 in display

    	mul $t9, $s5, 4       		# calculate offset for t1
    	add $t9, $t8, $t9		# add offset to base address
    	sw $t1, 0($t9)        		# reveal t1 in display
    	
    	# display temp board
    	addi $sp, $sp, -4      		# allocate space on the stack
	sw $ra, 0($sp)         		# save return address
	
	jal init_board         		# call subroutine
	
	lw $ra, 0($sp)         		# restore return address
	addi $sp, $sp, 4       		# deallocate stack space
    	
    	# change display back to ?s
    	la $t8, display       		# load display array
    	la $t3, question		# load address of ? string
    	mul $t9, $s4, 4       		# calculate offset for t0
    	add $t9, $t8, $t9		# add offset to base address
    	sw $t3, 0($t9)        		# reveal t0 in display

    	mul $t9, $s5, 4       		# calculate offset for t1
    	add $t9, $t8, $t9		# add offset to base address
    	sw $t3, 0($t9)        		# reveal t1 in display

    exit_match:
    	jr $ra
