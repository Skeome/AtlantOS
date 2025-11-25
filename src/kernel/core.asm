;=================================================
; AtlantOS - Core Kernel (Simulated Ternary Logic)
;=================================================
[BITS 32]
[ORG 0x2000]                    ; We will load the kernel at 0x2000

kernel_entry:
    ; Clear the Screen (simple loop)
    mov edi, 0xB8000
    mov ecx, 80 * 25
    mov ax, 0x0720              ; Black background, white text, space character
    rep stosw

    ; Setup the "Ternary Test"
    ; Wee will start with a positive drift and watch it stabilize
    mov eax, 40                 ; Initial Drift Value (+40)
    mov edi, 0xB8000            ; Start Writing at top-left

stabilize_loop:
    ; VISUALIZATION 
    ; We need to save registers because we are about to do math
    push eax

    ; Default character: 'X' (Zero/Locked)
    mov cx, 0x0A58              ; 'X' character with Light Green color
    cmp eax, 0
    je .draw                    ; If zero, keep 'X'

    ; If not zero, assume negative first
    mov cx, 0x0C3C              ; '<' character with Light Red color
    cmp eax, 0
    jl .draw                    ; If less than zero, keep '<'

    ;Must be positive
    mov cx, 0x0E3E

.draw:
    mov [edi], cx               ; Write char+color to video memory (WORD write is safer)
    add edi, 2                  ; move to next screen cell

    pop eax                     ; Restore our Drift Value

    ; The (branchless) Ternary Logic
    ; GOAL: Move EAX toward 0 without using conditional jumps for the math

    ; Check if 0 (We still need to check if we are done to break the loop)
    cmp eax, 0
    je .done

    ; Calculate Sign(EAX) into EBX
    ; If EAX > 0 --> EBX = 1
    ; If EAX < 0 --> EBX = -1
    ; If EAX = 0 --> EBX = 0

    xor ebx, ebx                ; Clear EBX
    xor edx, edx                ; Clear EDX

    cmp eax, 0
    setg bl                     ; If > 0, BL = 1
    setl dl                     ; If < 0, DL = 1
    sub ebx, edx                ; EBX = BL - DL. Result is 1, -1, or 0

    ; Apply the correction
    sub eax, ebx                ; EAX = EAX - Sign(EAX)

    ; Add tiny delay loop so we can see it happen
    mov ecx, 0x00FFFFFF
.delay:
    loop .delay
    jmp stabilize_loop

.done:
    ; Print manual "LOCKED" message
    ; Since we don't have a print function in the kernel yet
    ; We force EDI to the start of line 2 (Row 1, Col 0)
    ; Line 1 = 0xB8000, Line 2 = 0xB80A0, Line 3 = 0xB8140
    mov edi, 0xB80A0

    ; Write 'LOCKED' in Cyan (0x0B)
    mov word [edi], 0x0B4C      ; 'L'
    mov word [edi+2], 0x0B4F    ; 'O'
    mov word [edi+4], 0x0B43    ; 'C'
    mov word [edi+6], 0x0B4B    ; 'K'
    mov word [edi+8], 0x0B45    ; 'E'
    mov word [edi+10], 0x0B44   ; 'D'

    jmp $                       ; Hang Forever
    