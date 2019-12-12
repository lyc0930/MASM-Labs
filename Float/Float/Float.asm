INCLUDE     irvine32.inc
INCLUDE     macros.inc

BufferSize = 200

.data
X		REAL8   ?
A1      REAL8   ?
A2      REAL8   ?
A3      REAL8   ?
Buffer  BYTE    BufferSize DUP(?)
Ten     REAL8   10.0
Temp    SDWORD  ?
Power   REAL8   ?

.code
main PROC
	FINIT					    ; initialize FPU
	MOV     ecx, 4
Input:
	PUSH    ecx
	MOV     edx, 4
	SUB     edx, ecx
	.IF (edx == 0)
		mWrite  "x = "
	.ELSE
		mWrite  "a"
		MOV     eax, edx
		CALL    WriteDec
		mWrite  " = "
	.ENDIF
    PUSH    edx
    MOV     edx, OFFSET Buffer
	MOV     ecx, BufferSize
	CALL    ReadString
	MOV     edx, OFFSET Buffer
	MOV     bl, 0             ; 正数
	CALL    My_ReadFloat
    POP     edx
    .IF (edx == 0 && bl == 1) ; 读入x < 0
        CALL    Error
    .ENDIF
	POP     ecx
	LOOP    Input

	FSTP    A3  ; a3入栈
	FSTP    A2  ; a2入栈
	FSTP    A1  ; a1入栈
	FSTP    X   ; x 入栈
	FLD	    A2  ; ST(0) = a2
	FLD     X   ; ST(0) = x,                                            ST(1) = a2
	FYL2X       ; ST(1) <- ST(1) * Log2[ ST(0) ]    = a2 * Log2[ x ]    Pop
	FLD     X   ; ST(0) = x
	FSQRT       ; ST(0) <- Sqrt[ ST(0) ]            = Sqrt[ x ]
	FLD     A1  ; ST(0) = a1,                                           ST(1) = Sqrt[ x ]
	FMUL        ; ST(1) <- ST(1) * ST(0)            = a1 * Sqrt[ x ]    Pop
	FLD     X   ; ST(0) = x
	FSIN        ; ST(0) <- Sin[ ST(0) ]             = Sin[ x ]
	FLD     A3  ; ST(0) <- a3,                                          ST(1) = Sin[ x ]
	FMUL        ; ST(1) <- ST(1) * ST(0)            = a3 * Sin[ x ]     ST(0) =
	FADD        ; ST(1) <- ST(1) + ST(0)                                ST(0) = a1 * Sqrt[ x ]
	FADD        ; ST(1) <- ST(1) + ST(0)                                ST(0) = a2 * Log2[ x ]
	CALL    WriteFloat
	INVOKE  ExitProcess, 0
main ENDP

Error PROC
	mWrite  "Error: x < 0!"
	INVOKE  ExitProcess, 0
Error ENDP

;--------------------------------------------------------
My_ReadFloat PROC
; Reads a 32-bit signed decimal float number from standard
; input, stopping when the Enter key is pressed.
; All valid digits occurring before a non-numeric character
; are converted to the integer value. Leading spaces are
; ignored, AND an optional leading + or - sign is permitted.
; All spaces return a valid integer, value zero.

; Receives: edx = OFFSET Buffer
; Returns: bl = 1 : Negative
;--------------------------------------------------------
    MOV     al, BYTE PTR [edx]
    INC     edx
    CMP     al, '+'
    JNE     Negative_Q
    MOV     al, BYTE PTR [edx]
    INC     edx
    JMP     Number
Negative_Q:
    CMP     al, '-'
    JNE     Number
    MOV     bl, 1                                   ; 负数
    MOV     al, BYTE PTR [edx]
    INC     edx
Number:
    .IF (al >= '0' && al <= '9') || (al == '.')
        FLDZ                                        ; Load 0.0
        .WHILE (al >= '0' && al <= '9')
            SUB     al, '0'
            AND     eax, 0Fh
            MOV     Temp, eax
            FMUL    Ten                             ; Temp *= 10
            FILD    Temp
            FADD
            MOV     al, BYTE PTR [edx]
            INC     edx
        .ENDW
        .IF (al == '.')
            MOV     al, BYTE PTR [edx]
            INC     edx
            FLDZ
            FLD     Ten
            FSTP    Power
            .WHILE (al >= '0' && al <= '9')
                SUB     al, '0'
                AND     eax, 0Fh
                MOV     Temp, eax
                FILD    Temp
                fdiv    Power                      ; Temp /= Power
                FADD
                FLD     Power
                FMUL    Ten                        ; Power *= 10
                FSTP    Power
                MOV     al, BYTE PTR [edx]
                INC     edx
            .ENDW
            FADD
        .ENDIF
    .ELSE
        CALL    Error
    .ENDIF
    .IF (bl == 1)
        FCHS                                    ; Change Sign
    .ENDIF
    RET
My_ReadFloat ENDP
END main
