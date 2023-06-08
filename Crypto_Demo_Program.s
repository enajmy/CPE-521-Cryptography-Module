.equ LEDS, 0x110C0000

.global main 
.type main, @function

.data
sseg: .byte 0x03, 0x9F, 0x25, 0x0D, 0x99, 0x49, 0x41, 0x1F, 0x01, 0x09

.text
main: 
init:   li x7, 1000
        li x8, 100
        li x9, 10
        li x11, 0x110C0000  # SEGS
        li x12, 0x11000000 # SWITCHES
        li x13, 1
        li x14, 2
        li x21, 0x8000 # mask the left switch
        li x20, 0x4000 # mask the second left most switch
        li x19, 0x2000 # mask the third left most switch
        li x28, 0
        li x30, 0xFFF #mask 12 switches
        sw x13, 0(x11)

loop1:
# check if left switch is pushed, if so read the switches
lhu x22, 0(x12)
and x23, x21, x22
beqz x23, loop1

and x24, x22, x30
sw x14, 0(x11)

loop2:
# check if left switch is pushed, if so read the switches
lhu x22, 0(x12)
and x23, x20, x22
beqz x23, loop2

and x25, x22, x30
mv x27, x25
# encrypt the numbers (add)
encrypt x25, x25, x24
mv x26, x25 #save encrypted value before converting to bcd
call bcd
sw x28, 0(x11)

loop3:
lhu x22, 0(x12)
sub x23, x19, x22
beqz x23, loop3

# decrypt the numbers (subtract)
decrypt x25, x26, x27
call bcd
sw x28, 0(x11)

ret

bcd: 	mv x28, x0
thou:	blt x25, x7, hund
	addi x28, x28, 1
	addi x25, x25, -1000
	j thou

hund:	slli x28, x28, 4
hund_l:	blt x25, x8, tens
	addi x28, x28, 1
	addi x25, x25, -100
	j hund_l

tens:	slli x28, x28, 4
tens_l:	blt x25, x9, ones
	addi x28, x28, 1
	addi x25, x25, -10
	j tens_l

ones:	# x25 has ones
	slli x28, x28, 4
	add x28, x25, x28
	ret
