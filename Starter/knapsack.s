.global knapsack
.equ ws, 4

.text 

max:
    # prologue:
        push %ebp
        movl %esp, %ebp
        subl $2 *ws, %esp

        # int max(unsigned int a, unsigned int b)
        .equ a, 2*ws
        .equ b, 3*ws

    movl a(%ebp), %eax
    movl b(%ebp), %ecx
    if_max: 
        cmpl %eax, %ecx
        jl else_max 
        movl a(%ebp), %eax 
        jmp if_max_end
        
    else_max:
        movl b(%ebp), %eax

    if_max_end:
        # epilogue:
            movl %ebp, %esp
	        pop %ebp
	        ret

knapsack:
    # prologue:
        push %ebp
        movl %esp, %ebp
        # unsigned int knapsack(int* weights, unsigned int* values, unsigned int num_items, 
        #        int capacity, unsigned int cur_value)
        subl $5 *ws, %esp

        .equ weights, 2*ws # (%ebp)
        .equ values, 3*ws 
        .equ num_items, 4*ws 
        .equ capacity, 5*ws 
        .equ cur_value, 6*ws 

        .equ best_value, -1*ws 
        
        push %ebx
        push %esi
        push %edi

        # unsigned int i;
        movl capacity(%ebp), %esi # cap esi        
        movl cur_value(%ebp), %edi # cur_val edi
        movl %edi, best_value(%ebp)
        movl $0, %ecx # i=0

        push %esi
       
        for_start:
            movl num_items(%ebp), %edx
            cmpl %edx, %ecx
            # cmpl %eax, %ecx # i-val
            jge for_end 
            
            movl weights(%ebp), %ebx # weights
            movl (%ebx, %ecx, ws), %eax # weights[i]
            

            if1: # if(capacity - weights[i] >= 0 )
                # best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, 
                #      capacity - weights[i], cur_value + values[i]))

                cmpl %eax, %esi 
                jl end_else

                movl (%esi, %ecx, 4),  %esi 

                movl cur_value(%ebp), %edi
                addl %eax, %edi
                push %edi # save cur_value

                movl weights(%ebp), %esi
                leal ws(%esi, %edx, ws), %esi
                push %esi 

                movl values(%ebp), %ebx
                leal ws(%ebx, %edx, ws), %ebx
                push %ebx

                movl num_items(%ebp), %edx
                subl %ecx, %edx
                subl $1, %edx
                push %edx

                movl capacity(%ebp), %esi
                subl %eax, %esi
                push %esi

                movl %ecx, i(%ebp)
                call knapsack
                addl $5*ws, %esp
                
                push %edi
                push %esi 
                call max 
                addl $2*ws, %esp

                movl %edi, best_value(%ebp)
                movl %ecx, i(%ebp)			

            end_else:
                incl %ecx # i++
                jmp for_start

    for_end:
        # epilogue:


            pop %ebx
            pop %esi
            pop %edi

            movl %ebp, %esp
            pop %ebp
            ret 
        
        
