#segment de la mémoire contenant les données globales
.data
#tampon résérvé pour une chaîne encodée
buffer: .space 20
I: .ascii "I"
V: .ascii "V"
X: .ascii "X"
L: .ascii "L"
C: .ascii "C"
D: .ascii "D"
M: .ascii "M"
msg: .asciiz "Veuillez entre le nombre de répétitions pour la lettre I : "


#segment de la mémoire contenant le code
.text
main:
li $v0, 4 # Code pour "Print string"
la $a0, msg # Load l'adresse du string dans a0
syscall # Imprime le message

li $v0, 5 # Code pour "Get input value"
syscall # Appel la fonction 
add $t0, $v0, $0 # Le nombre de répétitions est stocké dans $t0

# Rajoute dans le premier argument la valeur entrée par le user
add $a0, $0, $t0

# Load l'adresse associée au tag X dans deuxième argument
la $a1, X

# Load l'adresse du buffer dans troisième argument
la $a2, buffer

#NE PAS EFFACER SVP
#lb $a1, 0($t1)
#la $t2, I
#lw $a2, 0($t2)

jal repeter
add $a2, $v0, $0

jal repeter
# Terminer le programme
li $v0,10 
syscall



#fonction répéter; n’oubliez pas les commentaires!
repeter:
# Instancie s0 à 0 et t0 au nombre de répétitions
add $s0, $0, $0
add $t0, $0, $a0

for: 
# Si nb répétition =0, on quitte
beq $s0, $t0, done
addi $s0, $s0, 1
lb $t2, 0($a1)
sb $t2, 0($a2)
addi $a2, $a2, 1
j for

done:
# Mets la valeur de la prochaine adresse dispo dans $v0
la $v0, 0($a2)
jr $ra


print:
li  $v0, 11          # TODO LATER : print char
add $a0, $t0, $zero  # load desired value into argument register $a0, using pseudo-op
syscall

la $a0, msg
li $v0, 4 # TODO LATER : Print string (Code 4 de syscall)
syscall # faire appel du service


#fonction chiffre
chiffre:

#addi $t0, $0, 4
#slt $t1, $s1, $t0
#bne $t1, $0, elif2
#jal repeter
#j done
#elif1:
#bne $t0, $t1, done
#jal elif2
#elif2:
#addi $t0,$0,9
#slt $t1,$s1,$t0
#else:
#done:
jr $ra
