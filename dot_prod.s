	.file	"dot_prod.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	vector_dot_product_vector
	.type	vector_dot_product_vector, @function
# t0: Value at 0(a0), t1: Value at 0(a1), t2: Multiplication of t0*t1, t3: Total sum of vector dot product
# t4: loop counter
vector_loop_end:
	mv a0, t3	# Set t3 as the return value
	jr ra		# Return

vector_loop:
	addi t4, t4, 1	# Increment counter by one
	lw t0, 0(a0)	# Load t0 and t1
	lw t1, 0(a1)
	mul t2, t0, t1	# Multiply t0 and t1 and add into total sum of t3
	add t3, t3, t2
	beq t4, a2, vector_loop_end	# If counter reaches a2, end the process and return
	addi a0, a0, 4	# Increment each array by 4 bytes
	addi a1, a1, 4
	j vector_loop

vector_dot_product_vector:
	# Initialize looping local variables (registers) as 0
	li t0, 0
	li t1, 0
	li t2, 0
	li t3, 0
	li t4, 0
	j vector_loop
	.size	vector_dot_product_vector, .-vector_dot_product_vector
	.align	2
	.globl	matrix_dot_vector
	.type	matrix_dot_vector, @function

# a0 = rows, a1 = cols, a2 = matrix pointer, a3 = vector pointer, a4 = result pointer
# t0: Value at 0(a0), t1: Value at 0(a1), t2: Multiplication of t0*t1, t3: Total sum of vector dot product
# t4: Inner counter (vector dot product), t5: Outer counter (matrix-vector dot product)
matrix_loop_end:
	jr ra

matrix_row_next:
	addi t4, t4, 1	# Increase row counter by 1
	sw t3, 0(a4)	# Save the result of the row-vector multiplication in the result address
	beq t4, a0, matrix_loop_end	# If it reaches the end of row, end the program
	mv a3, s1		# Else, restore the vector pointer to the original position
	addi a2, a2, 4	# Increment the matrix array by 4 bytes
	addi a4, a4, 4	# Increment the result vector by 4 bytes
	li t3, 0		# Reinitialize the sum
	li t5, 0		# Reinitialize the column column counter
	j matrix_loop
	
matrix_loop:
	addi t5, t5, 1	# Increment column counter by 1
	lw t0, 0(a2)	# Load values from arrays
	lw t1, 0(a3)
	mul t2, t0, t1
	add t3, t3, t2
	beq t5, a1, matrix_row_next	# If the column counter reaches the end of the column handle the next row
	addi a2, a2, 4	# Else, increment the column and vector by 4 bytes
	addi a3, a3, 4
	j matrix_loop

matrix_dot_vector:
	# Initialize outer loop variable
	li t0, 0
	li t1, 0
	li t2, 0
	li t3, 0
	li t4, 0	# row counter
	li t5, 0	# col counter
	mv s1, a3	# save beginning of vector
	j matrix_loop
	.size	matrix_dot_vector, .-matrix_dot_vector
	.section	.rodata
	.align	2

.PRINT:
	.string "catch"
	.align	2
.DEBUG:
	lui a5, %hi(.PRINT)
	addi a0, a5, %lo(.PRINT)
	call puts
.LC1:
	.string	"Test 1: Pass"
	.align	2
.LC2:
	.string	"Test 1: Fail"
	.align	2
.LC3:
	.string	"Test 2: Pass"
	.align	2
.LC4:
	.string	"Test 2: Fail"
	.align	2
.LC5:
	.string	"Test 3: Pass"
	.align	2
.LC6:
	.string	"Test 3: Fail"
	.align	2
.LC7:
	.string	"Test 4: Pass"
	.align	2
.LC8:
	.string	"Test 4: Fail"
	.align	2
.LC0:
	.word	4
	.word	5
	.word	6
	.word	7
	.word	8
	.word	9
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	t1,-40960
	add	sp,sp,t1
	li	a5,1
	sw	a5,-96(s0)
	li	a5,2
	sw	a5,-92(s0)
	li	a5,3
	sw	a5,-88(s0)
	li	a5,4
	sw	a5,-108(s0)
	li	a5,5
	sw	a5,-104(s0)
	li	a5,6
	sw	a5,-100(s0)
	li	a5,3
	sw	a5,-44(s0)
	addi	a4,s0,-108
	addi	a5,s0,-96
	lw	a2,-44(s0)
	mv	a1,a4
	mv	a0,a5
	call	vector_dot_product_vector
	sw	a0,-48(s0)
	li	a5,32
	sw	a5,-52(s0)
	lw	a4,-48(s0)
	lw	a5,-52(s0)
	bne	a4,a5,.L11
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	puts
	j	.L12
.L11:
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	puts
.L12:
	li	a5,1
	sw	a5,-120(s0)
	li	a5,2
	sw	a5,-116(s0)
	li	a5,3
	sw	a5,-112(s0)
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a0,0(a5)
	lw	a1,4(a5)
	lw	a2,8(a5)
	lw	a3,12(a5)
	lw	a4,16(a5)
	lw	a5,20(a5)
	sw	a0,-144(s0)
	sw	a1,-140(s0)
	sw	a2,-136(s0)
	sw	a3,-132(s0)
	sw	a4,-128(s0)
	sw	a5,-124(s0)
	li	a5,2
	sw	a5,-56(s0)
	li	a5,3
	sw	a5,-60(s0)
	addi	a4,s0,-152
	addi	a3,s0,-120
	addi	a5,s0,-144
	mv	a2,a5
	lw	a1,-60(s0)
	lw	a0,-56(s0)
	call	matrix_dot_vector
	li	a5,32
	sw	a5,-160(s0)
	li	a5,50
	sw	a5,-156(s0)
	li	a5,1
	sw	a5,-20(s0)
	sw	zero,-24(s0)
	j	.L13
.L15:
	lw	a5,-24(s0)
	slli	a5,a5,2	# a5 = 0
	addi	a4,s0,-16	# a4 = -16(s0)
	add	a5,a4,a5	# a5 = -16(s0)
	lw	a4,-136(a5)	# a4
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-144(a5)
	beq	a4,a5,.L14
	sw	zero,-20(s0)
.L14:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L13:
	lw	a4,-24(s0)
	lw	a5,-56(s0)
	blt	a4,a5,.L15
	lw	a5,-20(s0)
	beq	a5,zero,.L16
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	puts
	j	.L17
.L16:
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	puts
.L17:
	li	a5,8192
	addi	a5,a5,1808
	sw	a5,-172(s0)
	li	a5,8192
	addi	a5,a5,1808
	sw	a5,-168(s0)
	li	a5,8192
	addi	a5,a5,1808
	sw	a5,-164(s0)
	li	a5,8192
	addi	a5,a5,1808
	sw	a5,-184(s0)
	li	a5,8192
	addi	a5,a5,1808
	sw	a5,-180(s0)
	li	a5,8192
	addi	a5,a5,1808
	sw	a5,-176(s0)
	li	a5,3
	sw	a5,-64(s0)
	addi	a4,s0,-184
	addi	a5,s0,-172
	lw	a2,-64(s0)
	mv	a1,a4
	mv	a0,a5
	call	vector_dot_product_vector
	sw	a0,-68(s0)
	li	a5,299999232
	addi	a5,a5,768
	sw	a5,-72(s0)
	lw	a4,-68(s0)
	lw	a5,-72(s0)
	bne	a4,a5,.L18
	lui	a5,%hi(.LC5)
	addi	a0,a5,%lo(.LC5)
	call	puts
	j	.L19
.L18:
	lui	a5,%hi(.LC6)
	addi	a0,a5,%lo(.LC6)
	call	puts
.L19:
	li	a5,100
	sw	a5,-76(s0)
	li	a5,100
	sw	a5,-80(s0)
	sw	zero,-28(s0)
	j	.L20
.L21:
	lw	a5,-28(s0)
	addi	a4,a5,1
	lw	a5,-28(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-568(a5)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L20:
	lw	a4,-28(s0)
	lw	a5,-80(s0)
	blt	a4,a5,.L21
	sw	zero,-32(s0)
	j	.L22
.L25:
	sw	zero,-36(s0)
	j	.L23
.L24:
	lw	a5,-36(s0)
	addi	a4,a5,1
	li	a5,-40960
	addi	a3,s0,-16
	add	a3,a3,a5
	lw	a2,-32(s0)
	li	a5,100
	mul	a2,a2,a5
	lw	a5,-36(s0)
	add	a5,a2,a5
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a4,392(a5)
	lw	a5,-36(s0)
	addi	a5,a5,1
	sw	a5,-36(s0)
.L23:
	lw	a4,-36(s0)
	lw	a5,-80(s0)
	blt	a4,a5,.L24
	lw	a5,-32(s0)
	addi	a5,a5,1
	sw	a5,-32(s0)
.L22:
	lw	a4,-32(s0)
	lw	a5,-76(s0)
	blt	a4,a5,.L25
	li	a5,-40960
	addi	a5,a5,-8
	addi	a4,s0,-16
	add	a4,a4,a5
	addi	a3,s0,-584
	li	a5,-40960
	addi	a5,a5,392
	addi	a2,s0,-16
	add	a5,a2,a5
	mv	a2,a5
	lw	a1,-80(s0)
	lw	a0,-76(s0)
	call	matrix_dot_vector
	li	a5,339968
	addi	a5,a5,-1618
	sw	a5,-84(s0)
	li	a5,1
	sw	a5,-20(s0)
	sw	zero,-40(s0)
	j	.L26
.L28:
	li	a5,-40960
	addi	a4,s0,-16
	add	a4,a4,a5
	lw	a5,-40(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a5,-8(a5)
	lw	a4,-84(s0)
	beq	a4,a5,.L27
	sw	zero,-20(s0)
.L27:
	lw	a5,-40(s0)
	addi	a5,a5,1
	sw	a5,-40(s0)
.L26:
	lw	a4,-40(s0)
	lw	a5,-76(s0)
	blt	a4,a5,.L28
	lw	a5,-20(s0)
	beq	a5,zero,.L29
	lui	a5,%hi(.LC7)
	addi	a0,a5,%lo(.LC7)
	call	puts
	j	.L30
.L29:
	lui	a5,%hi(.LC8)
	addi	a0,a5,%lo(.LC8)
	call	puts
.L30:
	li	a5,0
	mv	a0,a5
	li	t1,40960
	add	sp,sp,t1
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (SiFive GCC 10.1.0-2020.08.2) 10.1.0"
