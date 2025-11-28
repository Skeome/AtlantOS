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
    mov esi, 0                  ; Initial Drift Value (0)
    mov edi, 0xB8000            ; Start Writing at top-left

    ; Call IDT
    call setup_idt

kernel_loop:
    ; VISUALIZATION 
    ; We need to save registers because we are about to do math
    push esi
    push edi

    ; Reset render pointer to the start of the starus line
    mov edi, 0xB8000

    ; Clear the statul line (Erase the previous state)
    mov ecx, 80
    mov ax, 0x0720              ; Space character with default color
    rep stosw

    ; Reset Render Poionter again
    mov edi, 0xB8000

    ; Default character: 'X' (Zero/Locked)
    mov cx, 0x0A58              ; 'X' character with Light Green color
    cmp esi, 0
    je .draw                    ; If zero, keep 'X'

    ; If not zero, assume negative first
    mov cx, 0x0C3C              ; '<' character with Light Red color
    cmp esi, 0
    jl .draw                    ; If less than zero, keep '<'

    ;Must be positive
    mov cx, 0x0E3E

.draw:
   ; Render the state bar (Visualizing the magnitude of error)
   ; We map the value in ESI to a position on the screen
   mov ebx, esi                 ; Copy drift value
   cmp ebx, 0
   jge .abs_calc
   neg ebx                      ; Get |abs| if negative

.abs_calc:
    ; If stable (0), draw single indicator
    cmp ebx, 0
    jne .render_loop
    mov [edi], cx               ; Write character and color into memory
    jmp .update_labels
    
.render_loop:
    cmp ebx, 0
    je .update_labels
    mov [edi], cx               ; Write status char+color
    add edi, 2                  ; Move to the next screen cell
    dec ebx
    jmp .render_loop

.update_labels:
    ; Kernel Status Messages

    mov edi, 0xB80A0            ; Move to start of line 2 (row 1, col 0)

    cmp esi, 0
    jne .status_correcting

    ; Status STABLE (Cyan)
    mov dword [edi], 0x0B540B53     ; TS ---> ST
    mov dword [edi+4], 0x0B420B41   ; BA ---> AB
    mov dword [edi+8], 0x0B450B4C   ; EL ---> LE
    jmp .ternary_logic

.status_correcting:
    ; Status ACTIVE (Red - Kernel is working)
    mov dword [edi], 0x0C430C41     ; CA ---> AC
    mov dword [edi+4], 0x0C490C54   ; IT ---> TI
    mov dword [edi+8], 0x0C450C56   ; EV ---> VE

.ternary_logic:
    pop edi
    pop esi

    ; Ternary Scheduler Logic
    ; Kernel automatically seeks equilibrium (0)
    ; In the full OS, this logic will balance load between cores

    cmp esi, 0
    je .cycle_delay

    ; Branchless Ternary Operator
    ; Direction = sign(ESI)
    xor ebx, ebx
    xor edx, edx
    cmp esi, 0
    setg bl             ; BL = 1 if (+)
    setl dl             ; DL = 1 if (-)
    sub ebx, edx        ; EBX = 1 or -1

    sub esi, ebx        ; Restore Equilibrium

.cycle_delay
    ; Kernel Cycle Delay
    mov ecx, 0x00400000
.wait:
    loop .wait

    jmp kernel_loop

; Include Drivers
    %include 'src/kernel/idt.asm'