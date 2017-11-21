# Description du programme : Prend un nombre entre 1 et 3999 entré par l'utilisateur. Envoie ensuite ce nombre à la fonction romain, qui appelle chiffre 
# pour chaque rang de nombres (1000,100,10,1). Chiffre s'occupe de vérifier la valeur du chiffre à la position donnée en utilisant la divison et le modulo 10.
# Dépendemment du chiffre, on répète si nécessaire la même lettre romaine ou on concatène les lettres.

# But : Traduire un nombre décimal en nombre romain
# Date : 16 nov 2017
# Auteur(s) : Maude Sabourin et Hanifa Mallek
# Adresse(s) de courriel : maude.sabourin@umontreal.ca
# Code(s) permanent(s) : p1141140

# Segment de la mémoire contenant les données globales
.data

# Tampon résérvé pour une chaîne encodée
buffer: .space 20
I: .ascii "I"
V: .ascii "V"
X: .ascii "X"
L: .ascii "L"
C: .ascii "C"
D: .ascii "D"
M: .asciiz "M"
msg: .asciiz "Ce programme permet de convertir un nombre décimal en nombre romain. Veuillez entrer un nombre entre 1 et 3999 : "
err: .asciiz "Le nombre entré est invalide =(  "
res: .asciiz "Voulez-vous recommencer avec un autre nombre? 1 pour Oui, 0 pour Non"

# Segment de la mémoire contenant le code
.text
main:
li $v0, 4 # Code pour "Print string"
la $a0, msg # Load l'adresse du string dans a0
syscall # Imprime le message

li $v0, 5 # Code pour "Get input value"
syscall # Appelle la fonction 
add $t0, $v0, $0 # Le nombre est stocké dans $t0

add $a0, $0, $t0 # Rajoute dans le premier argument la valeur entrée par le user

addi $t0, $0, 1
addi $t1, $0, 3999

# On vérifie si le nombre est plus grand que 3999
slt $t2, $a0, $t1
beq $t2, $0, erreur

# On vérifie si le nombre est plus petit que 0
slt $t2, $a0, $t0
bne $t2, $0, erreur

jal romain # On appelle le traducteur

la $a0, buffer # On affiche le résultat se trouvant à l'adresse initiale du buffer
li $v0, 4 # Code pour "Print string"
syscall # Appel du service

j restart

erreur:
li $v0, 4 # Code pour "Print string"
la $a0, err # Load l'adresse du string dans a0
syscall # Imprime le message d'erreur

restart:
addi $a0, $0, 0xA    # afficher une ligne vide
addi $v0, $0, 0xB    # suite pour afficher une ligne vide
syscall

li $v0, 4 # Code pour "Print string"
la $a0, res # Demande pour recommencer
syscall # Imprime le message d'erreur

addi $a0, $0, 0xA    # afficher une ligne vide
addi $v0, $0, 0xB    # suite pour afficher une ligne vide
syscall

li $v0, 5 # Code pour "Get input value"
syscall # Appelle la fonction 
add $t0, $v0, $0 # Le nombre est stocké dans $t0

beq $t0, $0, end #Si on veut quitter
addi $t3, $0, 20
add $t4, $0, $0
la $t2, buffer # Avant de jump, on doit clean le registre

loop:
beq $t3, $t4, jump
addi $t4, $t4, 1
#sb $t2, 0($0
#add $t2, $0, $0
xor $t5, $t2, $t2
#sb $t2, 0($t5)
addi $t2, $t2, 1
j loop

jump:
j main

end:
# Terminer le programme
li $v0,10 
syscall

# parametres--------------
# a0:nombre à encoder
#-------------------------
romain:
addi $sp, $sp, -8 # make space on stack
sw $ra, 0($sp) # met l'adresse de retour sur la stack

# Puisque $a0 va changer dans les fonctions chiffres, on a besoin de le stocker dans une variable temporaire au niveau de romain
add $t7, $0, $a0
addi $a1, $0, 1000 # Rang des milliers
la $a2, M # Adresse de la sous-chaine des milliers
la $a3, buffer # Adresse du premier endroit où on va écrire la traduction
jal chiffre

add $a3, $v0, $0 # Met à jour l'adresse résultat
add $a0, $0, $t7 # Réinitialise l'argument à envoyer à ce qu'il était initialement
addi $a1, $0, 100 # Rang des centaines
la $a2, C # Adresse sous-chaîne des milliers
jal chiffre

# Idem avec dizaines
add $a3, $v0, $0
add $a0, $0, $t7
addi $a1, $0, 10
la $a2, X
jal chiffre

# Idem avec unités
add $a3, $v0, $0 
add $a0, $0, $t7
addi $a1, $0, 1
la $a2, I
jal chiffre

lw $ra, 0($sp) # restore $s0 from stack
addi $sp, $sp, 8 # deallocate stack space
jr $ra



# parametres--------------
# a0: nb de repetitions
# a1: adresse symbole encodage
# a2: adresse resultat
#------------------------
repeter:
# Instancie s0 à 0 et t0 au nombre de répétitions
add $s0, $0, $0
add $t0, $0, $a0

for: 
# Si nb répétition = 0, on quitte
beq $s0, $t0, done
addi $s0, $s0, 1 # Incrémente notre i
lb $t2, 0($a1) # Load la valeur du caractère ascii
sb $t2, 0($a2) # Store la valeur dans l'adresse résultat
addi $a2, $a2, 1 # Incrémente l'adresse résultat de 1
j for

done:
# Mets la valeur de la prochaine adresse dispo dans $v0
la $v0, 0($a2)
jr $ra




# parametres--------------
# a0: le nombre à encoder
# a1: un rang du chiffre à encoder dans ce nombre
# a2: l’adresse de la sous chaîne contenant les symboles d’encodage pour le rang spécifié
# a3: l’adresse à partir de laquelle il faut placer une chaîne résultat.
#------------------------
chiffre:
sw $ra, 4($sp) # Store l'adresse de retour sur la stack

div $a0, $a1 # Divise le nombre par le rang
mflo $t0 # On met le quotient dans $t0
addi $t1, $0, 10 
div $t0, $t1 # On divise le quotient par 10
mfhi $t0 # On va chercher le remainder pour simuler un modulo 10

beq $t0, $0, zero # Si le résultat est 0, on a rien à faire
addi $t1, $0, 4
slt $t2, $t0, $t1
beq $t2, $0, over3
    # Le chiffre est entre 1 et 3 inclus --> On veut retourner repetition du caract de poids 1
    add $a0, $0, $t0 # On instancie les paramètres à envoyer à répéter, ici le nombre de répétition
    la $a1, 0($a2) # L'adresse du caractère de poids 1
    la $a2, 0($a3) # L'adresse de retour
    jal repeter
    add $a3, $v0, $0 # Met à jour l'adresse du résultat
    j zero # Saute les autres
over3:
bne $t0, $t1, over4
    # Le chiffre vaut 4 --> On veut retourner caract 1 + caract 5, ex 'IV'
    lb $t3, 0($a2) # $t3 contient la valeur ascii du caractere de poids 1
    addi $a2, $a2, 1 # Incrémente pour aller chercher la prochaine valeur
    lb $t4, 0($a2) # $t4 contient la valeur ascii du caractere de poids 5
    sb $t3, 0($a3) # Met le caract 1 dans le registre résultat
    addi $a3, $a3, 1 # Incrémente le registre résultat de 1
    sb $t4, 0($a3) # Met le caract 5 dans le registre résultat
    addi $a3, $a3, 1
    j zero
over4:
addi $t1, $0, 9
slt $t2, $t0, $t1
beq $t2, $0, over9
    # Le chiffre est entre 5 et 8 inclus --> On veut retourner caract 5 + repetition caract 1
    addi $a2, $a2, 1 
    lb $t4, 0($a2) # $t4 contient la valeur ascii caract poids 5
    sb $t4, 0($a3) # Store la valeur dans l'adresse de résultat
    addi $a3, $a3, 1 # Incrémente l'adresse de retour
    subi $t5, $t0, 5 # Soustrait le quotient de 5
    subi $a2, $a2, 1  # Remet l'adresse du caractere de poids 1
    # Init les parametres pour repeter
    add $a0, $0, $t5 
    la $a1, 0($a2)
    la $a2, 0($a3)
    jal repeter
    add $a3, $v0, $0 # Met à jour l'adresse resultat
    j zero
over9:
    # Le chiffre est 9 --> On veut retourner caract 1 + caract 10, ex:'XI'
    lb $t3, 0($a2) # $t3 contient la valeur ascii du caractere 1
    addi $a2, $a2, 2
    lb $t4, 0($a2) # $t4 contient la valeur ascii du caractere 10
    sb $t3, 0($a3)
    addi $a3, $a3, 1
    sb $t4, 0($a3)
    addi $a3, $a3, 1 # Incremente l'adresse résultat
    j zero

zero:
add $v0, $a3, $0  # Mets la valeur de la prochaine adresse dispo dans $v0

lw $ra, 4($sp) # restore $s0 from stack
jr $ra
