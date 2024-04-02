exec_base           EQU $0004

_LVOAllocMem        EQU -198
_LVOFreeMem         EQU -210

MEMF_PUBLIC         EQU $00000001 ;for compability with future OS versions
MEMF_CHIP           EQU $00000002
MEMF_CLEAR          EQU $00010000

memory_requirements EQU MEMF_PUBLIC+MEMF_CHIP+MEMF_CLEAR
memory_size         EQU 1900 ;Maximum memory size is 65535 bytes
memory_64kb_size    EQU 65536

  SECTION memory_64kb_alignment,CODE

memory_alloc
  move.l exec_base.w,a6
  move.l #memory_size+memory_64kb_size,d0
  move.l #memory_requirements,d1
  jsr    _LVOAllocMem(a6)
  tst.l  d0
  beq.s  memory_alloc_error
  move.l d0,-(a7)
  add.l  #memory_64kb_size-1,d0 ; Do 64 kB alignment
  clr.w  d0

; d0 contains the address of a 64 kB aligned memory block that can be used for
; blitter pointer registers or bitplane pointer registers

; ** do something else **

memory_free
  move.l (a7)+,a1               ; Allocated memory block
  move.l #memory_size+memory_64kb_size,d0
  jsr    _LVOFreeMem(a6)
  moveq  #0,d0                  ; Everything okay
  rts
  CNOP 0,4
memory_alloc_error
  moveq  #-1,d0                 ; Error
  rts

  END
