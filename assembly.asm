.data
new_line: .asciiz "\n"                                  # String para imprimir uma nova linha
space: .asciiz " "                                      # String para imprimir um espaço
matriz: .word 1, 2, 3, 4, 5, 6, 7, 8, 9                 # Matriz row-major order
n: .word 3                                              # Tamanho da matriz
m: .word 3                                              # Tamanho da matriz

.text

.globl main

main:
    la      $s0,            matriz                      # $s0 = matriz
    lw      $s1,            n                           # $s1 = n
    lw      $s2,            m                           # $s2 = m
    li      $t8,            0                           # $t8 = row
    li      $t9,            0                           # $t9 = column

# Outer loop (rows)
outer_loop:
    inner_loop:
        move        $a0,            $t8                         # $a0 = x
        move        $a1,            $t9                         # $a1 = y
        jal         adj_average
        addi        $t9,            $t9,        1               # column = column + 1
        bne         $t9,            $s2,        inner_loop      # Valida se a coluna é menor que m

        li          $t9,            0                           # column = 0
        addi        $t8,            $t8,        1               # row = row + 1

        li          $v0,            4                           # $v0 = 4
        la          $a0,            new_line                    # $a0 = new_line
        syscall                                                 # Imprime uma nova linha

        bne         $t8,            $s1,        outer_loop      # Valida se a linha é menor que n

        li          $v0,            10                          # $v0 = 10
        syscall                                                 # Termina o programa

adj_average:
                                                            # Salva o primeiro endereço de retorno para a main antes de chamar outra função
    sw          $ra,            0($sp)                      # Salva o endereço de retorno para a main
    addi        $sp,            $sp,        -4              # Decrementa o ponteiro da pilha
    li          $s3,            0                           # $s3 = soma
    li          $s4,            0                           # $s4 = contador
    li          $s5,            0                           # $s5 = média
    move        $s6,            $a0                         # $s6 = x
    move        $s7,            $a1                         # $s7 = y
    addi        $a0,            $s6,        -1              # $s6 = x - 1
    move        $a1,            $s7                         # $s7 = y
    jal         get_pos
    add         $s3,            $s3,        $v0             # $s3 = soma + valor da posição válida
    add         $s4,            $s4,        $v1             # $s4 = contador + posição válida

    addi        $a0,            $s6,        1               # $s6 = x + 1
    move        $a1,            $s7                         # $s7 = y
    jal         get_pos
    add         $s3,            $s3,        $v0             # $s3 = soma + valor da posição válida
    add         $s4,            $s4,        $v1             # $s4 = contador + posição válida

    move        $a0,            $s6                         # $s6 = x
    addi        $a1,            $s7,        -1              # $s7 = y - 1
    jal         get_pos
    add         $s3,            $s3,        $v0             # $s3 = soma + valor da posição válida
    add         $s4,            $s4,        $v1             # $s4 = contador + posição válida

    move        $a0,            $s6                         # $s6 = x
    addi        $a1,            $s7,        1               # $s7 = y + 1
    jal         get_pos
    add         $s3,            $s3,        $v0             # $s3 = soma + valor da posição válida
    add         $s4,            $s4,        $v1             # $s4 = contador + posição válida
                                                            # Salva os parâmetros na pilha
    addi        $sp,            $sp,        -8              # Subtrai 8 bytes do ponteiro da pilha

    sw          $s3,            0($sp)                      # Salva $s3 na pilha
    sw          $s4,            4($sp)                      # Salva $s4 na pilha
                                                            # Chama a função calc_and_print
    jal         calc_and_print

    lw          $ra,            4($sp)                      # Carrega o endereço de retorno para a main
    addi        $sp,            $sp,        4               # Incrementa o ponteiro da pilha
    jr          $ra                                         # Retorna para a main


calc_and_print:
                                                            # Acessa os parâmetros da pilha
    lw          $t0,            0($sp)                      # $t0 = soma
    lw          $t1,            4($sp)                      # $t1 = contador
                                                            # Limpa a pilha
    addi        $sp,            $sp,        8               # Incrementa o ponteiro da pilha
                                                            # Realiza a divisão da soma pelo contador em ponto flutuante
    mtc1        $t0,            $f4                         # $f0 = soma
    mtc1        $t1,            $f2                         # $f1 = contador
    cvt.s.w     $f4,            $f4                         # $f0 = soma
    cvt.s.w     $f2,            $f2                         # $f1 = contador
    div.s       $f6,            $f4,        $f2             # $f0 = soma / contador

    li          $t0,            10                          # $t0 = 10
    mtc1        $t0,            $f2                         # $f2 = 10
    cvt.s.w     $f2,            $f2                         # $f2 = 10
    mul.s       $f6,            $f6,        $f2             # $f0 = soma * 10
                                                            # Transforma o float em apenas duas casas decimais
    trunc.w.s   $f6,            $f6                         # $f0 = soma * 10
    cvt.s.w     $f6,            $f6                         # $f0 = soma * 10
    div.s       $f6,            $f6,        $f2             # $f0 = soma * 10 / 10
                                                            # Imprime o resultado
    li          $v0,            2                           # $v0 = print_float
    mov.s       $f12,           $f6                         # $f12 = $f6
    syscall 
                                                            
    li          $v0,            4                           # $v0 = print_string
    la          $a0,            space                       # $a0 = space
    syscall 

    jr          $ra                                         # Retorna para a função que chamou calc_and_print

get_pos:    
                                                            # Salva o primeiro endereço de retorno para a main antes de chamar outra função
    sw          $ra,            0($sp)                      # Salva o endereço de retorno para a main
    addi        $sp,            $sp,        -4              # Decrementa o ponteiro da pilha
    move        $a2,            $s1                         # $a2 = n
    move        $a3,            $s2                         # $a3 = m

    jal         check_pos
    move        $t4,            $v0                         # $t4 = posição válida
    beq         $t4,            $zero,      get_pos_end

    move        $a2,            $s0                         # $s0 = matriz
    move        $a3,            $t4                         # $a3 = posição válida
    jal         count_pos
    lw          $ra,            4($sp)                      # Carrega o endereço de retorno para a main
    addi        $sp,            $sp,        4               # Incrementa o ponteiro da pilha
    move        $v1,            $t4                         # $v1 = posição válida
    jr          $ra                                         # Retorna para a função chamadora

check_pos:  
                                                            # Salva o primeiro endereço de retorno para a validate antes de chamar outra função
    sw          $ra,            0($sp)                      # Salva o endereço de retorno para a main
    addi        $sp,            $sp,        -4              # Decrementa o ponteiro da pilha
    jal         check_x_value
    move        $t2,            $v0                         # $t2 = As duas são verdadeiras para x
    jal         check_y_value
                                                            # Atualiza o endereço de retorno para a main
    lw          $ra,            4($sp)                      # Carrega o endereço de retorno para a main
    addi        $sp,            $sp,        4               # Incrementa o ponteiro da pilha
    move        $t3,            $v0                         # $t3 = As duas são verdadeiras para y
    and         $t4,            $t2,        $t3             # $t4 = $t2 && $t3
    move        $v0,            $t4                         # $v0 = $t4
    jr          $ra                                         # Retorna para a função chamadora

check_x_value:
    li          $t2,            0                           # $t2 = As duas são verdadeiras para x
    li          $t0,            0                           # $t0 = Primeira comparação
    li          $t1,            0                           # $t1 = Segunda comparação
    addi        $t6,            $zero,      -1              # $t6 = -1
    slt         $t0,            $a0,        $a2             # $t0 = x < n
    sgt         $t1,            $a0,        $t6             # $t1 = x > -1
    and         $t2,            $t0,        $t1             # $t2 = $t0 == $t1
    move        $v0,            $t2                         # $v0 = $t2
    jr          $ra                                         # Retorna para a função chamadora

check_y_value:
    li          $t0,            0                           # $t0 = Primeira comparação
    li          $t1,            0                           # $t1 = Segunda comparação
    li          $t3,            0                           # $t3 = As duas são verdadeiras para y
    addi        $t6,            $zero,      -1              # $t6 = -1
    slt         $t0,            $a1,        $a3             # $t0 = y < n
    sgt         $t1,            $a1,        $t6             # $t1 = y > -1
    and         $t3,            $t0,        $t1             # $t3 = $t0 == $t1
    move        $v0,            $t3                         # $v0 = $t3
    jr          $ra                                         # Retorna para a função chamadora

count_pos:  
    lw          $t6,            m                           # $t6 = m
    li          $t5,            4                           # $t5 = Tamnho de uma palavra
    mulo        $t6,            $a0,        $t6             # $t6 = x * m
    add         $t6,            $t6,        $a1             # $t6 = x * m + y
    mulo        $t6,            $t6,        $t5             # $t6 = (x * m + y) * 4
    add         $t6,            $a2,        $t6             # $t6 = matriz + (x * m + y) * 4
    lw          $v0,            0($t6)                      # $v0 = matriz[x][y]
    jr          $ra                                         # Retorna para a função chamadora

get_pos_end:    
    lw          $ra,            4($sp)                      # Carrega o endereço de retorno para a main
    addi        $sp,            $sp,        4               # Incrementa o ponteiro da pilha
    move        $v0,            $zero                       # $v0 = 0
    move        $v1,            $zero                       # $v1 = 0
    jr          $ra                                         # Retorna para a função chamadora
