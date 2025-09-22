# https://ecs-network.serv.pacific.edu/ecpe-170/tutorials/mips-instruction-set
INSTRUCTIONS = {
    'add': ['r', '100000', 'null'],
    'addi': ['i', '001000', 'null'],
    'addu': ['r', '100001', 'null'],
    'and': ['r', '100100', 'null'],
    'andi': ['i', '001100', 'null'],
    'beq': ['i', '000100', 'branch'],
    'bne': ['i', '000101', 'branch'],
    'j': ['i', '000010', 'jump'],
    'jal': ['i', '000011', 'jump'],
    'jalr': ['j', '001001', 'null'],
    'jr': ['j', '001000', 'null'],
    'lb': ['i', '100000', 'offset'],
    'lbu': ['i', '100100', 'offset'],
    'lh': ['i', '100001', 'offset'],
    'lhu': ['i', '100101', 'offset'],
    'lui': ['i', '001111', 'lui'],
    'lw': ['i', '100011', 'offset'],
    'lwu': ['i', '100111', 'offset'],
    'nor': ['r', '100111', 'null'],
    'or': ['r', '100101', 'null'],
    'ori': ['i', '001101', 'null'],
    'sb': ['i', '101000', 'offset'],
    'sh': ['i', '101001', 'offset'],
    'sll': ['r', '000000', 'sa'],
    'sllv': ['r', '000100', 'shift'],
    'slt': ['r', '101010', 'null'],
    'slti': ['i', '001010', 'null'],
    'sra': ['r', '000011', 'sa'],
    'srav': ['r', '000111', 'shift'],
    'srl': ['r', '000010', 'sa'],
    'srlv': ['r', '000110', 'shift'],
    'sub': ['r', '100010', 'null'],
    'subu': ['r', '100011', 'null'],
    'sw': ['i', '101011', 'offset'],
    'xor': ['r', '100110', 'null'],
    'xori': ['i', '001110', 'null']
}

REGISTERS = {
    'r0': '00000',
    'r1': '00001',
    'r2': '00010',
    'r3': '00011',
    'r4': '00100',
    'r5': '00101',
    'r6': '00110',
    'r7': '00111',
    'r8': '01000',
    'r9': '01001',
    'r10': '01010',
    'r11': '01011',
    'r12': '01100',
    'r13': '01101',
    'r14': '01110',
    'r15': '01111',
    'r16': '10000',
    'r17': '10001',
    'r18': '10010',
    'r19': '10011',
    'r20': '10100',
    'r21': '10101',
    'r22': '10110',
    'r23': '10111',
    'r24': '11000',
    'r25': '11001',
    'r26': '11010',
    'r27': '11011',
    'r28': '11100',
    'r29': '11101',
    'r30': '11110',
    'r31': '11111'
}


def r_instr(instr, args):

    opcode = INSTRUCTIONS[instr][1]
    instr_obs = INSTRUCTIONS[instr][2]

    if (instr_obs == 'shift'):
        reg_rd, reg_rt, reg_rs = map(str.strip, args.split(','))
        rd = REGISTERS[reg_rd]
        rt = REGISTERS[reg_rt]
        rs = REGISTERS[reg_rs]
        binary = f"000000{rs}{rt}{rd}00000{opcode}"

    elif (instr_obs == 'sa'):
        reg_rd, reg_rt, sa = map(str.strip, args.split(','))
        rd = REGISTERS[reg_rd]
        rt = REGISTERS[reg_rt]
        sa = bin(int(sa) & 0b11111)[2:].zfill(5)
        binary = f"00000000000{rt}{rd}{sa}{opcode}"

    else:
        reg_rd, reg_rs, reg_rt = map(str.strip, args.split(','))
        rd = REGISTERS[reg_rd]
        rt = REGISTERS[reg_rt]
        rs = REGISTERS[reg_rs]
        binary = f"000000{rs}{rt}{rd}00000{opcode}"

    return binary


def i_instr(instr, args):
    
    opcode = INSTRUCTIONS[instr][1]
    instr_obs = INSTRUCTIONS[instr][2]
    
    if (instr_obs == 'offset'):
        reg_rt, iargs = map(str.strip, args.split(','))
        offset, reg_base = iargs.strip(')').split('(')

        rt = REGISTERS[reg_rt]
        base = REGISTERS[reg_base]
        boffset = bin(int(offset) & 0b1111111111111111)[2:].zfill(16)
        binary = f"{opcode}{base}{rt}{boffset}"
    
    elif (instr_obs == 'branch'):
        reg_rs, reg_rt, offset = map(str.strip, args.split(','))
        rs = REGISTERS[reg_rs]
        rt = REGISTERS[reg_rt]
        boffset = bin(int(offset) & 0b1111111111111111)[2:].zfill(16)
        binary = f"{opcode}{rs}{rt}{boffset}"
    
    elif (instr_obs == 'jump'):
        btarget = bin(int(args) & 0b11111111111111111111111111)[2:].zfill(26)
        binary = f"{opcode}{btarget}"

    elif (instr_obs == 'lui'):
        reg_rt, immediate = map(str.strip, args.split(','))
        rt = REGISTERS[reg_rt]
        bimmediate = bin(int(immediate) & 0b1111111111111111)[2:].zfill(16)
        binary = f"{opcode}00000{rt}{bimmediate}"

    else:
        reg_rt, reg_rs, immediate = map(str.strip, args.split(','))
        rt = REGISTERS[reg_rt]
        rs = REGISTERS[reg_rs]
        bimmediate = bin(int(immediate) & 0b1111111111111111)[2:].zfill(16)
        binary = f"{opcode}{rs}{rt}{bimmediate}"

    return binary


def j_instr(instr, args):

    opcode = INSTRUCTIONS[instr][1]

    if opcode == INSTRUCTIONS['jalr'][1]:
        rs = REGISTERS[args]
        ##rs = bin(int(args) & 0b11111)[2:].zfill(5)
        binary = f"000000{rs}000001111100000{opcode}"
    else:
        rs = REGISTERS[args]
        ##rs = bin(int(args) & 0b11111)[2:].zfill(5)
        binary = f"000000{rs}000000000000000{opcode}"
      
    return binary


def create_raw_file(asm_file, output_bin_file):
    # Open the input file for reading
    count = 1
    with open(asm_file, 'r') as f:
        # Open the output file for writing
        with open(output_bin_file, 'w') as out:
            # Loop through each line in the input file
            for line in f:
                # Split the line into its individual parts
                parts = line.strip().split(' ')

                binary = 0

                # If the line is not empty
                if parts:

                    if (parts[0] == 'nop'):
                        binary = f"00000000000000000000000000000000"
                        out.write( binary + '\n' )
                        count += 1

                    elif (parts[0] == 'halt'):
                        binary = f"11111100000000000000000000000000"
                        out.write( binary + '\n' )
                        count += 1

                    else:
                        # Get the binary code for the instruction
                        instr_type = INSTRUCTIONS[parts[0]][0]
                    

                        if (instr_type == 'r'):
                            binary = r_instr(parts[0], parts[1])

                        elif (instr_type == 'i'):
                            binary = i_instr(parts[0], parts[1])

                        elif (instr_type == 'j'):
                            binary = j_instr(parts[0], parts[1])

                        else:
                            print("error")

                        out.write( binary + '\n')
                        count += 1

            out.write(f"11111111111111111111111111111111")
    return count
