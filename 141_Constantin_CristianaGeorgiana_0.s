.data
	nr_op: .long 0              #nr operatii
	nr_fisiere: .long 0         # nr fisiere
	op: .long 0                 #ce operatie e
	
	
	des: .long 0
	dim: .long 0

	
	bloc: .space 4096 
	
	formatscanf: .asciz "%d"
	formatadd: .asciz "%d: (%d, %d)\n" 
	formatnotadd: .asciz "nu exista spatiu suficient"
	
	formatget00: .asciz "(%d, %d)\n"
	
	
	#--------------------variabile pt add
	s: .long -1            #start
	f: .long -1            #final
	loc: .long 0           #de cate blocuri are nevoie descriptorul
	spatiu: .long 0       #spatiu de zerouri
	a: .long 0
	b: .long 0
	total: .long 0
	#deci total e o variabila in care tin minte cate blocuri sunt ocupate in total
	
	nr_de_op: .long 0
	
	#--------------------variabile pt afis
	start: .long 0
	final: .long 0
	nr: .long 0
	res: .long 0
	
	#--------------------variabile pt get
	s_get: .long -1
	f_get: .long -1
	des_get: .long 0
	
	#--------------------variabile pt delete
	des_del: .long 0
	
.text	
	
.global main


#-------------------------DEFRAGMENTATION--------------------------------
#------------------------------------------------------------------------

et_defrag:
		push %ecx
		
		xor %ecx , %ecx	      #i
		xor %edx , %edx       #j
		lea bloc , %esi	
		
while_1_defrag:
		cmpl $1024 , %ecx
		je et_restaurare_defrag
		
		
		
		#----------------------------esti in primul while
		
		movl (%esi ,%ecx , 4) , %eax
		
		cmpl $0 , %eax
		je if_1_defrag
		jmp et_incrementare
		



et_incrementare: 
		incl %ecx
		jmp while_1_defrag
				
				
if_1_defrag:		
		movl %ecx , %edx       #edx = ecx
		incl %edx              # edx + 1
		
		#------------esti in  while 2  
		
while_2_defrag:
		
		cmpl $1024 , %edx
		je if_2_defrag
		
		movl (%esi , %edx, 4) , %ebx    # ebx =bloc[j]
		
		cmpl $0 , %ebx
		jne if_2_defrag
		
		incl %edx
		jmp while_2_defrag
		
		
				
if_2_defrag:				
		cmpl $1024 , %edx
		je else_defrag
		
		#bloc[i] = bloc[j]
		#movl bloc[j] , bloc[i]
		#movl (%esi ,%ecx , 4) , %eax    # eax =bloc[i]
		#movl (%esi , %edx, 4) , %ebx    # ebx =bloc[j]
		
		movl %ebx , (%esi ,%ecx , 4)     #loc[i] = bloc[j]
		movl $0 ,  (%esi , %edx, 4)      #bloc[j] = 0
	
		jmp et_incrementare
	
	
else_defrag:
		#daca j depaseste vectorul 
		jmp et_incrementare

		
et_restaurare_defrag:
		#restaurare %ecx pentru for ul din main
		pop %ecx
	
		#inapoi in main
		jmp et_rest_op_main


#-------------------------DEFRAGMENTATION--------------------------------
#------------------------------------------------------------------------



#-------------------------DELETE--------------------------------
#---------------------------------------------------------------

et_delete:
		push %ecx
		
		#citire descriptor delete
		push %ecx
		pushl $des_del
		pushl $formatscanf
		call scanf
		addl $8 , %esp
		pop %ecx
		
		
		xor %ecx , %ecx
		lea bloc , %esi
		movl des_del , %ebx       #des_get = ebx
		
while_1_delete:	
		cmpl $1024 , %ecx
		je while_2_delete
		
		#sunt in while
		
		movl (%esi , %ecx , 4) , %eax    #bloc[i]=eax
		
		cmpl %eax , %ebx
		je while_2_delete
		
		incl %ecx
		jmp while_1_delete
		
		
while_2_delete:

		cmpl $1024 , %ecx
		je et_restaurare_delete
		
		
		movl (%esi , %ecx , 4) , %eax    #bloc[i]=eax
		cmpl %eax , %ebx
		jne et_restaurare_delete
		
		movl $0 , (%esi , %ecx , 4)
		#addl $-1 ,total
		subl $1 ,total
		
		incl %ecx
		jmp while_2_delete
		
			
		
et_restaurare_delete:
		#restaurare %ecx pentru for ul din main
		pop %ecx
	
		#inapoi in main
		jmp et_rest_op_main
		






#-------------------------DELETE--------------------------------
#---------------------------------------------------------------




#-------------------------GET--------------------------------
#------------------------------------------------------------

et_get:
		
		push %ecx
		
		#citire des_get
		
		push %ecx
		pushl $des_get
		pushl $formatscanf
		call scanf
		addl $8 , %esp
		pop %ecx
		
		
		
		lea bloc , %esi
		xor %ecx ,%ecx
		
		movl (%esi , %ecx ,4 ) , %eax     # eax = bloc[i]
		movl des_get , %ebx               # ebx = des_get
		
		movl $-1 , s_get
		movl $-1 , f_get
		
		
while_get:
		cmpl $1024 , %ecx
		je afis_get
		
		#-------esti in while
		movl (%esi , %ecx ,4 ) , %eax 
		cmpl %eax , %ebx       #bloc[i] cu des
		jne  et_else_get               #et_incl_get
		
		cmpl $-1 ,s_get
		jne et_continue_get
		movl %ecx , s_get
		
		
et_continue_get:
		movl %ecx ,f_get
		jmp et_incl_get          # et_else_get 
		
		
et_else_get:
		cmpl $-1 , s_get
		jne afis_get
		#jne et_afis_00
		
et_incl_get:
		incl %ecx
		jmp while_get
		
et_restaurare_get:	
		pop %ecx
		jmp et_decrementare_op_main
		
	
	
afis_get:

		cmpl $-1 ,s_get
		je et_afis_00
		
		movl %ebx , des_get 
		push %ecx
		push %ebx
		push %eax
		
		push f_get
		push s_get
		push $formatget00
		call printf
		addl $12, %esp
		
		pop %eax
		pop %ebx
		pop %ecx
		
		
		jmp et_restaurare_get
		
et_afis_00:
		
		
		movl $ 0 ,f_get
		movl $ 0 ,s_get
		push %ecx
		push %ebx
		push %eax 
		
		push f_get
		push s_get
		#push des_get
		push $formatget00
		call printf
		#addl $16, %esp
		addl $12 , %esp
		
		pop %eax
		pop %ebx
		pop %ecx
		
		jmp et_restaurare_get

#-------------------------GET--------------------------------
#------------------------------------------------------------


#-------------------------AFISARE----------------------------
#------------------------------------------------------------
afis:
		push %ecx
		#e ok restaurat
		
		movl $0, start
		movl $0, final
		
		#start= index start descriptor
		#final= index final descriptor
		
		lea bloc , %esi
		
		xor %ecx ,%ecx
#--------------------------------------------interior while
while_afis:
		#movl $0, start
		#movl $0, final



		cmpl $1024 , %ecx
		je et_restaurare
		
		jmp afis_interval
		
		
et_else:
		incl %ecx
		jmp while_afis
		
#--------------------------------------------interior while		
et_restaurare:	
		pop %ecx
		jmp et_decrementare_op_main


#---------------------------------ce se intampla in interior while

afis_interval:

		movl (%esi, %ecx ,4) , %eax    #eax =bloc[i]
		
		
		cmpl $0 , %eax                 #if bloc[i] == 0
		je et_else
		
	
		
		movl (%esi, %ecx ,4) , %ebx    # ebx  descriptor
		movl %ecx , start
		#caut final
		
while_2:
		cmpl $1024 , %ecx
		je   et_final            #et_exit      #et_final
		movl (%esi, %ecx ,4) , %eax 
		#else ecx < 1024
		
		cmpl  %eax , %ebx
		jne et_final
		
		
		incl %ecx
		jmp while_2
		
		
et_final:
		movl %ecx , final 
		decl final
		
		movl %ebx ,nr
		#afisare des
		push %ecx
		push %ebx
		push %eax 
		
		push final
		push start
		push nr
		push $formatadd
		call printf
		addl $16 , %esp
		
		pop %eax
		pop %ebx
		pop %ecx
		
		
		#cmpl $1023 ,final
		#je et_restaurare
		
		
		jmp while_afis


#-------------------------AFISARE----------------------------
#------------------------------------------------------------




#-------------------------ADD----------------------------
#--------------------------------------------------------




#------------------------et_add-------------------------
et_add:
	#ca sa pot sa folosesc %ecx aici
	push %ecx
	movl %ecx ,nr_de_op
	
	#----dati nr de fisiere care trebuie adaugate
	pushl $nr_fisiere
	pushl $formatscanf
	call scanf
	addl $8, %esp
	
	
	#while nr_fisiere > 0
	movl nr_fisiere, %ecx
	
while_fisiere:


	cmpl $0 , %ecx
	je et_back_to_main
	
	#----citire descriptor
	push %ecx
	pushl $des
	pushl $formatscanf
	call scanf
	addl $8 , %esp
	pop %ecx


	#----citire dimensiune
	push %ecx
	pushl $dim
	pushl $formatscanf
	call scanf
	addl $8 , %esp
	pop %ecx
	

	movl des, %edx
	cmpl $4 ,%edx
	je verif 
	jmp et_apel_add
verif:
	# int add (int des , int dim)
	jmp et_apel_add
	

et_decrementare_fisiere_et_add:

				movl nr_fisiere, %ecx
	
				decl %ecx
				
				movl %ecx , nr_fisiere
				jmp while_fisiere
	

	
	
et_back_to_main:
	
			#restaurare %ecx pentru for ul din main
			pop %ecx
			movl nr_de_op , %ecx
	
			#inapoi in main
			jmp et_rest_op_main
#------------------------et_add-------------------------
	
	
	
	
	
	
#-------------------------functia add din c------------------------------	
#aici e functia din c++  : add(des,dim)
et_apel_add:

		movl $-1 , f
		movl $-1 , s
		push %ecx
		movl %ecx ,res
		
		#--------------calcul blocuri necesare---------
		xor %edx , %edx
		movl dim , %eax           #eax =dim
		addl $7 , %eax            #eax = dim +7
		movl $8 , %ebx            #ebx = 7
		divl %ebx                 # eax= eax /8 , (dim+7)/8
		#----------------------------------------------

		movl %eax , loc  #de cate blocuri are nevoie des
		lea bloc , %esi   #bloc[i]=(%esi, %ecx, 4)
		
		movl $0 , spatiu
		

		addl %eax , total
		cmpl $1025 , total
		jge afis_00
		
		cmpl $1025 , %eax
		jge afis_00
		
		xor %edx , %edx
		xor %ebx , %ebx
		xor %eax , %eax
		xor %ecx, %ecx
		
		#momentan folosesc doar %ecx,%esi
		
		
		#--------------------------------------while i <1024----------
et_while_i_lower_1024:
		cmpl $1024 , %ecx
		jne et_cautare_loc         #1024 != i    cauta in continuarefvr
		
et_break:

		cmpl $-1 ,f 
		je con2
		jmp last
		
con2:
		cmpl $1024 , %ecx
		je con3
		jmp last
		
con3:
		cmpl $0 , s
		je last
		
		jmp afis_00
		
		
		

last:

		#jmp et_decrementare_fisiere_et_add     #1024 == i    completezi locul 
		
		jmp et_restaurare_ecx__et_apel_add
		
et_incl_ecx:
		incl %ecx

		jmp et_while_i_lower_1024
		
		#--------------------------------------while i <1024----------

		

et_restaurare_ecx__et_apel_add:
		
		pop %ecx
		movl res , %ecx
		jmp et_decrementare_fisiere_et_add
		
		
		
		

et_cautare_loc:
		
		movl (%esi ,%ecx , 4) , %eax      #eax =bloc[i]
		
		cmpl $0 , %eax                     # if bloc[i] == 0
		jne  et_else_bloc_not_zero      # else (bloc[i] != 0 )
		
		
		incl spatiu           #spatiu++
		cmpl $-1 , s          #daca start ==-1
		jne cond2
		movl %ecx , s         # s=i    ,start=ecx
		
		
cond2:      
		#if loc == spatiu
		movl spatiu , %ebx
		cmpl loc , %ebx
		jne  et_incl_ecx
		
		movl %ecx , f
		jmp et_completare_loc 
		
		
		
et_else_bloc_not_zero:
 				movl $0 , spatiu   #spatiu =0
 				movl $-1 ,s        #start = -1
 				movl $-1 ,f
 				jmp et_incl_ecx
 				

et_completare_loc:
			
			
			cmpl $-1 , f
			je afis_00
			jmp cond2_s
			
cond2_s:
			cmpl $-1 ,s
			je  afis_00

			#movl %ecx, s              #indicele de la care punem in vector des
			
			push %ecx
			
			incl f
			push %ebx
			push %eax
			#xor %ecx , %ecx
			
			movl s , %ecx

while_i_lower_f:
			cmpl %ecx , f             #while ecx <=f
			je afis_bun
			
			movl des , %ebx
			movl (%esi , %ecx , 4), %eax
			cmpl $0 , %eax
			jne et_treci_peste
			
			movl %ebx , (%esi , %ecx , 4)
			movl (%esi , %ecx , 4), %eax
et_treci_peste:
			incl %ecx
			jmp while_i_lower_f
          		
		

			
			
afis_bun:
			
			pop %eax
			pop %ebx
			pop %ecx
          		#dupa ce am completat cu des ma duc inapoi sa citesc umr des
          		pop %ecx
          		
          		
          		cmpl $1024 ,f 
          		je res_spatiu
          		jmp continua
res_spatiu:
			movl $0, spatiu
			
continua:
          		
          		decl f
          		push %eax
          		push %ebx
          		push %ecx
          		push %edx
          		
          		push f
          		push s
          		push des
          		push $formatadd
          		call printf
          		addl $16 , %esp
          		
          		
          		pop %edx
			pop %ecx
			pop %ebx
			pop %eax

          		
			jmp et_restaurare_ecx__et_apel_add
			#jmp et_decrementare_fisiere_et_add
			
afis_00:
			movl loc , %edx
			subl %edx , total
		
          		
			push %eax
          		push %ebx
          		push %ecx
          		push %edx
          		
          		push a
          		push b
          		push des
          		push $formatadd
          		call printf
          		addl $16 , %esp
          		
          		pop %edx
			pop %ecx
			pop %ebx
			pop %eax
          		
          		#pop %ecx
          		jmp et_restaurare_ecx__et_apel_add
			#jmp et_decrementare_fisiere_et_add
	
#-------------------------functia add din c------------------------------	




#-------------------------ADD----------------------------
#--------------------------------------------------------

   	


	
	
main:
	
	#----numarul total de operatii 
   	push $nr_op
   	push $formatscanf
   	call scanf
   	add $8 , %esp
   	
   	mov nr_op , %ecx
   	
   	
   	#movl s , %ebx
   	#movl f , %eax
   	
while_op:
   	#for (i=nr_op;i>0;i--) 
   	# daca mai sunt operatii de facut
   	
   	
   	cmp $0 , %ecx
   	je et_exit
   	
   
   	#----care e tipul op (ADD,GET,DELETE,DEFRAG)
   	push %ecx
   	push $op
   	push $formatscanf
   	call scanf
   	add $8 , %esp
   	pop %ecx
   	

	
   	
   	cmpl $1 , op
   	je et_add
   	
   	
   	cmpl $2 , op 
   	je et_get
   	
   	
   	cmpl $3 , op
   	je et_delete
   	
   	cmpl $4 , op
   	je et_defrag
   	

et_rest_op_main:
   	#cmpl $1 , op
   	#je  afis
   	
   	cmpl $3 , op
   	je afis
   	
   	cmpl $4 , op
   	je afis
   	
   	
   	
et_decrementare_op_main:
	movl nr_op , %ecx
   	decl %ecx
   	movl %ecx , nr_op
   	jmp while_op
   	
 
	
 	
et_exit:
    pushl $0
    call fflush
    popl %eax
    
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
		
