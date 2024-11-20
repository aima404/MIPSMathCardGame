#.include "SysCalls.asm"
.globl shuffle

    # RANDOMIZE ORDER
    shuffle:
    	li $t1, 15              	# set $t1 to the last num to be switched

    shuffle_loop:
    	li $v0, SysRandInt    		# system call for random integer
    	syscall               		# generate a random integer in $v0
    	andi $v0, $v0, 0x7FFF 		# mask to positive integer range
    	rem $t2, $v0, $t1     		# $t2 = random index in range [0, $t1+1]

    	# calculate byte offset
    	mul $t3, $t1, 4       		# $t3 = $t1 * 4 (offset in bytes)
    	la $t4, allNums        		# load base address of values array
    	add $t3, $t3, $t4     		# address of array[$t1]
    
    	mul $t5, $t2, 4       		# $t5 = $t2 * 4 (offset in bytes)
    	add $t5, $t5, $t4     		# address of array[$t2]
    
    	# swap values[array[$t1]] and values[array[$t2]]
    	lw $t6, 0($t3)        		# load array[$t1] into $t6
    	lw $t7, 0($t5)        		# load array[$t2] into $t7
    	sw $t7, 0($t3)        		# store array[$t1] at array[$t2]
    	sw $t6, 0($t5)        		# store array[$t2] at array[$t1]
    
    	subi $t1, $t1, 1      		# decrement $t1 for the next iteration
    	bgtz $t1, shuffle_loop 		# continue if $t1 > 0
    	
    	jr $ra
