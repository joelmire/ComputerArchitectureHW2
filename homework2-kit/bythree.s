.data
	prompt: .asciiz "Enter an integer:"
	nln: .asciiz "\n"

.text
.align 2

main:
	la $a0, prompt				# loading my prompt for the user into $a0
	li $v0, 4					# preparing to print a string
	syscall						# invoke the OS

	li $v0, 5	    			# preparing to read an int
	syscall		    			# invoke the OS to read in the int
	move $t0, $v0				# copy the read-in integer in $v0 to $t5. So $t0 = n

	move $t1, $0				# i == 0
	addi $t1, 3					# i == 3

loop:
	beq $t0, $0, exit
	move $a0, $t1				# moving i into $a0 for syscall
	li $v0, 1					# preparing to print an int
	syscall						# invoke the OS to print the int

    li $v0, 4					# preparing to print a string
	la $a0, nln					# moving the new line character ("\n") into $a0 for syscall
	syscall			   			# invoke the OS to print the 

	addi $t1, 3					# increment by 3
	addi $t0, -1				# decrement n by 1
	j loop						# jump to loop

exit:		
	jr $ra 						# exit the program