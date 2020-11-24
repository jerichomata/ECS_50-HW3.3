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

        # unsigned int i;
        # unsigned int best_value = cur_value;
        movl weights(%ebp), %ebx # weight
        movl values(%ebp), %ecx # values
        movl num_items(%ebp), %edx
        movl capacity(%ebp), %esi # cap esi
        movl cur_value(%ebp), %edi # cur_val edi 
        

        movl %edi, best_value(%ebp)

        movl $0, %ecx # i=0
       
        for_start:
            cmpl %edx, %ecx
            # cmpl %eax, %ecx # i-val
            jge for_end 

            movl capacity(%ebp), %esi # cap esi
            movl (%ebx, %edx, ws), %eax # weights[i]
            
            if1: # if(capacity - weights[i] >= 0 )
                # best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, 
                #      capacity - weights[i], cur_value + values[i]))

                cmpl %eax, %esi 
                jl end_else

                movl (%ecx, %ecx, ws) %ecx 
                movl cur_value(%ebp), %edi
                addl %eax, %edi
                push %edi # save cur_value

                movl weights(%ebp), %ebx
                leal ws(%ebx, %edx, ws), %ebx
                push %ebx

                movl values(%ebp), %ecx
                leal ws(%ecx, %edx, ws) %ecx
                push %ecx

                movl num_items(%ebp), %edx
                subl %ecx, %edx
                subl $1, %edx
                push %edx

                movl capacity(%ebp), %esi
                subl %eax, %esi
                push %esi

                call knapsack
                addl $5*ws, %esp
                
                push %edi
                push %esi 
                call max 
                addl $2*ws, %esp
                movl %edi, best_value(%ebp)


            end_else:
                incl %ecx # i++
                jmp for_start

    for_end:
        # epilogue:
            movl %ebp, %esp
            pop %ebp
            ret 
        
        
