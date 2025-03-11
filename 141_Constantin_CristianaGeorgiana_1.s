.data
	nr_op: .long 0              #nr operatii
	nr_fisiere: .long 0         # nr fisiere
	op: .long 0                 #ce operatie e
	
	ok:.long 0
	var: .long 0
	des: .long 0
	dim: .long 0

	
	bloc: .space 4194304  # 1024 *1024 * 4
	#n: .space 1048576
	n: .space 1024
	
	#--------------------variabile pt add
	
	loc: .long 0           #de cate blocuri are nevoie descriptorul
	
	a: .long 0
	b: .long 0
	c: .long 0
	d: .long 0
	i: .long 0
	j: .long 0
	
	v: .long 0
	
	nr_de_op: .long 0
	
	canAllocate: .long 0
	foundspace: .long 0
	
	startX: .long 0
	startY: .long 0
	endX: .long 0
	endY: .long 0
	
	row: .long 0
	col: .long 0
	
	save_eax: .long 0
	save_ebx: .long 0
	save_ecx: .long 0
	save_edx: .long 0
	
	#--------------------variabile pt afis
	
	res: .long 0
	endd: .long 0
	start: .long 0
	
	#--------------------variabile pt get
	
	startRow: .long 0
	startCol: .long 0
	endRow: .long 0
	endCol: .long 0
	
	index: .long 0
	
	
	des_get: .long 0
	
	#--------------------variabile pt delete
	des_del: .long 0



	formatscanf: .asciz "%d"
	formatadd: .asciz "%d: ((%d, %d), (%d, %d))\n"
	
	
	formatget: .asciz "((%d, %d), (%d, %d))\n"
	
	
.text	
	
.global main


#-------------------------GET--------------------------------
#------------------------------------------------------------

et_get:
		
		movl %ecx ,nr_de_op
		
		
		movl $-1 ,startRow
		movl $-1 ,startCol
		movl $-1 ,endRow
		movl $-1 ,endCol
		
		movl $0 , i
		movl $0 ,j
		
		
	
		#citire des_get
		
		push %ecx
		pushl $des
		pushl $formatscanf
		call scanf
		addl $8 , %esp
		pop %ecx
		
		
		movl $0 ,i 
while_i_get:
		cmpl $1024, i
		jge afis_get
		
		
		movl $0 ,j
while_j_get:
		
		cmpl $1024 , j 
		jge incl_i_get
		
		
		cmpl $1023 , i
		je et
		jmp next
		
et:
                movl $0 ,ok
next:
		
		
		xor %edx, %edx
		movl $1024 , %eax     # eax =1024
		mull i		      # eax =i*1024
		addl j , %eax         # eax =i*1024 +j 
		
		lea bloc, %esi
		
		movl (%esi , %eax , 4) , %edx
		
#------------------if (bloc[index] == des)-----------------------------
		cmpl %edx ,des 
		jne else_if_get
		
		
		#     prima aparitie
		
		cmpl $-1 , startRow
		jne actualizez_sfarsit
		
		movl i , %ecx
		movl %ecx , startRow
		movl j , %ecx
		movl %ecx , startCol
		
actualizez_sfarsit:
		movl i , %ecx
		movl %ecx , endRow
		movl j , %ecx
		movl %ecx , endCol
		
		jmp incl_j_get
		
#------------------else      (bloc[index] != des)-----------------------------		

else_if_get:
		# if stratRow != -1 
		cmpl $-1 , startRow
		je incl_j_get
		
		jmp afis_get
		
				
			

incl_i_get:
		

		incl i
		jmp while_i_get
		
incl_j_get:
		incl j
		jmp while_j_get

		
	
afis_get:

		cmpl $-1 , startRow
		je else_afis_get
		
		push %eax
    		push %ebx
    		push %ecx
   		push %edx
   		
   		push endCol
  		push endRow
  		push startCol
  		push startRow 
  		push $formatget
   		call printf
   		addl $20 , %esp
   		
    		pop %edx
   		pop %ecx
    		pop %ebx
    		pop %eax
    
		jmp et_restaurare_get
		
		
else_afis_get:
		push %eax
    		push %ebx
    		push %ecx
   		push %edx
   		
  		push d
  		push d
  		push d
  		push d
  		push $formatget
   		call printf
   		addl $20 , %esp
   		
    		pop %edx
   		pop %ecx
    		pop %ebx
    		pop %eax
    
	
		jmp et_restaurare_get
		
		
et_restaurare_get:	
		movl nr_de_op , %ecx
		jmp et_decrementare_op_main
#-------------------------GET--------------------------------
#------------------------------------------------------------



#-------------------------DELETE--------------------------------
#---------------------------------------------------------------

et_delete:
		#push %ecx
		movl %ecx , var
		
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
		#cmpl $1024 , %ecx
		
		cmpl $1048576  , %ecx
		je while_2_delete
		
		#sunt in while
		
		movl (%esi , %ecx , 4) , %eax    #bloc[i]=eax
		
		cmpl %eax , %ebx
		je while_2_delete
		
		incl %ecx
		jmp while_1_delete
		
		
while_2_delete:

		cmpl $1048576 , %ecx
		je et_restaurare_delete
		
		
		movl (%esi , %ecx , 4) , %eax    #bloc[i]=eax
		cmpl %eax , %ebx
		jne et_restaurare_delete
		
		movl $0 , (%esi , %ecx , 4)
		#addl $-1 ,total
		#subl $1 ,total
		
		incl %ecx
		jmp while_2_delete
		
			
		
et_restaurare_delete:
		#restaurare %ecx pentru for ul din main
		movl var , %ecx
		#pop %ecx
	
		#inapoi in main
		jmp et_rest_op_main
		






#-------------------------DELETE--------------------------------
#---------------------------------------------------------------

		
		
#-------------------------ADD----------------------------
#--------------------------------------------------------




#------------------------et_add-------------------------
et_add:
	
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
	

	

	# int add (int des , int dim)
	jmp et_apel_add
	

et_decrementare_fisiere_et_add:

				movl nr_fisiere, %ecx
	
				decl %ecx
				
				movl %ecx , nr_fisiere
				jmp while_fisiere
	

	
	
et_back_to_main:
	
			movl nr_de_op , %ecx
	
			#inapoi in main
			#jmp et_rest_op_main
			jmp et_decrementare_op_main
#------------------------et_add-------------------------
	
	
	
	
	
	
#-------------------------functia add din c------------------------------	
#aici e functia din c++  : add(des,dim)

et_apel_add:
		movl $0 ,foundspace
		movl $0 ,canAllocate
		
		
		xor %edx , %edx
		movl %edx , startX
		movl %edx , startY
		movl %edx , endX 
		movl %edx , endY
		
		movl $0 ,row
		movl $0 ,col
		
	
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
		
		xor %ecx , %ecx
		
		movl des , %edx
		cmpl $7, %edx
		je et_7
		jmp while_row
et_7:		

      

		movl $0 ,row
while_row:
		cmpl $1024 , row
		je afis_00
		
		movl $0 ,col
while_col:
		movl $1024 ,%ebx       # ebx =1024
		subl loc , %ebx     # ebx =1024-loc
		
		cmpl %ebx , col
		jg incl_row
		
		
		
		movl $1 , canAllocate
		
		#verific spatiul liber pe rand
		
		movl $0 ,j
		movl loc, %ecx
		
while_j_lower_loc:
		cmpl %ecx , j
		jge if_canAllocate
		
		lea bloc , %esi
		xor %edx , %edx
		movl $1024 , %eax        # eax = 1024
		mull row              # eax =row*1024
		addl col , %eax       # eax =row*1024 + col
		addl j   , %eax       # eax =row*1024 + col + j
		
verif:		
		movl (%esi , %eax , 4) , %edx
		
		
		
		cmpl $0 , %edx       # if bloc[row*1024 + col + j] != 0
		je incl_j
		
		movl $0 ,canAllocate
		jmp if_canAllocate
		
		
incl_j:
		incl j
		jmp while_j_lower_loc


#----------------------- if(canAllocate != 0) ------------------------------
if_canAllocate:	
		cmpl $0 ,canAllocate
		je incl_col
		
		#aloc blocurile pe acest rand
		
		movl $0 ,j
		
		
		movl loc, %ecx	
	
while_alocare_blocuri:
		
		cmpl %ecx , j
		jge calcul_coordonate
		
		lea bloc , %esi
		xor %edx , %edx
		movl $1024 , %eax       # eax =row
		mull  row              # eax =row*1024
		addl col , %eax       # eax =row*1024 + col
		addl j   , %eax       # eax =row*1024 + col + j
		
		
		lea bloc , %esi
		
		movl %ebx , save_ebx
		
	
aloc:
	
		movl des , %ebx
		movl %ebx , (%esi , %eax , 4)   # bloc [] = des
		
		movl save_ebx , %ebx
		
		incl j
		jmp while_alocare_blocuri

calcul_coordonate:
		
		
		
		movl row , %edx
		movl %edx , startX
		
		movl col , %edx
		movl %edx , startY
		
		movl row , %edx
		movl %edx , endX 
		
		
		
		movl col , %edx
		addl loc , %edx
		subl $1 , %edx
		
		movl %edx , endY
		
		
afis_bun:
		push %eax
    		push %ebx
    		push %ebx
    		push %ecx
   		push %edx
   		push endY
  		push endX
  		push startY
  		push startX 
  		push des
  		push $formatadd
   		call printf
   		addl $24 , %esp
    		pop %edx
   		pop %ecx
    		pop %ebx
    		pop %eax
    
    
    		movl $1 ,foundspace
    		
		jmp et_decrementare_fisiere_et_add
		
		
		
		
		
		
		
		
		
		
		
#----------------------- if(canAllocate != 0) ------------------------------		
		
incl_col:
		incl col
		jmp while_col
		
incl_row:
		incl row
		jmp while_row
		
		
		
		
		
afis_00:	

		cmpl $0 , foundspace
		je afis_0000
		jmp et_decrementare_fisiere_et_add
		
afis_0000:
		push %eax
    		push %ebx
    		push %ebx
    		push %ecx
   		push %edx
   		push d
  		push d
  		push d
  		push d 
  		push des
  		push $formatadd
   		call printf
   		addl $24 , %esp
    		pop %edx
   		pop %ecx
    		pop %ebx
    		pop %eax
    
		jmp et_decrementare_fisiere_et_add

et_restaurare_ecx__et_apel_add:
		
		
		movl res , %ecx
		jmp et_decrementare_fisiere_et_add
		
		

		
#-------------------------functia add din c------------------------------	




#-------------------------ADD----------------------------
#--------------------------------------------------------



#-------------------------AFISARE----------------------------
#------------------------------------------------------------
afis:
		movl %ecx , res
		
		movl $0 ,i 
		movl $0 ,j 
		movl $0 ,endd
		movl $0 ,start
		movl $0 ,des
		
		
		
		
et_while_i:

		cmpl $1024 , i 
		jge et_restaurare_afis
		
		movl $0 ,endd
		movl $0 ,start
		movl $0 ,des
		
		#------------- esti in while 1-----------
		
		movl $0 ,j
		
		
		
			#------------ esti in while 2 ------------
			
while_j_1:		

			cmpl $1024  , j
			jge incl_while_i
		
			xor %edx, %edx
			xor %eax , %eax
			movl $1024 , %eax     # eax =1024
			mull i		      # eax =i*1024
			addl j , %eax         # eax =i*1024 +j 
			
			lea bloc, %esi
			
			movl (%esi , %eax , 4) , %edx
		
			# deci in edx = bloc [i *1024 + j ]
			
			cmpl $0 , %edx
			je else_if_afis
			
			
			#---------- aici sunt in primul if--------------------
			
			
			movl %edx , des            # des = bloc [i *1024 + j ]
			
			movl j , %eax
			
			movl %eax , start          # start = j
			
			
				#---------- al doilea while j < 1024 ---------
				
while2_j_lower_1024:
				cmpl $1024  , j
				jge afis_interval
				
				xor %edx, %edx
				movl $1024  , %eax     # eax =1024
				mull i		      # eax =i*1024
				addl j , %eax         # eax =i*1024 +j 
			
				lea bloc, %esi
			
				movl (%esi , %eax , 4) , %edx
		
				# deci in edx = bloc [i *1024 + j ]
				
				cmpl des , %edx
				jne afis_interval
				
				incl j
				jmp while2_j_lower_1024
				
				
			
			
			
			
afis_interval:


		
			
			
			movl j, %ebx
			movl %ebx , endd      #endd =j
			subl $1 ,endd      # endd = j -1
			
			push %eax
    			push %ebx
    			push %ecx
   			push %edx
   			
   			push endd
  			push i
  			push start
  			push i
  			push des
  			push $formatadd
   			call printf
   			addl $24 , %esp
   			
    			pop %edx
   			pop %ecx
    			pop %ebx
    			pop %eax
			
    
    			decl j
    			cmpl $8 ,j 
    			je incl_while_i
    
			#incl j
			#jmp while_j_1
			#jmp incl_while_i
			
			
			
			
		
else_if_afis:
 		
 		incl j
 		jmp while_j_1
		
incl_while_i:

		movl $0 ,endd
		movl $0 ,start
		movl $0 ,des
		incl i
		jmp et_while_i
	
et_restaurare_afis:	
		movl res , %ecx
		jmp et_decrementare_op_main


#-------------------------AFISARE----------------------------
#------------------------------------------------------------

	
	
main:
	
	#----numarul total de operatii 
   	push $nr_op
   	push $formatscanf
   	call scanf
   	add $8 , %esp
   	
   	mov nr_op , %ecx
   	
   	
   	
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
   	
   	

et_rest_op_main:
   	
   	cmpl $3 , op
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
		
