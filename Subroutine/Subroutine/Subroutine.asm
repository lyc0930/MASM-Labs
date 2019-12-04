INCLUDE Irvine32.inc

Digit = 20

.data

Number DD Digit DUP(0)

.code
main PROC
	MOV esi, OFFSET Number
	ADD esi, (Digit - 1) * TYPE Number
	MOV edi, [esi]
	MOV edi, 1
	MOV [esi], edi			            ; Number[19] <- 1
	CALL ReadInt			            ; eax <- Standard input < 32-bit signed decimal integer
	CALL Recursion
	MOV esi, OFFSET Number	            ; esi <- 高精度数字首地址
	MOV ecx, Digit			            ; 按最大位数循环
Zero_Q:
	MOV eax, [esi]                      ; eax <- Number[i]
	CMP eax, 0
	JZ Strip				            ; 跳过前导0
Print:
	MOV eax, [esi]			            ; eax <- Number[i]
	CALL WriteDec                       ; eax -> Standard output
    ADD esi, TYPE Number	            ; i++
	LOOP Print
	INVOKE ExitProcess, 0
Strip:
	ADD esi, TYPE Number	            ; i++
	LOOP Zero_Q
	INVOKE ExitProcess, 0
	main ENDP

;--------------------------------------------------------
Recursion PROC
; 计算n的阶乘n!，将结果以高精度形式存入数组Number
; @Receives: eax = n
; @Returns: Number = n! (in digits)
;--------------------------------------------------------
	PUSH eax				            ; 入栈
	DEC eax 				            ; eax--
	CMP eax, 0
	JZ Base			                    ; Base case: eax = 0 递归结束
	CALL Recursion                      ; 计算(n-1)!
Base:
	POP eax					            ; 出栈
	MOV ecx, Digit                      ; i = 20
	MOV esi, OFFSET Number
	ADD esi, (Digit - 1) * TYPE Number  ; esi <- &Number[19]
Multiplication:						    ; Number *= eax
	PUSH ecx
	PUSH eax
	MOV ecx, [esi]                      ; ecx <- Number[i]
	MUL ecx                             ; eax *= ecx
	MOV [esi], eax                      ; Number[i] = eax = eax * Number[i]
	SUB esi, TYPE Number                ; esi--
	POP eax
	POP ecx
	LOOP Multiplication
	MOV ecx, (Digit - 1)                ; i = 19
	MOV esi, OFFSET Number
	ADD esi, (Digit - 1) * TYPE Number  ; esi <- &Number[19]
Carry:					                ; Number[i + 1] <- Number[i] / 10, Number[i] %= 10
	MOV eax, [esi]                      ; eax <- Number[i]
	MOV edx, 0
	MOV ebx, 0AH                        ; ebx <- 10
	DIV ebx                             ; eax /= ebx = Number[i] / 10
	MOV [esi], edx                      ; Number[i] = edx = Number[i] % 10
	SUB esi, TYPE Number                ; esi--
	ADD [esi], eax                      ; Number[i - 1] += eax = Number[i] / 10
	LOOP Carry
	RET
	Recursion ENDP

END main
