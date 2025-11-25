# x86_64 Assembly Introduction and Reference Manual

# Introduction

----

## What is Assembly?
Assembly serves as the critical bridge between high-level programming languages and machine code.
While most software development occurs in languages like *Python*, *Java*, or *JavaScript*, **Assembly** remains fundamental for system programming, embedded systems, performance-critical applications, and understanding computer architecture.

Every processor - whether it's an Intel x86-64, ARM Cortex, Apple M-Series, or AMD Ryzen - has its own instruction set architecture (ISA).
These instructions control arithmetic operations, logical operations, memory management, and I/O operations.
Machine Language (ML) consists of binary patterns (1s and 0s) that processors execute directly, but assembly provides human-readable mnemonics for these instructions.

## Modern Relevance of Assembly
Despite advances in compiler technology and high-level languages, assembly remains crucial for:
- **Operating System Development**: Kernel-level programming, device drivers, and bootloaders
- **Embedded Systems**: IoT devices, micro-controllers, automotive systems, and smart appliances
- **Game Development**: Performance-critical graphics engines and real-time systems
- **Cybersecurity**: Malware analysis, reverse engineering, and exploit development
- **High-Performance Computing**: Optimizing critical code paths in scientific computing
- **Compiler Development**: Understanding code generation and optimization techniques
- **Firmware Development**: BIOS/UEFI, embedded device firmware

## Advantages of Learning Assembly
Understanding assembly provides deep insights into:
- **System Architecture**: How modern processors work with multi-core designs, cache hierarchies, and pipeline execution
- **Memory Management**: Virtual memory, memory mapping, and memory protection mechanisms
- **Performance Optimization**: Identifying bottlenecks and understanding compiler optimizations
- **Security Concepts**: Buffer overflows, stack manipulation, and low-level vulnerabilities
- **Hardware Interfaces**: Direct hardware control, interrupt handling, and device communication
- **Debugging Skills**: Reading assembly, understanding crash dumps, and system-level debugging

## Modern PC Architecture
Today's computers feature complex architectures:
- **64-bit Processors**: x86-64 (AMD64) architecture with extended registers and addressing
- **Multi-core Systems**: Parallel processing capabilities with shared and private caches
- **SIMD Instructions**: SSE, AVX, AVX-512 for vector processing and parallel operations
- **Memory Hierarchy**: L1, L2, L3 caches, main memory, and storage devices
- **Security Features**: ASLR, DEP/NX bit, Control Flow Integrity (CFI), Intel CET

## Data Sizes in Modern Systems
Current processors support various data sizes:
- **Bit**: Single character (eg., 0, 1, F, A)
- **Nibble**: 4 bits
- **Byte**: 8 bits, 2 nibbles. The fundamental addressable unit
- **Word**: 16 bits, 4 nibbles, 2 bytes. Legacy compatibility
- **Double Word (DWORD)**: 32 bits, 8 nibbles, 4 bytes, 2 words
- **Quad Word (QWORD)**: 64 bits, 16 nibbles, 8 bytes, 4 words, 2 dwords. Native size for 64-bit systems
- **SIMD Registers**: 128-bit XMM, 256-bit YMM, 512-bit ZMM for vector operations
- **Memory Pages**: Typically 4KB (4096 bytes) for virtual memory management

## Number Systems and Data Representation

### Binary Number System
Binary remains the foundation of all digital computation. Moderns systems use two's compliment for signed integers, enabling efficient arithmetic operations.

```
 --------------------------------------------------------------
|Bit Position  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
 --------------------------------------------------------------
|Power of 2    | 2^7 | 2^6 | 2^5 | 2^4 | 2^3 | 2^2 | 2^1 | 2^0 |
 --------------------------------------------------------------
|Decimal Value | 128 |  64 |  32 |  16 |  8  |  4  |  2  |  1  |
 --------------------------------------------------------------
```

### Hexadecimal Notation
Hexadecimal (base-16) provides a compact representation for binary data, essential for debugging and low-level programming.
#### Hex to Binary Conversion
**Example**: 0x2A3F
- 2 = 0010
- A = 1010
- 3 = 0011
- F = 1111
- Result: 0010101000111111
#### Common Hex Patterns
- 0xFF = 255 (max byte value). (Binary 11111111)
- 0xDEADBEEF = debugging marker
- 0x400000 = typical program base address

## Memory Organization and Addressing
Modern systems use complex memory management:
### Virtual Memory Model
- **User Space**: Application memory (0x00000000 to 0x7FFFFFFF on 32-bit)
- **Kernel Space**: Operating system memory (protected from user access)
- **Memory Mapping**: Files, libraries and devices mapped into address space
- **Stack and Heap**: Dynamic memory allocation and function call management
### Endianness
Most x86-64 systems use little-endian byte ordering, where the least significant byte (lsb) is stored at the lowest address.
Understanding endianness is crucial for:
- Network programming (big-endian network byte order)
- File format parsing
- Cross-platform compatibility
- Binary data analysis

## Modern Development Tools and  Ecosystems
Assembly programming benefits from sophisticated toolchains:
- **Assemblers**: *NASM*, *GAS* (GNU Assembler), *MASM*, *FASM*
- **Debuggers**: *GDB*, *LLDB*, *Intel Inspector*, *Visual Studio debugger*
- **Analysis Tools**: *Intel VTune*, *Perf*, *Valgrind*, static analysis tools
- **Cross-platform Support**: Tools work across Windows, Linux, macOS, embedded platforms

-----------------------------------------------------------------------------------------------------------------------------------

# Environment Setup

----

## Local Environment Setup
Assembly is dependent on the instruction set and architecture of the processor.
In this project, we are going to focus on Intel-32 processors like Pentium.
To begin, you will need:
- An IBM PC or any equivalent compatible computer (VMs work as well)
- A copy of Linux (your choice in flavor)
- A copy of NASM

There are many good assemblers like *Microsoft Assembler* (MASM), *Borland Turbo Assembler* (TASM), The *GNU Assembler* (GAS), *Flat Assembler* (FASM), etc.
We will be using the *Netwide Assembler* (NASM) because it's open-source, well-documented, and cross-platform.

## Installing NASM
Depending on your chosen distribution and whether development tools are included, you may already have NASM.
You can check whether or not it's installed on most distributions by following these steps:
- Open a Terminal
- Type `whereis nasm` and press ENTER/RETURN
If it's installed, you will see something like `/usr/bin/nasm`
Otherwise, you will need to install nasm. This can be done various ways depending on your distribution and package manager:
- **Arch Based**: `sudo pacman -S nasm`
- **Debian Based**: `sudo apt install nasm`
- **GUI Package Managers**: Search for nasm
- **Manual Installation**:
- - Check the NASM website for the latest version
- - Download the source archive `nasm-X.XX.ta.gz` where `X.XX` is the version number
- - Unpack the archive into a directory which creates a subdirectory `nasm-X.XX`
- - cd to `nasm-X.XX`, type `./configure`, hit Enter/Return. This shell script will find the best C compiler to use and setup makefiles accordingly
- - enter `make` to build the nasm and ndisasm binaries
- - enter `make install` to install nasm and ndisasm in `/usr/local/bin` and to install the man pages

This should install NASM on your system. Alternatively, you can use an RPM distribution for Fedora.
This version is simpler to install, just double click the RPM file 

-----------------------------------------------------------------------------------------------------------------------------------

# Basic Syntax

----

## Modern Assembly Structure
Modern assembly programs follow a standardized structure with distinct sections for different types of data and code.
Understanding this organization is crucial for writing maintainable assembly code.

## Program Sections Overview
### The *data* Section
Contains initialized data that persists throughout program execution.
This includes:
- **String literals**: Text messages, prompts, error messages
- **Numeric constants**: Predefined Values, lookup tables
- **Array initializers**: Static arrays with known values
- **Configuration data**: Program settings, magic numbers

```
section .data
    ;String declarations
    welcome_msg db 'Welcome to Assembly!', 0xA, 0
    error_msg db 'Error: Invalid input.', 0xA, 0

    ;Numeric data
    pi dd 3.14159                       ; 32-bit float
    max_users dq 1000                   ; 64-bit integer
    lookup_table db 1, 4, 9, 16, 25     ; Array of squares

    ;System constants
BUFFER_SIZE equ 256
VERSION_STRING db 'v2.1.0', 0
```

### The *bss* Section
Reserves space for uninitialized variables.
Memory is automatically zeroed by the system loader:
- **Buffers**: Input/output buffers, temporary storage
- **Counters**: Loop counters, statistics
- **Arrays**: Dynamic arrays, working space
- **User data**: Variables that will be set during runtime

```
section.bss
    ;Reserve space for variables
    input_buffer resb 256           ;256-byte buffer
    user_count resq 1               ;64-bit counter
    temp_array resd 100             ;Array of 100 32-bit integers
    file_handle resq 1              ;File descriptor storage
```

### The *text* Section
Contains executable instructions.
Modern programs require proper entry point declaration:

```
section.text
    global_start                ;Entry point for Linux
    ;global main                ;Alternative entry for C runtime

_start:
    ;Program instructions go here
    ;Must end with system exit call
```

## Modern Data Types and Declarations
```
 -------------------------------------------------------------------
|  Directive  |    Size    |  Description   |        Example        |
 -------------------------------------------------------------------
|     DB      |   1 byte   |  Byte Data     |   db 0xFF,'A', 65     |
 -------------------------------------------------------------------
|     DW      |   2 bytes  |  Word Data     |   dw 0x1234, 65535    |
 -------------------------------------------------------------------
|     DD      |   4 bytes  |  Double Word   |   dd 0x12345678       |
 -------------------------------------------------------------------
|     DQ      |   8 bytes  |  Quad Word     | dq 0x123456789ABCDEF0 |
 -------------------------------------------------------------------
|    RESB     |   1 byte   | Reserve bytes  |       resb 100        |
 -------------------------------------------------------------------
|    RESW     |   2 bytes  | Reserve words  |       resw 50         |
 -------------------------------------------------------------------
|    RESD     |   4 bytes  | Reserve dwords |       resd 25         |
 -------------------------------------------------------------------
|    RESQ     |   8 bytes  | Reserve qwords |       resq 10         |
 -------------------------------------------------------------------
```

## Comments and Documentation
Good documentation is essential for assembly code maintainability
```
; Single Line Comment - explains the following line
mov rax, 42             ; Inline comment  - explains this specific instruction

; Multi-line documentation block
; This section implements the quicksort algorithm
; Input: RSI = Array pointer, RDX = array length
; Output: Array sorted in ascending order
; Registers modified: RAX, RBX, RCX, RDX, RSI, RDI
```

## Instruction Format and Syntax
Modern assembly instructions follow a consistent format:
```
[label:] mnemonic [operand1], [operand2] ;[comment]
```
### Operand Types
- **Register**: `rax, ebx, cl` (processor registers)
- **Immediate**: `42, 0xFF, 'A'` (constant values)
- **Memory**: `[rbp-8], [buffer+rsi]` (memory addresses)
- **Label**: `loop_start, exit` (code addresses)

### Common Instruction Examples
```
; Data Movement
mov rax, 100                    ;Load immediate value (100 into rax)
mov rbx, rax                    ;Register to register (rax to rbx)
mov [buffer], al                ;Register to memory (al to memory address buffer)
mov rsi, [data_ptr]             ;Memory to register (data_ptr address to rsi)

; Arithmetic Operations
add rax, rbx                    ;Add registers (add rbx to rax) 
sub rax, 10                     ;Subtract immediate value (subtract 10 from rax)
imul rax, rcx                   ;Signed Multiplication (rcx times rax)
idiv rbx                        ;Signed Division (result in rax, remainder in rdx)

;Logical Operations
and rax, 0xFF                   ;Bitwise AND
or rax, rbx                     ;Bitwise OR
xor rax, rax                    ;Clear Register (commmon idiom)
not rax                         ;Bitwise NOT

;Comparison and Jumps
cmp rax, rbx                    ;Compare values
je equal_label                  ;Jump if equal
jne not_equal_label             ;Jump if not equal
jmp unconditional               ;Unconditional jump
```
## Modern 64-bit Register Usage
### General Purpose Registers
```
 -----------------------------------------------------------
|  64-bit  |  32-bit  |  16-bit  |   8-bit  |    Purpose    |
 -----------------------------------------------------------
|   RAX    |   EAX    |    AX    |    AL    |  Accumulator  |
 -----------------------------------------------------------
|   RBX    |   EBX    |    BX    |    BL    |     Base      |
 -----------------------------------------------------------
|   RCX    |   ECX    |    CX    |    CL    |    Counter    |
 -----------------------------------------------------------
|   RDX    |   EDX    |    DX    |    DL    |     Data      |
 -----------------------------------------------------------
|   RSI    |   ESI    |    SI    |    SIL   |  Source Index |
 -----------------------------------------------------------
|   RDI    |   EDI    |    DI    |    DIL   |  Dest. Index  |
 -----------------------------------------------------------
|   RBP    |   EBP    |    BP    |    BPL   |  Base Pointer |
 -----------------------------------------------------------
|   RSP    |   ESP    |    SP    |    SPL   | Stack Pointer |
 -----------------------------------------------------------
|  R8-R15  | R8D-R15D | R8W-R15W | R8B-R15B | Extended Regs.|
 -----------------------------------------------------------
```

## First Assembly Program Example
Here's a comprehensive example showing modern assembly programming practices:
```
; Modern Assembly Program - Calculator
; Target: Linux x86-64
; Assembler: NASM

section .data
    ;Program information
    title db 'Assembly Calculator v2.0', 0xA, 0
    title_len equ $ - title

    ;User interface strings
    prompt db 'Enter two numbers (0-9)" ', 0
    prompt_len equ $ - prompt

    result_msg db 'Result: ', 0
    result_len equ $ - result_msg

    newline db 0xA, 0

    ;Constants
    EXIT_SUCCESS equ 0
    STDIN equ 0
    STDOUT equ 1
    SYS_READ equ 0
    SYS_WRITE equ 1
    SYS_EXIT equ 60

section .bss
    ;Input buffers
    num1 resb 2         ;First number + newline
    num2 resb 2         ;Second number + newline
    result resb 4       ;Result storage

section .text
    global_start

_start:
    ;Display title
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, title
    mov rdx, title_len
    syscall

    ;Display prompt
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ;Read first number
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, num1
    mov rdx, 2
    syscall

    ;Read second number
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, num2
    mov rdx, 2
    syscall

    ;Convert ASCII to numeric and calculate
    mov al, [num1]      ;Load first digit
    sub al, '0'         ;Convert ASCII to number
    mov bl, [num2]      ;Load second digit
    sub bl, '0'         ;Convert ASCII to number
    add al, bl          ;Add numbers

    ;Convert result back to ASCII
    add al, '0'
    mov [result], al
    mov byte [result+1], 0xA    ;Add newline

    ;Display result message
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, result_msg
    mov rdx, result_len
    syscall

    ;Display result
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, result
    mov rdx, 2
    syscall

    ;Clean Exit
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

;Error handling coud be added here
error_exit:
    mov rax, SYS_EXIT
    mov rdi, 1              ;Error exit code
    syscall
```

## Best Practices
- *Use meaningful labels*: `calculate_average` instead of `loop1`
- *Document register usage*: Comment which registers hold what data
- *Follow calling conventions*: Preserve registers as required by ABI
- *Handle errors gracefully*: Check return values, validate inputs
- *Use constants for system calls*: Define meaningful names for magic numbers
- *Align data properly*: Use alignment directives for performance
- *Comment complex algorithms*: Explain the logic, not just the syntax

## Building and Running Modern Assembly Programs
### Linux (64-bit)
Assemble to object file
`nasm -f elf64 program.asm -o program.o`
Link to create executable
`ld program.o -o program`
Run the program
`./program`
You may need to make it executable first
`chmod +x program` 

### Windows (64-bit)
Using NASM + MinGW
`nasm -f win64 program.asm -o program.obj`
`gcc program.obj -o program.exe`

Using NASM + MSVC
`nasm -f win64 program.asm -o program.obj`
`link program.obj /subsystem:console /out:program.exe` 

### macOS (64-bit)
Assemble for macOS
`nasm -f macho64 program.asm -o program.o`
Link with system libraries
`ld program.o -macosx_version_min 10.14 -lSystem -o program`

## Debugging Your Assembly Code
Compile with debug symbols
`nasm -f elf64 -g -F dwarf program.asm -o program.o`
`ld program.o -o program`
Debug with GDB
`gdb ./program`

Useful GDB Commands:
- `layout asm`: Show assembly view
- `layout regs`: Show registers
- `stepi`: Step one instruction, alias: `s`
- `info registers`: Display all registers, alias: `i r`
- `x/10x $rsp`: Examine stack memory

This foundation will prepare you for more advanced assembly programming topics including function calls, stack management, and system programming. 

-----------------------------------------------------------------------------------------------------------------------------------


# Memory Segments and Virtual Memory
----
## Understanding Modern Memory Architecture
Memory segmentation in modern 64-bit systems has evolved significantly from traditional 16-bit and 32-bit architectures.
While the fundamental concepts remain, contemporary operating systems implement sophisticated virtual memory management that provides security, isolation, and eficient resource utilization.

The `section` and `segment` keywords in assembly are oftn interchangeable, but understanding their distinction helps in comprehending how programs are organized in memory:
```
segment .text           ; Legacy segmented model syntax
section .text           ; Modern flat memory model syntax (preferred)
```

## Virtual Memory Model in Modern Systems
Modern operating systems use a **flat memory model** with virtual memory management, which provides each process with its own virtual address space.
This differs from the segmented memory model of older processors.

### Key Advantages of Virtual Memory
- **Process Isolation**: Each program runs its own virtual address space
- **Memory Protection**: Hardware prevents unauthorized access between processes
- **Address Space Layout Randomization (ASLR)**: Security feature that randomizes memory locations
- **Demand Paging**: Only needed memory pages are loaded into physical RAM
- **Memory Mapping**: Files and devices can be mapped into memory space

## Modern Memory Layout (64-bit Linux/Windows)
### Typical Virtual Address Space Layout
```
 -------------------------------------------------------
| Address Range | Section |    Purpose    | Permissions |
 -------------------------------------------------------
|  0x00000000   |  NULL   |  Trap Null    |             |
|  -            |  Guard  |   pointer     | No Access   |
|  0x00400000   |         |  dereference  |             |
 -------------------------------------------------------
|  0x00400000   |  Text   |    Program    |   Read      |
|  -            | Segment |     code      |     +       |
|  0x00600000   |         |   (.text)     |  Execute    |
 -------------------------------------------------------
|  0x00600000   |  Data   |  Initialized  |   Read      |
|  -            | Segment |     data      |     +       |
|  0x00800000   |         |   (.data)     |   Write     |
 -------------------------------------------------------
|  0x00800000   |   BSS   | Uninitialized |   Read      |
|  -            | Segment |     data      |     +       |
|  0x01000000   |         |    (.bss)     |   Write     |
 -------------------------------------------------------
|  0x01000000   |         |   Dynamic     |   Read      |
|  -            |  Heap   |    Memory     |     +       |
|  Growing Up   |         |  Allocation   |   Write     |
 -------------------------------------------------------
|  Growing Down |         | Fuction calls |   Read      |
|  -            |  Stack  |    Local      |     +       |
|  0x7FFE0000   |         |  variables    |   Write     |
 -------------------------------------------------------
|  0x7FFE0000   |  Kernel |  Operating    |             |
|  -            |  Space  |   System      | Kernel Only |
|  0x80000000   |         |               |             |
 -------------------------------------------------------
```

## Program Sections in Detail

