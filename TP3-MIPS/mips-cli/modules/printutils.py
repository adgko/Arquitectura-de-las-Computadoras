def print_mips_data_dif(response, prev_response, mem_count, reg_count):
    if response:
        # Gather 32bit data from the response
        data = [response[i:i+4] for i in range(0, len(response), 4)]
        
        if(prev_response != 0):
            prev_data = [prev_response[i:i+4] for i in range(0, len(prev_response), 4)]
        else:
            prev_data = 0
        # Extract program counter, clock count, registers, and memory
        pc = ' '.join([format(byte, '08b') for byte in data[0]])
        pc_prev = 0
        if(prev_data != 0):
            pc_prev = ' '.join([format(byte, '08b') for byte in prev_data[0]])

        clk_count = ' '.join([format(byte, '08b') for byte in data[1]])

        registers = []
        prev_registers = []
        for i in range(0, 32):
            registers.append(
                ' '.join([format(byte, '08b') for byte in data[i+2]]))
            if(prev_data != 0):
                prev_registers.append(
                    ' '.join([format(byte, '08b') for byte in prev_data[i+2]]))

        memory = []
        prev_memory = []
        for i in range(0, 16):
            memory.append(
                ' '.join([format(byte, '08b') for byte in data[i+34]]))
            if(prev_data != 0):   
                prev_memory.append(
                    ' '.join([format(byte, '08b') for byte in prev_data[i+34]]))                

        # Print the extracted information

        print(
            f"\nClockCycles: {clk_count} -> {int(clk_count.replace(' ',''), 2)}")

        if(prev_data != 0):
            if( pc == pc_prev):
                print(f"\nProgramCounter: \n\033[34m{pc} -> {int(pc.replace(' ',''), 2)}\033[0m")
            elif(int(pc.replace(' ',''), 2) != int(pc_prev.replace(' ',''), 2)+4):
                print(f"\nProgramCounter: \n\033[35m{pc} -> {int(pc.replace(' ',''), 2)}\033[0m")
            else:
                print(f"\nProgramCounter: \n{pc} -> {int(pc.replace(' ',''), 2)}")
        else:
            print(f"\nProgramCounter: \n{pc} -> {int(pc.replace(' ',''), 2)}")

        if (reg_count > 0):
            print("\n\033[33mREGISTER MEMORY:\033[0m")
            for i in range(reg_count):
                if(prev_data != 0):                    
                    if(registers[i] == prev_registers[i] ):
                        print(
                            f"{i}:  {registers[i]} -> {int(registers[i].replace(' ',''), 2)}")
                    else:
                        print(
                            f"{i}:  \033[32m{registers[i]} -> {int(registers[i].replace(' ',''), 2)}\033[0m")
                else:
                    print(
                            f"{i}:  {registers[i]} -> {int(registers[i].replace(' ',''), 2)}")                   

        if (mem_count > 0):
            print("\n\033[33mDATA MEMORY:\033[0m")
            for i in range(mem_count):
                if(prev_data != 0): 
                    if(memory[i] == prev_memory[i] or prev_data == 0):
                        print(
                            f"{i}:  {memory[i]} -> {int(memory[i].replace(' ',''), 2)}")
                    else:
                        print(
                            f"{i}:  \033[32m{memory[i]} -> {int(memory[i].replace(' ',''), 2)}\033[0m")
                else:
                    print(
                        f"{i}:  {memory[i]} -> {int(memory[i].replace(' ',''), 2)}")                  
                    
def print_mips_data(response, mem_count, reg_count):
    if response:
        # Gather 32bit data from the response
        data = [response[i:i+4] for i in range(0, len(response), 4)]
        # Extract program counter, clock count, registers, and memory
        pc = ' '.join([format(byte, '08b') for byte in data[0]])
        clk_count = ' '.join([format(byte, '08b') for byte in data[1]])
        registers = []
        for i in range(0, 32):
            registers.append(
                ' '.join([format(byte, '08b') for byte in data[i+2]]))

        memory = []
        for i in range(0, 16):
            memory.append(
                ' '.join([format(byte, '08b') for byte in data[i+34]]))              

        # Print the extracted information
        print(
            f"\nClockCycles: {clk_count} -> {int(clk_count.replace(' ',''), 2)}")
        print(f"\nProgramCounter: {pc} -> {int(pc.replace(' ',''), 2)}")

        if (reg_count > 0):
            print("\n\033[33mREGISTER MEMORY:\033[0m")
            for i in range(reg_count):
                print(
                    f"{i}:  {registers[i]} -> {int(registers[i].replace(' ',''), 2)}")                  

        if (mem_count > 0):
            print("\n\033[33mDATA MEMORY:\033[0m")
            for i in range(mem_count):
                print(
                    f"{i}:  {memory[i]} -> {int(memory[i].replace(' ',''), 2)}")


def print_instructions(response, inst_count, offset = 50):
    if response:
        # Gather 32bit data from the response
        data = [response[i:i+4] for i in range(0, len(response), 4)]
        instruction = []
        for i in range(0, inst_count):
            instruction.append(
                ' '.join([format(byte, '08b') for byte in data[i+offset]]))

        if (inst_count > 0):
            print("\n\033[33mINSTRUCTION MEMORY:\033[0m")
            for i in range(inst_count):
                print(
                    f"{i*4}:  {instruction[i]}")
