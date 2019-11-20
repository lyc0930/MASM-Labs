; input < Keyboard > Input1.txt
; Uppercase < Input1.txt > WriteToOutput1.txt

INCLUDE Irvine32.inc
INCLUDE macros.inc

BufferSize = 200

.data
Buffer 			BYTE 	BufferSize DUP(?)
Infile  		BYTE 	"D:\private\File\课程相关\微机原理与系统\Experiment\MASM-Labs\IO\Input1.txt", 0
Outfile 		BYTE 	"D:\private\File\课程相关\微机原理与系统\Experiment\MASM-Labs\IO\Output1.txt", 0
StdInHandle 	HANDLE 	?
FileHandle  	DD 		?
BytesRead   	DWORD 	?
ErrorMessage	BYTE 	"Error! ", 0
BytesActual 	DD 		?
StdOutHandle 	DD 		?
BytesWritten 	DD 		?

.code
main PROC
ReadFromKeyboard:
	INVOKE GetStdHandle, STD_INPUT_HANDLE 		; 获取标准输入句柄
	MOV	StdInHandle,eax
	INVOKE ReadConsole,                         ; 从控制台输入
		StdInHandle,
		ADDR Buffer,
	  	BufferSize,
		ADDR BytesRead,
		0
WriteToInput:
    PUSH eax
	INVOKE CreateFile,                          ; 打开infile文件
		ADDR Infile,
		GENERIC_READ OR GENERIC_WRITE,          ; 读/写模式
		FILE_SHARE_READ OR FILE_SHARE_WRITE,	; 开放共享
		NULL,
	  	CREATE_ALWAYS,                          ; 创建
		FILE_ATTRIBUTE_NORMAL,
		0
	MOV FileHandle, eax                         ; 保留文件句柄
    CMP eax, INVALID_HANDLE_VALUE				; 比较文件句柄是否合法
	JZ Error								    ; 跳转报错
	INVOKE WriteFile,							; 写文件
		FileHandle,
        OFFSET Buffer,
        BufferSize,
		ADDR BytesActual,						; 实际写字节数
        0
ReadFromInput:
    PUSH eax
	INVOKE CreateFile,                          ; 再次打开infile文件
		ADDR Infile,
		GENERIC_READ OR GENERIC_WRITE,          ; 读/写模式
		FILE_SHARE_READ OR FILE_SHARE_WRITE,	; 开放共享
		NULL,
	  	OPEN_EXISTING,                          ; 打开已有文件
		FILE_ATTRIBUTE_NORMAL,
		0
	MOV FileHandle, eax                         ; 保留文件句柄
    CMP eax, INVALID_HANDLE_VALUE				; 比较文件句柄是否合法
	JZ Error								    ; 跳转报错
	INVOKE ReadFile,							; 读文件
		FileHandle,
		OFFSET Buffer,
		BufferSize,
		ADDR BytesActual,
		0
	MOV ecx, BytesActual						; ecx <- 字节数
	MOV esi, OFFSET Buffer						; esi <- 首地址
Uppercase:
	MOV bl, [esi]								; 循环读取buffer
	CMP bl, 60H
	JB WriteToOutput
	sub bl, 20H									; lower case -> -32 -> uppercase
	MOV [esi], bl								; 写回Buffer
WriteToOutput:
	ADD esi, TYPE Buffer						; 循环增量
	LOOP Uppercase								; 循环结束
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE		; 获取标准输出句柄
    MOV StdOutHandle, eax
    PUSHAD										; 储存存储器值
    INVOKE WriteConsole,					    ; 输出Buffer到控制台
		StdOutHandle,
		ADDR Buffer,
		BytesActual,
		offset BytesWritten,
		0
	POPAD
	MOV edx, OFFSET Outfile
	INVOKE CreateFile,							; 打开Outfile文件
	  edx,
	  GENERIC_WRITE,            				; 写模式
	  DO_NOT_SHARE,
	  NULL,
	  CREATE_ALWAYS,							; 创建
	  FILE_ATTRIBUTE_NORMAL,
	  0
	MOV FileHandle, eax
	INVOKE WriteFile,							; 读文件
		FileHandle,
		OFFSET Buffer,
		BufferSize,
		ADDR BytesActual,
		0
	JMP Finish
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
Finish:
	POP eax
	INVOKE ExitProcess, 0
main ENDP
END main