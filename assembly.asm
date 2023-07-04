.data
result_msg: .asciiz "A média aritmética é: "
matriz: .word 1, 2, 3, 4, 5, 6, 7, 8, 9                 # Matriz row-major order
n: .word 3                                              # Tamanho da matriz
x: .word 1                                              # Número da linha i para calcular a média
y: .word 0                                              # Número da coluna j para calcular a média

.text

.globl main

main:
    la      $s0,            matriz                      # $s0 = matriz
    lw      $s1,            n                           # $s1 = n
    li      $s2,            0                           # $s2 = soma
    li      $s3,            0                           # $s3 = contador
    li      $s4,            4                           # $s4 = tamanho de uma palavra
    li      $s5,            0                           # $s5 = média
    lw      $s6,            x                           # $s6 = x
    lw      $s7,            y                           # $s7 = y

    addi    $a0,            $s6,        -1              # $s6 = x - 1
    move    $a1,            $s7                         # $s7 = y
    jal     get_pos
    add     $s2,            $s2,        $v0             # $s2 = soma + valor da posição válida
    add     $s3,            $s3,        $v1             # $s3 = contador + posição válida

    addi    $a0,            $s6,        1               # $s6 = x + 1
    move    $a1,            $s7                         # $s7 = y
    jal     get_pos
    add     $s2,            $s2,        $v0             # $s2 = soma + valor da posição válida
    add     $s3,            $s3,        $v1             # $s3 = contador + posição válida

    move    $a0,            $s6                         # $s6 = x
    addi    $a1,            $s7,        -1              # $s7 = y - 1
    jal     get_pos
    add     $s2,            $s2,        $v0             # $s2 = soma + valor da posição válida
    add     $s3,            $s3,        $v1             # $s3 = contador + posição válida

    move    $a0,            $s6                         # $s6 = x
    addi    $a1,            $s7,        1               # $s7 = y + 1
    jal     get_pos
    add     $s2,            $s2,        $v0             # $s2 = soma + valor da posição válida
    add     $s3,            $s3,        $v1             # $s3 = contador + posição válida

# Realiza a divisão da soma pelo contador em ponto flutuante
    mtc1    $s2,            $f4                         # $f0 = soma
    mtc1    $s3,            $f2                         # $f1 = contador
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
    move    $a2,            $s1                         # $s1 = n
    addi    $a3,            $zero,      -1              # $a3 = -1

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
    slt     $t0,            $a0,        $a2             # $t0 = x < n
    sgt     $t1,            $a0,        $a3             # $t1 = x > -1
    and     $t2,            $t0,        $t1             # $t2 = $t0 == $t1
    move    $v0,            $t2                         # $v0 = $t2
    jr      $ra                                         # Retorna para a função chamadora

check_y_value:
    li      $t0,            0                           # $t0 = Primeira comparação
    li      $t1,            0                           # $t1 = Segunda comparação
    li      $t3,            0                           # $t3 = As duas são verdadeiras para y
    slt     $t0,            $a1,        $a2             # $t0 = y < n
    sgt     $t1,            $a1,        $a3             # $t1 = y > -1
    and     $t3,            $t0,        $t1             # $t3 = $t0 == $t1
    move    $v0,            $t3                         # $v0 = $t3
    jr      $ra                                         # Retorna para a função chamadora

count_pos:
    lw      $t7,            n                           # $t7 = n
    li      $t5,            4                           # $t5 = Tamnho de uma palavra
    mulo    $t6,            $a0,        $t7             # $t6 = x * n
    add     $t6,            $t6,        $a1             # $t6 = x * n + y
    mulo    $t6,            $t6,        $t5             # $t6 = (x * n + y) * 4
    add     $t6,            $a2,        $t6             # $t6 = matriz + (x * n + y) * 4
    lw      $v0,            0($t6)                      # $v0 = matriz[x][y]
    jr      $ra                                         # Retorna para a função chamadora

get_pos_end:
    lw      $ra,            4($sp)                      # Carrega o endereço de retorno para a main
    addi    $sp,            $sp,        4               # Incrementa o ponteiro da pilha
    move    $v0,            $zero                       # $v0 = 0
    move    $v1,            $zero                       # $v1 = 0
    jr      $ra                                         # Retorna para a função chamadora
