# author: Joel Mire
# date: 02/23/2018

.data
	nln: .asciiz "\n"
	space: .asciiz " "
	eof: .asciiz "DONE"
	name_prompt: .asciiz "name of player:"
	points_prompt: .asciiz "total points:"
	assists_prompt: .asciiz "total assists:"
	minutes_prompt: .asciiz "total minutes:"

.text
.globl main
.align 2

main:

	li $v0, 9							# preparing to allocate memory in the heap
	li $a0, 72 							# specifying that 72 bytes should be allocated [player(64) + doc(4) + next_player_ptr(4)]
	syscall								# invoke the OS

	move $s0, $v0						# $s0 now points to the beginning of the 'struct'
	move $t7, $s0						# the head

	la $a0, name_prompt             	#\
	li $v0, 4							### print "name of player:"
	syscall 							#/

	li $v0, 8							# preparing to read in a string
	la $a0, 0($s0)						# designating the beginning of the struct as the storage location
	li $a1, 64							# maximum string length is 64 bytes
	syscall								# invoke the OS

remove_nln_in_name:
	move $t0, $s0						# $t0 marks the beginning of the name
	addi $t0, $t0, 0					# counter = 0
	li $t1, 10							# nln marker is 10

nln_loop:
	lb $t2, ($t0)						# $t2 is a character
	addi $t0, $t0, 1					# increment the pointer to the name
	bne $t2, $t1, nln_loop				# if the char != /n, then go back to the loop
	addi $t0, $t0, -1					# decrement the pointer to the name to cancel out the increment in this case
	sb $0, ($t0)						# store 0 where /n was

#########################################checking for "DONE"#########################################################################################
	la $a1, eof 						# put "DONE" in $a1. 

strcmp:
	move $t0, $a0						# $t0 gets the player name
	move $t1, $a1 						# $t1 gets "DONE"

	li $t5, 0							# set a counter to 0 
	li $t6, 4							# set a guard to 4 (if it reaches 4 and we are still in the loop, then it's virtually guaranteed that the user input "DONE"	

loop:
	lb $t2, ($t0)						# load 1 byte from player string
	lb $t3, ($t1)						# load 1 byte from eof

	bne $t2, $t3, not_eof				# if the bytes are not equal, proceed to not_eof to take more input

	addi $t5, $t5, 1					# increment our counter since the bytes were equal
	addi $t2, $t2, 1					# increment $t2 by one byte
	addi $t3, $t3, 1					# increment $t3 by one byte

	beq $t5, $t6, terminate			    # if counter == 4, the user input "DONE", so go to terminate

    j loop 								# counter < 4, so go through loop again
#####################################################################################################################################################
not_eof:
	la $a0, points_prompt           	#\ 
	li $v0, 4							### print "total points:"
	syscall 							#/
	li $v0, 6							# preparing to read in a float
	syscall 							# $f0 contains float read
	mov.s $f2, $f0						# storing the number of points ($f0) in $f2 so that $f0 can be used again

	la $a0, assists_prompt          	#\ 
	li $v0, 4							### print "total assists:"
	syscall 							#/
	li $v0, 6							# preparing to read in a float
	syscall 							# $f0 contains float read
	mov.s $f1, $f0						# storing the number of assists ($f0) in $f1 so that $f0 can be used again

	la $a0, minutes_prompt          	# 
	li $v0, 4							## print "total minutes:"
	syscall 							#
	li $v0, 6							# preparing to read in a float
	syscall 							# $f0 contains float read

#####################################checking for (minutes == 0)#####################################################################################
    mtc1 $zero, $f3                 	# $f3 gets 0
	c.eq.s $f0, $f3						# if minutes == zero, then ~code~ gets 1
	bc1t minutes_are_zero				# if ~code~ == 1, branch to minutes_are_zero

	add.s $f1, $f1, $f2					# (points + assists)
	div.s $f0, $f1, $f0					# $f0 = (points + assists) / minutes

	s.s $f0, 64($s0) 					# in the struct, store the float value for Doc directly after the space allocated for the player name
	sw $zero, 68($s0)					# set the next value to null
	j list_builder						# jump to list_builder

minutes_are_zero:
	s.s $f3, 64($s0)					# in the struct, store 0.0 for Doc directly after the space allocated for the player name
######################################################################################################################################################

list_builder:							

	li $v0, 9							# preparing to allocate memory in the heap
	li $a0, 72 							# specifying that 72 bytes should be allocated [player(64) + doc(4) + next_player_ptr(4)]
	syscall								# invoke the OS

	move $s1, $v0						# $s1 now points to the beginning of the new struct

	la $a0, name_prompt             	#\
	li $v0, 4							### print "name of player:"
	syscall 							#/

	li $v0, 8							# preparing to read in a string
	la $a0, 0($s1)						# designating the beginning of the struct as the storage location
	li $a1, 64							# maximum string length is 64 bytes
	syscall								# invoke the OS

remove_nln_in_name_2:
	move $t0, $s1						# $t0 marks the beginning of the name
	addi $t0, $t0, 0
	li $t1, 10							# nln marker is 10

nln_loop_2:
	lb $t2, ($t0)						# $t2 is a character
	addi $t0, $t0, 1					# increment the pointer to the name

	bne $t2, $t1, nln_loop_2			# if the char != /n, then go back to the loop
	addi $t0, $t0, -1					# decrement the pointer to the name to cancel out the increment in this case
	sb $0, ($t0)						# store 0 where /n was

#########################################checking for "DONE"#########################################################################################
	la $a1, eof 						# put "DONE" in $a1. 

strcmp2:
	move $t0, $a0						# $t0 gets the player name
	move $t1, $a1 						# $t1 gets "DONE"

	li $t5, 0							# set a counter to 0 
	li $t6, 4							# set a guard to 4 (if it reaches 4 and we are still in the loop, then it's virtually guaranteed that the user input "DONE"	

loop2:
	lb $t2, ($t0)						# load 1 byte from player string
	lb $t3, ($t1)						# load 1 byte from eof

	bne $t2, $t3, not_eof_2				# if the bytes are not equal, proceed to not_eof_2 to take more input

	addi $t5, $t5, 1					# increment our counter since the bytes were equal
	addi $t2, $t2, 1					# increment $t2 by one byte
	addi $t3, $t3, 1					# increment $t3 by one byte

	beq $t5, $t6, print_list			# if counter == 4, the user input "DONE", so go to sort_list

    j loop2 							# counter < 4, so go through loop again
#####################################################################################################################################################

not_eof_2:							
	la $a0, points_prompt           	#\ 
	li $v0, 4							### print "total points:"
	syscall 							#/

	li $v0, 6							# preparing to read in a float
	syscall 							#$f0 contains float read
	mov.s $f2, $f0						# storing the number of points ($f0) in $f2 so that $f0 can be used again

	la $a0, assists_prompt          	#\ 
	li $v0, 4							### print "total assists:"
	syscall 							#/

	li $v0, 6							# preparing to read in a float
	syscall 							# $f0 contains float read
	mov.s $f1, $f0						# storing the number of assists ($f0) in $f1 so that $f0 can be used again

	la $a0, minutes_prompt          	# 
	li $v0, 4							## print "\ntotal minutes:"
	syscall 							#

	li $v0, 6							# preparing to read in a float
	syscall 							# $f0 contains float read

#####################################checking for (minutes == 0)#####################################################################################
    mtc1 $zero, $f3                 	# $f3 gets 0
	c.eq.s $f0, $f3						# if minutes == zero, then ~code~ gets 1
	bc1t minutes_are_zero_2				# if ~code~ == 1, branch to minutes_are_zero_2

	add.s $f1, $f1, $f2					# (points + assists)
	div.s $f0, $f1, $f0					# $f0 = (points + assists) / minutes

	s.s $f0, 64($s1) 					# in the struct, store the float value for Doc directly after the space allocated for the player name
	sw $zero, 68($s1)					# set the next value to null
	j sort								# jump to sort

minutes_are_zero_2:
	s.s $f3, 64($s1)					# in the struct, store 0.0 for Doc directly after the space allocated for the player name
######################################################################################################################################################

										# general guide: t7 always points to the head. s0 is current, s1 is new node.
sort:
    move $s0, $t7						# set the current node to head

    move $s5, $zero 					# functions as a boolean check

	l.s $f0, 64($s0)					# load the doc of the current node
	l.s $f1, 64($s1)					# load the doc of the new node

	c.lt.s $f0, $f1 					# if the current doc < the new doc, then code = 1
	bc1t add_to_front 					# if code = 1, then jump to add_to_front

	c.eq.s $f0, $f1 					# if current doc == new doc, then code = 1
	bc1t alphabet 						# if code = 1, then jump to alphabet

	j general_check						# jump to general_check

add_to_front:
	move $t7, $s1 						# redefine the head
	move $t0, $s0 						# \
	sw $t0, 68($s1) 					#  after this line, s1 (new) -------> s0 (current) ----> NULL
	j list_builder						# ready for more input, so jump back to list_builder

general_check:
    move $s5, $s0 						# saving a prev node

	lw $t3, 68($s0)						# t3 gets current.next 
	beq $t3, $zero, add_to_end			# if current.next == 0, then we will add the node to the end
	move $s0, $t3						# current = current.next

	l.s $f0, 64($s0)					# update $f0 to doc of current

	c.lt.s $f0, $f1 					# if 0th doc is less than 1st doc, code = 1
	bc1t swap 							# if code = 1, swap (so if the 0th doc is greater than 1st doc)

	c.eq.s $f0, $f1 					# if current doc == new doc, then code = 1
	bc1t alphabet						# if code = 1, then jump to alphabet

	j general_check						# jump to general_check

add_to_end:
 	sw $s1, 68($s0) 					# after this line, s0 (current) -----> s1 (head) -----> NULL
 	j list_builder 						# ready for more input, so jump back to list_builder

swap:                           		# s0 is the current node in the list, s1 holds the node to be inserted
	beq $s5, $zero, add_to_front		# if there is no prev node, jump to add_to_front
	sw $s1, 68($s5)						# prev ----> new
	sw $s0, 68($s1)						# new -----> current

	j list_builder						# jump to general_check

alphabet:					
	move $t0, $s0						# t0 gets s0
 	move $t1, $s1						# t1 gets s1

 	li $t6, 0							# counter = 0
 	li $s6, 64							# guard = 64 (name length)

 bit_loop:
 	addi, $t6, 1						# counter++
 	beq $t6, $s6, general_check			# if counter == guard, jump to general check

 	lb $t2, 0($t0)						# load one byte/char from current
 	lb $t3, 0($t1)						# load one byte/char from new

 	addi $t0, $t0, 1					# increment byte/char in current name
 	addi $t1, $t1, 1					# increment byte/char in new name

 	sub $t4, $t3, $t2					# subtract ascii values: new name letter - current name letter

 	beq $t4, $zero, bit_loop			# if the bytes/chars are the same, jump to bit_loop

 	bltz $t4, swap  					# if new name should come before current name, jump to swap

 	j general_check						# else, jump to general_check because nothing will be changed because of case


print_list:							
	move $s3, $t7						# s3 gets the head of the list

print_loop:
	li $v0, 4							# preparing to print
	move $a0, $s3						# putting player name in the appropriate input register
 	syscall								# invoke the OS

	la $a0, space						# first we need to print a space to separate the name and the doc. Here, I am loading " " into the input register
	li $v0, 4							# preparing to print a string
	syscall 							# invoke the OS

	li $v0, 2							# preparing to print a float
	l.s $f12, 64($s3)					# putting doc in the appropriate register
	syscall 							# invoke the OS

	lw $t0, 68($s3)			    		# $t0 gets the pointer to the next struct
	beq $t0, $zero, terminate			# if pointer is null, go to terminate to end the program

	la $a0, nln 						# loading nln ("\n") into $a0
	li $v0, 4							# preparing to print
	syscall								# invoke the OS

	move $s3, $t0						# s3 gets the next node

	j print_loop						# jump to print_loop

terminate:
	jr $ra 								# exit the program