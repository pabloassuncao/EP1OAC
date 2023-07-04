.data
result_msg: .asciiz "A média aritmética é: "
matriz: .word 1, 2, 3, 4, 5, 6, 7, 8, 9                 # Matriz row-major order
n: .word 3                                              # Tamanho da matriz
m: .word 3                                              # Tamanho da matriz
x: .word 1                                              # Número da linha i para calcular a média
y: .word 1                                              # Número da coluna j para calcular a média

.text

.globl main

main:
    la      $s0,            matriz                      # $s0 = matriz
    lw      $s1,            n                           # $s1 = n linhas
    lw      $s2,            m                           # $s2 = m colunas
    li      $s3,            0                           # $s3 = soma
    li      $s4,            0                           # $s4 = contador
    li      $s5,            0                           # $s5 = média
    lw      $s6,            x                           # $s6 = x
    lw      $s7,            y                           # $s7 = y
    addi    $a0,            $s6,        -1              # $s6 = x - 1
    move    $a1,            $s7                         # $s7 = y
    jal     get_pos
    add     $s3,            $s3,        $v0             # $s3 = soma + valor da posição válida
    add     $s4,            $s4,        $v1             # $s4 = contador + posição válida

    addi    $a0,            $s6,        1               # $s6 = x + 1
    move    $a1,            $s7                         # $s7 = y
    jal     get_pos
    add     $s3,            $s3,        $v0             # $s3 = soma + valor da posição válida
    add     $s4,            $s4,        $v1             # $s4 = contador + posição válida

    move    $a0,            $s6                         # $s6 = x
    addi    $a1,            $s7,        -1              # $s7 = y - 1
    jal     get_pos
    add     $s3,            $s3,        $v0             # $s3 = soma + valor da posição válida
    add     $s4,            $s4,        $v1             # $s4 = contador + posição válida

    move    $a0,            $s6                         # $s6 = x
    addi    $a1,            $s7,        1               # $s7 = y + 1
    jal     get_pos
    add     $s3,            $s3,        $v0             # $s3 = soma + valor da posição válida
    add     $s4,            $s4,        $v1             # $s4 = contador + posição válida
    # Save parameters on the stack
    subu    $sp,            $sp,        8               # Subtract 8 bytes from stack pointer

    sw      $s3,            0($sp)                      # Store $s3 on the stack
    sw      $s4,            4($sp)                      # Store $s4 on the stack
    j       calc_and_print


calc_and_print:
    # Access parameters in the callee
    lw      $t0,            0($sp)                      # Load $s3 from the stack into $t0
    lw      $t1,            4($sp)                      # Load $s4 from the stack into $t1
    # Clean up the stack
    addu    $sp,            $sp,        8               # Add 8 bytes back to the stack pointer
    # Realiza a divisão da soma pelo contador em ponto flutuante
    mtc1    $t0,            $f4                         # $f0 = soma
    mtc1    $t1,            $f2                         # $f1 = contador
    cvt.s.w $f4,            $f4                         # $f0 = soma
    cvt.s.w $f2,            $f2                         # $f1 = contador
    div.s   $f6,            $f4,        $f2             # $f0 = soma / contador

    la      $a0,            result_msg                  # $a0 = "A média aritmética é: "
    li      $v0,            4                           # $v0 = print_string
    syscall 
    mov.s   $f12,           $f6                         # $f12 = $f0
    li      $v0,            2                           # $v0 = print_float
    syscall 
    li      $v0,            10                          # $v0 = exit
    syscall 

get_pos:
    # Salva o primeiro endereço de retorno para a main antes de chamar outra função
    sw      $ra,            0($sp)                      # Salva o endereço de retorno para a main
    addi    $sp,            $sp,        -4              # Decrementa o ponteiro da pilha
    move    $a2,            $s1                         # $a2 = n
    move    $a3,            $s2                         # $a3 = m

    jal     check_pos
    move    $t4,            $v0                         # $t4 = posição válida
    beq     $t4,            $zero,      get_pos_end

    move    $a2,            $s0                         # $s0 = matriz
    move    $a3,            $t4                         # $a3 = posição válida
    jal     count_pos
    lw      $ra,            4($sp)                      # Carrega o endereço de retorno para a main
    addi    $sp,            $sp,        4               # Incrementa o ponteiro da pilha
    move    $v1,            $t4                         # $v1 = posição válida
    jr      $ra                                         # Retorna para a função chamadora

check_pos:
    # Salva o primeiro endereço de retorno para a validate antes de chamar outra função
    sw      $ra,            0($sp)                      # Salva o endereço de retorno para a main
    addi    $sp,            $sp,        -4              # Decrementa o ponteiro da pilha
    jal     check_x_value
    move    $t2,            $v0                         # $t2 = As duas são verdadeiras para x
    jal     check_y_value
    # Atualiza o endereço de retorno para a main
    lw      $ra,            4($sp)                      # Carrega o endereço de retorno para a main
    addi    $sp,            $sp,        4               # Incrementa o ponteiro da pilha
    move    $t3,            $v0                         # $t3 = As duas são verdadeiras para y
    and     $t4,            $t2,        $t3             # $t4 = $t2 && $t3
    move    $v0,            $t4                         # $v0 = $t4
    jr      $ra                                         # Retorna para a função chamadora

check_x_value:
    li      $t2,            0                           # $t2 = As duas são verdadeiras para x
    li      $t0,            0                           # $t0 = Primeira comparação
    li      $t1,            0                           # $t1 = Segunda comparação
    addi    $t8,            $zero,      -1              # $t8 = -1
    slt     $t0,            $a0,        $a2             # $t0 = x < n
    sgt     $t1,            $a0,        $t8             # $t1 = x > -1
    and     $t2,            $t0,        $t1             # $t2 = $t0 == $t1
    move    $v0,            $t2                         # $v0 = $t2
    jr      $ra                                         # Retorna para a função chamadora

check_y_value:
    li      $t0,            0                           # $t0 = Primeira comparação
    li      $t1,            0                           # $t1 = Segunda comparação
    li      $t3,            0                           # $t3 = As duas são verdadeiras para y
    addi    $t8,            $zero,      -1              # $t8 = -1
    slt     $t0,            $a1,        $a3             # $t0 = y < n
    sgt     $t1,            $a1,        $t8             # $t1 = y > -1
    and     $t3,            $t0,        $t1             # $t3 = $t0 == $t1
    move    $v0,            $t3                         # $v0 = $t3
    jr      $ra                                         # Retorna para a função chamadora

count_pos:
    lw      $t7,            m                           # $t7 = m
    li      $t5,            4                           # $t5 = Tamnho de uma palavra
    mulo    $t6,            $a0,        $t7             # $t6 = x * m
    add     $t6,            $t6,        $a1             # $t6 = x * m + y
    mulo    $t6,            $t6,        $t5             # $t6 = (x * m + y) * 4
    add     $t6,            $a2,        $t6             # $t6 = matriz + (x * m + y) * 4
    lw      $v0,            0($t6)                      # $v0 = matriz[x][y]
    jr      $ra                                         # Retorna para a função chamadora

get_pos_end:
    lw      $ra,            4($sp)                      # Carrega o endereço de retorno para a main
    addi    $sp,            $sp,        4               # Incrementa o ponteiro da pilha
    move    $v0,            $zero                       # $v0 = 0
    move    $v1,            $zero                       # $v1 = 0
    jr      $ra                                         # Retorna para a função chamadora
