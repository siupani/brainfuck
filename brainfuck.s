.global brainfuck
.data
format_str: .asciz "We should be executing the following code:\n%s"
format_char: .asciz "%c"

.bss
	buffer: .skip 30000    # Allocate memory for 30000 bytes (Brainfuck tape)

.text

brainfuck:
	pushq %rbp
	movq %rsp, %rbp
	push %rbx
	push %r12
	push %r13
	push %r14
	push %r15  # Push callee-saved registers on the stack

	movq %rdi, %rbx          # %rbx holds the address of the Brainfuck code
	leaq (buffer+5000), %r15  # %r15 is the pointer to the data array (tape)

interpret:
	cmpb $0, (%rbx)           # Check if the current character is the null terminator
	je end                    # If null, we're done

	movb (%rbx), %r12b        # Load the current Brainfuck command into %r12b

	# Handle '<', shift tape pointer left
	cmpb $'<', %r12b
	je shift_left

	# Handle '>', shift tape pointer right
	cmpb $'>', %r12b
	je shift_right

	# Handle '+', increment value at the current tape cell
	cmpb $'+', %r12b
	je increment

	# Handle '-', decrement value at the current tape cell
	cmpb $'-', %r12b
	je decrement

	# Handle '.', print the value at the current tape cell
	cmpb $'.', %r12b
	je output

	# Handle ',', read a character into the current tape cell
	cmpb $',', %r12b
	je input_char

	# Handle '['p
	cmpb $'[', %r12b
	je start_loop

	# Handle ']'
	cmpb $']', %r12b
	je end_loop

	# Move to the next instruction in the Brainfuck code
next_instr:
	inc %rbx                  # Move to the next Brainfuck instruction
	jmp interpret              # Continue interpreting

# Shift the tape pointer left ('<')
shift_left:
	decq %r15                 # Move tape pointer to the left
	jmp next_instr

# Shift the tape pointer right ('>')
shift_right:
	incq %r15                 # Move tape pointer to the right
	jmp next_instr

# Increment the value at the current tape cell ('+')
increment:
	incb (%r15)               # Increment the byte at the current tape pointer
	jmp next_instr

# Decrement the value at the current tape cell ('-')
decrement:
	decb (%r15)               # Decrement the byte at the current tape pointer
	jmp next_instr

# Output the value at the current tape cell ('.')
output:
	movzbl (%r15), %edi       # Load the value at the tape pointer into %edi (arguement for putchar)
	call putchar              # Call putchar to print the character
	jmp next_instr

# Input a character into the current tape cell (',')
input_char:
	call getchar              # Call getchar to read a character from input
	movb %al, (%r15)          # Store the character in the current tape cell
	jmp next_instr

# Start a loop ('[')
start_loop:
	cmpb $0, (%r15)           # Check if the current tape cell is zero
	jnz next_instr            # If non-zero, continue into the loop

	# Otherwise, find the matching ']'
	movq $1, %r13             # Initialize loop depth counter
find_matching_end:
	inc %rbx                  # Move to the next command
	movb (%rbx), %r12b        # Load the next command
	cmpb $'[', %r12b
	je inc_loop_depth         # Increase loop depth if we encounter '['
	cmpb $']', %r12b
	je dec_loop_depth         # Decrease loop depth if we encounter ']'
	jmp find_matching_end

inc_loop_depth:
	incq %r13                 # Increment the loop depth counter
	jmp find_matching_end

dec_loop_depth:
	decq %r13                 # Decrement the loop depth counter
	cmpq $0, %r13             # Check if we've closed all loops
	jne find_matching_end     # If not, continue searching for ']'
	jmp next_instr            # Once found, continue

# End a loop (']')
end_loop:
	cmpb $0, (%r15)           # Check if the current tape cell is zero
	je next_instr             # If zero, exit the loop

	# Otherwise, find the matching '['
	movq $1, %r13             # Initialize loop depth counter
find_matching_start:
	dec %rbx                  # Move to the previous command
	movb (%rbx), %r12b        # Load the previous command
	cmpb $']', %r12b
	je inc_loop_depth2        # Increase loop depth if we encounter ']'
	cmpb $'[', %r12b
	je dec_loop_depth2        # Decrease loop depth if we encounter '['
	jmp find_matching_start

inc_loop_depth2:
	incq %r13                 # Increment the loop depth counter
	jmp find_matching_start

dec_loop_depth2:
	decq %r13                 # Decrement the loop depth counter
	cmpq $0, %r13             # Check if we've opened all loops
	jne find_matching_start   # If not, continue searching for '['
	jmp next_instr            # Once found, continue

# End of program
end:
	popq %r15                 # Pop callee-saved registers
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
