; Example how to allocate a 64 kb aligned chip memory block with the size of 1900 bytes

exec_base			EQU $0004
_LVOAllocMem			EQU -198
_LVOFreeMem			EQU -210

; AllocMem() requirements
MEMF_PUBLIC			EQU $00000001 ; compability with future OS versions
MEMF_CHIP			EQU $00000002
MEMF_CLEAR			EQU $00010000

; AmigaDOS command return codes
RETURN_OK			EQU 0
RETURN_FAIL			EQU 20

memory_requirements		EQU MEMF_PUBLIC|MEMF_CHIP|MEMF_CLEAR
memory_size			EQU 1900 ; maximum size 65535 bytes
memory_64kb_size		EQU 65536
memory_request                  EQU memory_size+memory_64kb_size


; Input
; Result
; d0.l	Returncode fail or pointer 64 kB aligned memory block
	CNOP 0,4
memory_alloc
	move.l	#memory_request,d0
	move.l	#memory_requirements,d1
	move.l	exec_base.w,a6
	jsr	_LVOAllocMem(a6)
	tst.l	d0
	bne.s	memory_alloc_ok
	moveq	#RETURN_FAIL,d0
	bra.s   memory_alloc_exit
	CNOP 0,4
memory_alloc_ok
	lea	memory_block(pc),a0
	move.l	d0,(a0)
	add.l	#memory_64kb_size-1,d0	; 64 kB alignment
	clr.w	d0			; adjust pointer
memory_alloc_exit
	rts


; Input
; Result
; d0.l	Returncode ok
	CNOP 0,4
cleanup_memory
	move.l	memory_block(pc),a1	; original pointer
	move.l	#memory_request,d0
	move.l	exec_base.w,a6
	jsr	_LVOFreeMem(a6)
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
memory_block			DC.L 0

  	END
