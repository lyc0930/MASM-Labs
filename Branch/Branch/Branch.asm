; Input < Keyborad -> N, 0 < N < 10
; 1 .. N^2 -> 2*2 Array
; Output < lower triangle of Array

INCLUDE Irvine32.inc ; 引用Kip Irvine教授的库
INCLUDE macros.inc   ; 引用Macros库

BufferSize = 300

.data
ReadBuffer      DB  3 DUP(?)
Buffer          DB  BufferSize DUP(?)
StdInHandle     DD  ?
BytesRead       DD  ?
StdOutHandle    DD  ?
BytesWritten    DD  ?
Space           DB  " ", 0
Return          DB  0AH, 0
.code
main PROC
	INVOKE GetStdHandle, STD_INPUT_HANDLE   ; 获取标准输入句柄
	MOV	StdInHandle,eax
	INVOKE ReadConsole,                     ; 从控制台输入
        StdInHandle,
        ADDR ReadBuffer,
        01H,
        ADDR BytesRead,
        0
	MOV	ecx, OFFSET ReadBuffer				; ecx <- 输入数字
	MOVZX ecx, BYTE PTR [ecx]				; 用MOVZX保证覆盖
	SUB ecx, 30H							; 外层循环计数
	MOV eax, ecx
	MUL ecx                                 ; 自乘
	MOV ecx, eax
	MOV esi, OFFSET Buffer					; 偏移地址
	MOV ebx, 01H							; 数字
SaveToArray:								; 存入n^2的数组
	MOV [esi], ebx
	ADD esi, TYPE Buffer					; esi自增
	INC ebx
	LOOP SaveToArray
	MOV	ecx, OFFSET ReadBuffer				; ecx <- 输入数字
	MOVZX ecx, BYTE PTR [ecx]
	SUB ecx, 30H
	MOV ebx, ecx							; ebx <- ecx
	MOV esi, OFFSET Buffer					; esi <- Buffer的地址
Column:
	MOV edx, ecx							; edx <- 外层循环数
	PUSH ecx								; 压栈外层循环数ecx
	MOV ecx, ebx							; 内层循环次数 <- ebx
Row:
	CMP ecx, edx
	JB Skip									; 内层循环 > 外层循环
	MOVZX eax, BYTE PTR [esi]
	call WriteDec
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE	; 获取标准输出句柄
    MOV StdOutHandle, eax
    PUSHAD
    INVOKE WriteConsole,                    ; 向控制台输出空格
        StdOutHandle,
        ADDR Space,
        1,
        OFFSET BytesWritten,
        0
	POPAD
Skip:
	ADD esi, TYPE Buffer					; esi自增
	LOOP Row
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE	; 获取标准输出句柄
    MOV StdOutHandle, eax
    PUSHAD
    INVOKE WriteConsole,                    ; 向控制台输出回车
        StdOutHandle,
        ADDR Return,
        1,
        OFFSET BytesWritten,
        0
	POPAD
	POP ecx									; 出栈外层循环数ecx
	LOOP Column
	INVOKE ExitProcess, 0
main ENDP
END main