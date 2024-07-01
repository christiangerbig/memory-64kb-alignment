; Example how to allocate a 64 kb aligned chip memory block with the size of 1900 bytes

exec_base			EQU $0004
_LVOAllocMem			EQU -198
_LVOFreeMem			EQU -210

; ** AllocMem() requirements **
MEMF_PUBLIC			EQU $00000001 ;compability with future OS versions
MEMF_CHIP			EQU $00000002
MEMF_CLEAR			EQU $00010000

; ** DOS errors **
RETURN_OK			EQU 0
RETURN_FAIL			EQU 20

memory_requirements		EQU MEMF_PUBLIC+MEMF_CHIP+MEMF_CLEAR
memory_size			EQU 1900 ;Maximum size 65535 bytes
memory_64kb_size		EQU 65536
memory_request                  EQU memory_size+memory_64kb_size


	SECTION memory_64kb_alignment,CODE

memory_alloc
	move.l	exec_base.w,a6
	move.l	#memory_request,d0
	move.l	#memory_requirements,d1
	jsr	_LVOAllocMem(a6)
	tst.l	d0
	bne.s	memory_alloc_ok
	moveq	#RETURN_FAIL,d0
	bra.s   exit
	CNOP 0,4
memory_alloc_ok
	move.l	d0,-(a7)		;Save original pointer
	add.l	#memory_64kb_size-1,d0	;64 kB alignment
	clr.w	d0			;Pointer to 64 kB aligned memory block

; ** do something else **

cleanup_memory
	move.l	(a7)+,a1		;Original pointer to memory block
	move.l	#memory_request,d0
	move.l	exec_base.w,a6
	jsr	_LVOFreeMem(a6)
	moveq	#RETURN_OK,d0
exit
	rts

  	END