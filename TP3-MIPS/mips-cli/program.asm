nop
add r0,r1,r3
sub r1,r0,r2
xor r1,r2,r3
lb r4,1(r2)
sw r2,4(r3)
sllv r5,r1,r3
srlv r5,r1,r3
j 11
sra r1,r2,2
addu r1,r2,r3
subu r1,r2,r3
lw r6,1(r8)
and r1,r0,r6
beq r3,r3,3
halt
lbu r5,1(r2)
lhu r6,1(r2)
lh r1,1(r2)
sh r3,2(r2)
bne r1,r1,5
jal 24
andi r7,r3,10
srl r4,r5,2
nor r4,r1,r1
ori r1,r0,112
jalr r1
or r4,r2,r3
lwu r4,1(r2)
xori r3,r2,19
slt r1,r2,r3
nop
xori r1,r0,144
jr r1
lui r1,28
sll r1,r2,8
slti r3,r0,1
srav r4,r5,r0
sra r1,r3,7
halt
