INCLUDE Irvine32.inc
INCLUDE macros.inc

BufferSize = 300
ArraySize = 100

.data
Buffer 			BYTE 	BufferSize DUP(?)
Infile  		BYTE 	"D:\private\File\课程相关\微机原理与系统\Experiment\MASM-Labs\Sort\Input3.txt", 0
FileHandle  	DD 		?
StdOutHandle 	DD 		?
ErrorMessage 	BYTE 	"error", 0
BytesRead 		DD 		?
BytesWritten 	DD 		?
Array 			DD 		ArraySize DUP(?)
Number 			DD 		?
Space 			DB 		" ", 0
Minus 			DB		"-", 0

.code
main PROC
	PUSH eax
	INVOKE CreateFile,							; 打开infile文件
		ADDR Infile,
		GENERIC_READ,							; 读模式
		DO_NOT_SHARE,							; 不开放共享
		NULL,
		OPEN_EXISTING,							; 打开现有文件
		FILE_ATTRIBUTE_NORMAL,
		0
	MOV FileHandle, eax							; 保留文件句柄
	cmp eax, INVALID_HANDLE_VALUE				; 判断文件句柄是否合法
	JZ Error									; 跳转报错
	INVOKE ReadFile,							; 读文件
		fileHandle,
		OFFSET Buffer,
		BufferSize,
		ADDR BytesRead,							; 实际读字节数
		0
	MOV ecx, BytesRead							; ecx <- 字节数
	MOV esi, OFFSET Buffer						; esi <- Buffer 首地址
	MOV ebx, 0									; ebx <- 0
	MOV edx, 0									; edx <- 0 (Positive)
	MOV edi, OFFSET Number						; edi <- 全局变量地址：数字总数
	MOV [edi], edx								; Number <- edx(0)
	MOV edi, OFFSET Array						; 数组位置

GetChar:										; 循环读入字符
	CMP BYTE PTR [esi], 20H						; ' '
	JNE Negative_Q								; 如果不是空格，判断是否是负号
	CALL AssignToArray
	JMP LoopGetChar
Negative_Q:
	CMP BYTE PTR [esi], 2DH						; '-'
	JNE Count									; 如果不是负号，直接计数
	MOV edx, 1									; edx <- 1 (Negative)
	JMP LoopGetChar
Count:											; ebx <- ebx * 10 + [esi] - ‘0’
	PUSH edx									; 保护符号位
	MUL ebx										; eax(10) *= ebx
	MOV ebx, eax								; ebx <- eax
	MOVZX eax, BYTE PTR [esi]					; eax <- [esi]
	ADD ebx, eax								; ebx += [esi]
	SUB ebx, 30H								; ebx -= '0'
	MOV eax, 10									; eax <- 10
	POP edx
LoopGetChar:
	INC esi										; 循环增量
	LOOP GetChar
	CALL AssignToArray

	MOV ecx, OFFSET Number
	MOV ecx, [ecx]
	SUB ecx, 1									; i = Number - 1
	MOV esi, OFFSET Array						; esi <- 数组地址
Loop_I:
	PUSH ecx									; 保护外层循环
	PUSH esi
Loop_J:											; j = esi
	MOV edi, [esi + 4]							; edi <- [esi + 4]
	CMP [esi], edi
	JS Ordered									; [esi] < [esi + 4] 有序
	CALL Swap									; [esi] >= [esi + 4]
Ordered:
	ADD esi, TYPE Array							; j++
	LOOP Loop_J
	POP esi										; j = 0
	POP ecx
	LOOP Loop_I

	MOV esi, OFFSET Array						; esi <- 数组地址
	MOV ecx, OFFSET Number
	MOV ecx, [ecx]
Loop_Print:
	MOV eax, [esi]								; eax <- [esi]
	ADD eax, 0
	JNS Print									; S = 0 (Positive)
	PUSH eax
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE		; 获取标准输出句柄
    MOV StdOutHandle, eax
    PUSHAD
    INVOKE WriteConsole,                    	; 向控制台输出‘-’
        StdOutHandle,
        ADDR Minus,
        1,
        OFFSET BytesWritten,
        0
	POPAD
	POP eax
	NEG eax										; eax = -eax (Neg -> Pos)
Print:
	CALL WriteDec
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE		; 获取标准输出句柄
    MOV StdOutHandle, eax
    PUSHAD
    INVOKE WriteConsole,                    	; 向控制台输出空格
        StdOutHandle,
        ADDR Space,
        1,
        OFFSET BytesWritten,
        0
	POPAD
	ADD esi, TYPE Array							; i++
	LOOP Loop_Print
	INVOKE ExitProcess, 0
main ENDP

;--------------------------------------------------------
AssignToArray proc
; 将以edx为标志位，以ebx为数值的数据存入数组Array
; @Receives: edx = sign (1: negative), ebx = unsigned number, edi = OFFSET Array
; @Returns: none
;--------------------------------------------------------
	CMP edx, 1
	JNE Assign
	NEG ebx										; 负数取反
Assign:
	MOV [edi], ebx								; *edi <- ebx
	ADD edi, TYPE Array							; edi++
	MOV ebx, OFFSET Number
	MOV edx, 1
	ADD [ebx], edx								; *ebx++
	MOV ebx, 0									; ebx <- 0
	MOV edx, 0									; edx <- 0 (Positive)
	RET
AssignToArray ENDP

;--------------------------------------------------------
Swap proc
; 交换[esi]与[esi + 4]
; @Receives: [esi], [esi + 4]
; @Returns: none
;--------------------------------------------------------
	MOV eax, [esi]
	MOV ebx, [esi + 4]
	MOV [esi], ebx
	MOV [esi + 4], eax
	RET
Swap ENDP

Error:
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE		; 获取标准输出句柄
    MOV StdOutHandle, eax
    PUSHAD
    INVOKE WriteConsole,                        ; 打印报错信息
		StdOutHandle,
		Offset ErrorMessage,
		SIZEOF ErrorMessage,
		offset BytesWritten,
		0
	POPAD
	POP eax
	INVOKE ExitProcess, 0
END main
