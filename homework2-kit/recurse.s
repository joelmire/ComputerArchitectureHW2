.data
	prompt: .asciiz "Enter an integer:"

.text
.globl main
.align 2

main:

	la $a0, prompt        		     	#\
	li $v0, 4							### print prompt
	syscall 							#/

	li $v0, 5							# take user input
	syscall								#/

	move $a0, $v0						# we will need $v0 for more syscalls

	addi $sp, $sp, -4					#\
	sw $ra, 0($sp)						# \
										#  \
	jal recurse							#   \ store $ra on stack, jal recurse, load $ra
										#  /
	lw $ra, 0($sp)						# /
	addi $sp, $sp, 4					#/

	move $a0, $v0						# copy the return value to the appropriate input register for syscall	

	li $v0, 1							# preparing to print an int
	syscall								# invoke the OS to print the f(N)

	jr $ra								# exit the program


recurse:
	addi $sp, $sp, -12					# establish frame on stack of size 12
	sw $ra, 0($sp)						# store $ra on stack
	sw $s2, 4($sp)						# store $s2 on stack
	sw $s1, 8($sp)						# store $s1 on stack

	move $s2, $a0						# $s2, which is on the stack, gets user inputted N

case_0:
	bne $a0, $zero, case_1				# if n != 0, jump to case 1
	li $v0, 2							# else, it is base case for n = 0, so put 2 in return register
	lw $s1, 8($sp)						# load $s1 from the stack
	lw $s2, 4($sp)                      # load $s2 from the stack
	lw $ra, 0($sp)                      # load $ra from the stack
	addi, $sp, $sp, 12					# collapse the stack frame
	jr $ra								# jump back to $ra

case_1:
    li $t0, 1							# $t0 gets 1
	bne $a0, $t0, not_base_case			# if n not equal 0, branch to base_case_0

	li $v0, 3							# else, it is base case for n = 1, so put 3 in return register
	lw $s1, 8($sp)						# load $s1 from the stack
	lw $s2, 4($sp)						# load $s2 from the stack
	lw $ra, 0($sp)						# load $ra from the stack
	addi, $sp, $sp, 12					# collapse the stack frame
	jr $ra								# jump back to $ra

not_base_case:
	addi $a0, $s2, -2					# n - 2
	jal recurse							# call recurse on n - 2

	li, $t1, 3							# t1 gets 3
	mult $t1, $v0						# multiply the following values: 3 and f(n - 2)
    mflo $s1							# s1 gets 3 * f(n - 2)

    addi $a0, $s2, -1					# n - 1
    jal recurse							# call recurse on n - 1

    addi $v0, $v0, 1					# f(n - 1) + 1

    add $v0, $s1, $v0					# 3 * f(n - 2) + f(n - 1) + 1

return:
	lw $s1, 8($sp)						# load $s1 from the stack
	lw $s2, 4($sp)						# load $s2 from the stack
	lw $ra, 0($sp)						# load $ra from the stack
	addi, $sp, $sp, 12					# collapse the stack frame
	jr $ra								# jump back to $ra
