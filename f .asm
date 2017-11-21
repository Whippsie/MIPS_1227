# Description du programme : Prend un nombre et appelle la fonction f de manière récursive. Le programme teste les valeurs 5,23,45,0 et 100, mais permet
# également à l'usager d'entrer un autre nombre.

# But : Appeler la fonction f et gérer l'appel récursif avec la stack
# Date : 20 nov 2017
# Auteur(s) : Maude Sabourin et Hanifa Mallek
# Adresse(s) de courriel : maude.sabourin@umontreal.ca
# Code(s) permanent(s) : p1141140

.data
msg1: .asciiz "Le résultat de l'appel f "
msg2:.asciiz " avec l'argument 5 est "
msg3:.asciiz " avec l'argument 23 est "
msg4:.asciiz " avec l'argument 45 est "
msg5:.asciiz " avec l'argument 0 est "
msg6:.asciiz " avec l'argument 100 est "
msg7:.asciiz "Voulez-vous essayer la récursion d'un autre nombre ? "
msg8:.asciiz "O/N ? : "
msg9:.asciiz "Saisissez le nombre à calculer : "
msg10:.asciiz "Voici le résultat calculé : "

.text
main:
# Récursion de 5
   addi $a0, $0, 5         # stocker l'arguement 5 dasn $a0
   jal f                   # appel de f
  
   add $t0, $0, $v0
   li $v0, 4
   la $a0, msg1            # affichage du message  
   syscall
   li $v0, 4
   la $a0, msg2            # affichage du message  
   syscall
   li  $v0, 1              # afficher la valeur de retour
   add $a0, $t0, $0	   # mettre la valeur de retour dans ;e registre $a0
   syscall
   addi $a0, $0, 0xA       # afficher une ligne vide
   addi $v0, $0, 0xB       # suite pour afficher une ligne vide
   syscall

# Récursion de 23      
   addi $a0, $0, 23    	   # stocker l'arguement 23 dasn $a0
   jal f                   # appel de f
	
   add $t0, $0, $v0
   li $v0, 4
   la $a0, msg1            # affichage du message 
   syscall
    li $v0, 4
   la $a0, msg3            # affichage du message  
   syscall
   li  $v0, 1              # afficher la valeur de retour
   add $a0, $t0, $0        # mettre la valeur de retour dans ;e registre $a0
   syscall
   addi $a0, $0, 0xA       # afficher une ligne vide
   addi $v0, $0, 0xB       # suite pour afficher une ligne vide
   syscall
   
   # Récursion de 45
   addi $a0, $0, 45      # stocker l'arguement 45 dasn $a0
   jal f                 # appel de f
  
   add $t0, $0, $v0
   li $v0, 4
   la $a0, msg1          # affichage du message 
   syscall
    li $v0, 4
   la $a0, msg4          # affichage du message  
   syscall
   li  $v0, 1            # afficher la valeur de retour
   add $a0, $t0, $0      # mettre la valeur de retour dans ;e registre $a0
   syscall
   addi $a0, $0, 0xA     # afficher une ligne vide
   addi $v0, $0, 0xB     # suite pour afficher une ligne vide
   syscall
   
   # Récursion de 0
   addi $a0, $0, 0      # stocker l'arguement 0 dasn $a0
   jal f                # appel de f
  
   add $t0, $0, $v0
   li $v0, 4
   la $a0, msg1         # affichage du message 
   syscall
   li $v0, 4
   la $a0, msg5         # affichage du message 
   syscall
   li  $v0, 1           # afficher la valeur de retour
   add $a0, $t0, $0     # mettre la valeur de retour dans ;e registre $a0
   syscall
   addi $a0, $0, 0xA    # afficher une ligne vide
   addi $v0, $0, 0xB    # suite pour afficher une ligne vide
   syscall
   
   # Récursion de 100
   addi $a0, $0, 100    # stocker l'arguement 100 dasn $a0
   jal f                # appel de f
  
   add $t0, $0, $v0
   li $v0, 4
   la $a0, msg1         # afficher du message  
   syscall
   li $v0, 4
   la $a0, msg6         # afficher du message  w
   syscall
   li  $v0, 1           # afficher la valeur de retour
   add $a0, $t0, $0     # mettre la valeur de retour dans ;e registre $a0
   syscall
   addi $a0, $0, 0xA    # afficher une ligne vide
   addi $v0, $0, 0xB    # suite pour afficher une ligne vide
   syscall
  
  # Récursion d'un nombre saisie
   
   li $v0, 4
   la $a0, msg7         # Afficher le message demandant à l'utilisateur s'il veut faire une autre récursion
   syscall
 
   li $v0, 4
   la $a0, msg8        # Afficher Oui/Non 
   syscall

   li  $a1, 3
   li  $v0, 8
   syscall

   lb  $t4, 0($a0)

   beq $t4, 'o', recursion
   beq $t4, 'O', recursion    
   li $v0, 10          # Quitter le programme
   syscall
           
recursion:
   li $v0, 4
   la $a0, msg9        # Afficher message de saisie 
   syscall
   li $v0, 5           # Lecture du chiffre entré
   syscall
   
   addi $a1, $0, 0
   add $a0, $0, $v0    # Stocker l'arguement 0 dans $a0
   jal f               # Appel de f
  
   add $t0, $0, $v0
   li $v0, 4
   la $a0, msg10       # Affichage du message 
   syscall
   li  $v0, 1          # Afficher la valeur de retour
   add $a0, $t0, $0    # Mettre la valeur de retour dans ;e registre $a0
   syscall
   addi $a0, $0, 0xA   # Afficher une ligne vide
   addi $v0, $0, 0xB   # Suite pour afficher une ligne vide
   syscall
 
   li $v0, 10          # Quitter le programme
   syscall
           
   
f:
   addi $sp, $sp, -16 		        # make room
   sw $a2, 12($sp) 			# store $a0
   sw $a1, 8($sp) 			# store $ra
   sw $a0, 4($sp) 			# store $a0
   sw $ra, 0($sp) 			# store $ra 
   add $t0, $0, $a0                     # store $a0 in $t0
   div $a0, $t0, 2                      # divide $t0 by 2 and store result in $a0
   
   mul $a1, $t0, 2                      # (n * 2)	
   
   beq $a0 ,$0, return1                 # if $a0 = 0 return 1
                     
   jal f

done:   
   lw $ra, 0($sp) 			# store $ra
   lw $a0, 4($sp) 			# store  $a0
   lw $a1, 8($sp) 			# store  $a0
   lw $a2, 12($sp) 			# store  $a0
   addi $sp, $sp, 16 		        # make room
 
   add $t2, $a1, $v0                    # restore the result of recursion
   div $t3, $t2, 10    
   mfhi $v0                             # mod 10
   jr $ra                               # jump to parent call
   
return1:
   addi $v0, $0, 1                      # return 1
   add $v0, $v0, $a1                    # additionner le contenu de $a0 dans $v0
   b done                

