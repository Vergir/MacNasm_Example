bits 32

global start
extern exit
extern GetFloatFromConsole
extern GetIntFromConsole
extern powf
extern PrintTableEntry
extern PrintHeader

%macro prologue 0
    push ebp
    mov ebp, esp
    and esp, 0x0000000F
    xchg ebp, esp
    and esp, 0xFFFFFFF0
    sub esp, 16
    mov [esp+12], eax
%endmacro

%macro epilogue 0
    mov eax, [esp+12]
    add esp, 16
    add esp, ebp
    pop ebp
%endmacro





section .data

align 4

minX0 dd -0.99
maxX0 dd 0.99
msgX0 db "Please type x0", 0

minStep dd 0.001
maxStep dd 0.1
msgStep db "Please type dX", 0

minN dd 2
maxN dd 15
msgN db "Please type amount of calculations", 0

minE dd 0.0001
maxE dd 1.0
msgE db "Please type max Error", 0

iter dd 1.0





section .bss

align 4

x0 resd 1
step resd 1
n resd 1
error resd 1
result resd 1





section .text

ClearFPU:
    fldz
    fldz
    fldz
    fldz
    fldz
    fldz
    fldz
    fldz

    finit
ret

XPower:
    prologue

    fld dword[x0]
    fstp dword[esp]
    fld dword[iter]
    fstp dword[esp+4]
    Call powf           ;powf(x0, iter);

    epilogue
ret

EvaluateNextMember:
    Call XPower
    fdiv dword [iter] ;NextMember = x^(2n+1)/(2n+1)
ret

UpdateResult:
    fld dword[result]
    fadd st1
    fstp dword[result]  ;result += NextMember
ret

CompareNextMemberWithError:
    fabs
    fld dword [error]
    fcomip st1          ;flags = Error - NextMember;
ret

fld2:
    fld1
    fadd st0
ret

IncreaseIteration:
    Call fld2
    fadd dword[iter]
    fstp dword[iter]   ;iterations += 2;
ret

TwiceResult:
    Call fld2
    fld dword[result]
    fmul st1
    fstp dword[result] ;result *= 2;
ret

ConvertIterations:
    Call fld2
    fld dword[iter]
    fdiv st1
    frndint
    fld1
    fadd to st1
    fstp dword[iter]
    fstp dword[iter] ;iterations = iterations/2 + 1;
ret

Calculate:
    Call ClearFPU
    Call EvaluateNextMember
    Call UpdateResult
    Call CompareNextMemberWithError
    jnc .RecursionEnd
.RecursionDive:
    Call IncreaseIteration
    Call Calculate
ret
.RecursionEnd:
    Call TwiceResult
    Call ConvertIterations
ret

GetX0:
    prologue

    mov eax, [minX0]
    mov [esp], eax
    mov eax, [maxX0]
    mov [esp+4], eax
    mov dword [esp+8], msgX0

    Call GetFloatFromConsole

    fst dword [x0]    ;x0 = GetFloatFromConsole(-0.99, 0.99, "Please type x0")

    epilogue
ret

GetDX:
    prologue

    mov eax, [minStep]
    mov [esp], eax
    mov eax, [maxStep]
    mov [esp+4], eax
    mov dword [esp+8], msgStep

    Call GetFloatFromConsole

    fst dword [step]   ;dX = GetFloatFromConsole(0.001, 0.01, "Please type dX")

    epilogue
ret

GetN:
    prologue

    mov eax, [minN]
    mov [esp], eax
    mov eax, [maxN]
    mov [esp+4], eax
    mov dword [esp+8], msgN

    Call GetIntFromConsole

    mov [n], eax            ;N = GetIntFromConsole(2, 15, "Please type N")

    epilogue
ret

GetError:
    prologue

    mov eax, [minE]
    mov [esp], eax
    mov eax, [maxE]
    mov [esp+4], eax
    mov dword [esp+8], msgE

    Call GetFloatFromConsole

    Call fld2
    fdiv st1, st0
    fstp dword[error]

    fst dword[error] ;error = GetFloatFromConsole(0.001, 1, "Please type Error")

    epilogue
ret

PrintRow:
    prologue


    mov eax, [x0]
    mov [esp], eax
    mov eax, [result]
    mov [esp+4], eax
    mov eax, [iter]
    mov [esp+8], eax

    Call PrintTableEntry

    epilogue
ret

PrepareForNext:
    fld dword[x0]
    fadd dword[step]
    fstp dword[x0]

    fld1
    fstp dword[iter]

    fldz
    fstp dword[result]

    mov ecx, dword[n]
    dec ecx
    mov dword[n], ecx
ret

WorkingLoop:
    Call Calculate
    Call PrintRow
    Call PrepareForNext

    cmp ecx, 0
    jg WorkingLoop
ret

PrintTableHeader:
    prologue

    Call PrintHeader

    epilogue
ret

Exit:
    prologue

    mov dword[esp], 0
    Call exit

    epilogue
ret

start:
    Call GetX0
    Call GetDX
    Call GetN
    Call GetError

    Call PrintTableHeader

    Call WorkingLoop

    Call Exit