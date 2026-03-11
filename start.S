.global _start

_start:

    #Tạo địa chỉ GPIO 
    #addi t0, x0, 2047 
    #addi t0, t0, 2047
   # addi t0, t0, 2      # 2047 + 2047 + 2 = 4096

    #addi t1, x0, 128 
    #sw t1, 0(t0)

    la sp, _stack_top
    call main

loop:
   # addi x0, x0, 0
   j loop