INCLUDE Irvine32.inc
INCLUDE macros.inc

BufferSize = 200

.data
Buffer      BYTE    BufferSize DUP(?)
StdInHandle HANDLE  ?
OperatorStack    BYTE    BufferSize DUP(?)
OperatorStackBase   DD      ?
BytesRead   DWORD 	?
Plus        DB      "+", 0
Minus       DB      "-", 0
LeftComma   DB      "(", 0
RightComma  DB      ")", 0

.code
main PROC
	INVOKE GetStdHandle, STD_INPUT_HANDLE 		; 获取标准输入句柄
	MOV	StdInHandle, eax
	INVOKE ReadConsole,                         ; 从控制台输入
		StdInHandle,
		ADDR Buffer,                            ; Buffer <- String
	  	BufferSize,
		ADDR BytesRead,
		0
	MOV ecx, BytesRead                          ; 保存总串长
    SUB ecx, 2                                  ; 注意多余的两个字符
	MOV al, 0                                   ; 0 <- Character | 1 <- Number
	MOV ah, 0                                   ; 0 <- Minus | 1 <- Negative
	MOV bl, 0                                   ; 0 <- Positive | 1 <- Negative
	MOV edi, OFFSET OperatorStack
	MOV esi, OFFSET OperatorStackBase
	MOV [esi], edi
	MOV esi, OFFSET Buffer

	.WHILE (ecx > 0)
		MOV bh, BYTE PTR [esi]
		.IF (bh == Minus)                       ; 当前字符 '-'
			.IF (ah == 0)                       ; 减号
				.IF (al == 1 && bl == 1)        ; 是数字，是负数
					MOV edx, eax
					POP eax
					NEG eax                     ; 取负
					PUSH eax
					MOV eax, edx
				.ENDIF
				MOV edx, OFFSET OperatorStackBase
				MOV edx, [edx]
				.IF (edx != edi)                ; 栈顶不等于栈底
                    MOV dl, [edi]               ; dl <- 栈顶
					.IF (dl == Plus)
						POP edx
						ADD [esp], edx          ; 计算数字，入栈
						DEC edi                 ; 栈顶指针下移
					.ELSEIF (dl == Minus)
						POP edx
						SUB [esp], edx          ; 计算数字，入栈
						DEC edi                 ; 栈顶指针下移
					.ENDIF
				.ENDIF
				inc edi                         ; 符号入栈
				MOV [edi], BYTE PTR 2DH         ; '-'
                MOV al, 0                       ; Character
				MOV ah, 1                       ; Minus
				MOV bl, 0                       ; Positive
			.ELSE                               ; 负号
				MOV al, 0                       ; Character
                MOV ah, 0                       ; Negative
                MOV bl, 1                       ; Negative
			.ENDIF
		.ELSEIF (bh == Plus)                    ; 当前字符 '+'
			.IF (al == 1 && bl == 1)            ; 是数字，是负数
				MOV edx, eax
				POP eax
				NEG eax                         ; 取负
				PUSH eax
				MOV eax, edx
			.ENDIF
			MOV edx, OFFSET OperatorStackBase
			MOV edx, [edx]
			.IF (edx != edi)                    ; 栈顶不等于栈底
				MOV dl, [edi]                   ; dl <- 栈顶
				.IF (dl == Plus)
					POP edx
					ADD [esp], edx              ; 计算数字，入栈
					DEC edi                     ; 栈顶指针下移
				.ELSEIF (dl == Minus)
					POP edx
					SUB [esp], edx              ; 计算数字，入栈
					DEC edi                     ; 栈顶指针下移
				.ENDIF
			.ENDIF
			inc edi                             ; 符号入栈
			MOV [edi], BYTE PTR 2BH             ; '+'
            MOV al, 0                           ; Character
            MOV ah, 1                           ; Minus
			MOV bl, 0                           ; Positive
		.ELSEIF (bh == LeftComma)
			INC edi
			MOV [edi], BYTE PTR 28H             ; '('
            MOV al, 0                           ; Character
			MOV bl, 0                           ; Negative
			MOV ah, 1                           ; Negative
		.ELSEIF (bh == RightComma)
			.IF (al == 1 && bl == 1)             ; 是数字，是负数
				MOV edx, eax
				POP eax
				NEG eax                         ; 取负
				PUSH eax
				MOV eax, edx
			.ENDIF
			.WHILE 1 LT 2                       ; 循环计算
				MOV bh, [edi]                   ; bh <- 符号栈顶
				.IF (bh == LeftComma)           ; 出栈
					DEC edi                     ; 移动栈顶指针
					.BREAK
				.ELSE
					DEC edi                     ; 移动栈顶指针
					POP edx                     ; 数字出栈
					.IF (bh == Plus)
						ADD [esp], edx
					.ELSEIF(bh == Minus)
						SUB [esp], edx
					.ENDIF
				.ENDIF
			.ENDW
		.ELSE
			.IF (al == 0)                       ; 符号
				MOVZX edx, BYTE PTR [esi]
				SUB edx, 30H                    ; Char -> Number
				PUSH edx                        ; 数字压栈
			.ELSE                               ; 数字
				MOV edx, eax
				POP eax
				PUSH ecx
				MOV ecx, 10
				MUL ecx                         ; al *= 10
				POP ecx
				ADD al, BYTE PTR [esi]          ; eax += 栈顶数字
                SUB eax, 30H                    ; eax -= 48
				PUSH eax                        ; 入栈
				MOV eax, edx
			.ENDIF
			MOV al, 1                           ; Number
			MOV ah, 0                           ; Minus
		.ENDIF
		inc esi                                 ; esi++
		dec ecx                                 ; ecx--
	.ENDW
	MOV edx, OFFSET OperatorStackBase
	MOV edx, [edx]
	.WHILE (edi > edx)                           ; 直至栈空
		MOV al, [edi]
		POP ebx
		.IF (al == Plus)
			ADD [esp], ebx
		.ELSE
			SUB [esp], ebx
		.ENDIF
		DEC edi
	.ENDW
	MOV eax, [esp]
	CALL WriteInt
	INVOKE ExitProcess, 0
main ENDP
END main
