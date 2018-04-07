;
; Copyright (C) 2015-2018 Night Dive Studios, LLC.
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;
;	File:		LinearLoop.s
;
;	Contains:	PowerPC assembly routine to handle lit/clut/transparent linear mappers.
;
;	Written by:	Mark Adams
;
; 	PPCAsm LinearLoop.s -o LinearLoop.s.o
;

	; global variables
	import grd_canvas
	
	; external functions
	import .fix_div_asm
	import .fix_mul_asm
	import .fix_mul_asm_safe
	
	toc
		tc grd_canvas[TC], grd_canvas

	csect
	
	
;---------------------------------------------------
; int Handle_Lit_Lin_Loop_PPC();  C++ routine
;---------------------------------------------------
		EXPORT	.Handle_Lit_Lin_Loop_PPC
;		EXPORT	.Handle_Lit_Lin_Loop_PPC__FlllllP18grs_tmap_loop_infoPUcPUclllPUcUcUl
	
	.Handle_Lit_Lin_Loop_PPC:
;	.Handle_Lit_Lin_Loop_PPC__FlllllP18grs_tmap_loop_infoPUcPUclllPUcUcUl:
		mflr     r0
		stmw     r13,-76(SP)
		stw      r0,8(SP)
		stwu     SP,-128(SP)
		mr       r27,r3
		mr       r28,r4
		mr       r24,r5
		mr       r25,r6
		mr       r31,r8
		mr       r16,r9
		mr       r19,r10
		mr		 r10,r7
		lwz      r29,188(SP)
		lwz      r26,192(SP)
		lwz      r20,196(SP)
		lbz      r21,203(SP)
		lwz      r22,204(SP)
		lwz      r3,0(r31)
		lwz      r4,4(r31)
		lwz      r13,28(r31)
		lwz		 r11,36(r31)
		lwz		 r15,40(r31)
		lwz      r14,64(r31)
		lwz		 r12,72(r31)
		add      r4,r4,r3
		stw      r4,4(r31)
		
OuterLoop:
		addis    r5,r13,1
		addis    r6,r14,1
		subi     r5,r5,1
		subi     r6,r6,1
		clrrwi   r5,r5,16
		clrrwi   r6,r6,16
		sub.     r30,r6,r5
		ble      CheckDMinus
		
		lis      r3,256
		mr       r4,r10
		bl       .fix_div_asm
		mr       r30,r3
		
		mr       r3,r26
		mr       r4,r30
		bl       .fix_mul_asm_safe
		addi     r3,r3,255
		srawi    r26,r3,8
		
		srawi    r30,r30,8
		
		mr       r3,r24
		mr       r4,r30
		bl       .fix_mul_asm_safe
		mr       r24,r3
		
		mr       r3,r25
		mr       r4,r30
		bl       .fix_mul_asm_safe
		mr       r25,r3
		
		addis    r8,r13,1
		subi     r8,r8,1
		clrrwi   r8,r8,16
		sub      r30,r8,r13
		
		mr       r3,r24
		mr       r4,r30
		bl       .fix_mul_asm
		add      r27,r27,r3
		
		mr       r3,r25
		mr       r4,r30
		bl       .fix_mul_asm
		add      r28,r28,r3
		
		mr       r3,r26
		mr       r4,r30
		bl       .fix_mul_asm
		add      r29,r29,r3
		
		addis    r18,r13,1
		addis    r17,r14,1
		subi     r18,r18,1
		subi     r17,r17,1
		srawi    r18,r18,16
		srawi    r17,r17,16
#		extsh    r18,r9
#		extsh    r17,r10
		add      r23,r16,r18
		sub.     r30,r17,r18
		
		mtctr	 r30
		beq-	 LoopSkip		; skip if 0 count
		addi	 r23,r23,-1

InnerLoop:
		rlwinm   r7,r29,24,16,23
		srawi    r6,r27,16
		srawi    r3,r28,16
		clrlwi   r4,r21,24
		slw      r3,r3,r4
		add      r6,r6,r3
		and      r6,r6,r22
		add      r27,r27,r24
		lbzx     r6,r19,r6
		add      r28,r28,r25
		add      r6,r6,r20
		add      r29,r29,r26
		lbzx     r7,r7,r6
		stbu     r7,1(r23)
		bdnz     InnerLoop

LoopSkip:
		lwz      r6,52(r31)
		lwz      r8,88(r31)
		add      r11,r11,r6
		mr       r27,r11
		
		add      r12,r12,r8
		
		sub      r24,r12,r27
		
		lwz      r4,56(r31)
		add      r15,r15,r4
		mr       r28,r15
		
		lwz      r3,92(r31)
		lwz      r4,76(r31)
		add      r4,r4,r3
		stw      r4,76(r31)
		sub      r25,r4,r28
		
		lwz      r6,60(r31)
		lwz      r29,44(r31)
		add      r29,r29,r6
		stw      r29,44(r31)
		
		lwz      r8,96(r31)
		lwz      r9,80(r31)
		add      r9,r9,r8
		stw      r9,80(r31)
		
		sub      r26,r9,r29
		
		lwz      r3,48(r31)
		lwz      r4,84(r31)
		add      r13,r13,r3
		
		add      r14,r14,r4
		sub      r10,r14,r13

		
		lwz      r7,184(SP)
		lwz      r8,0(r31)
		addic.   r8,r8,-1
		stw      r8,0(r31)
		add      r16,r16,r7
		
		bgt+     OuterLoop

		li       r3,0

Done:
		stw      r13,28(r31)
		stw		 r11,36(r31)
		stw		 r15,40(r31)
		stw      r14,64(r31)
		stw		 r12,72(r31)
		lwz      r0,136(SP)
		addi     SP,SP,128
		mtlr     r0
		lmw      r13,-76(SP)
		blr

CheckDMinus:
		cmpwi    r30,0
		bge+     LoopSkip
		li       r3,1
		b        Done


;---------------------------------------------------
; int Handle_LinClut_Loop_PPC();  C++ routine
;---------------------------------------------------
		EXPORT	.Handle_LinClut_Loop_PPC
;		EXPORT	.Handle_LinClut_Loop_PPC__FlllllP18grs_tmap_loop_infoPUcPUclPUcUcUl
	
	.Handle_LinClut_Loop_PPC:
;	.Handle_LinClut_Loop_PPC__FlllllP18grs_tmap_loop_infoPUcPUclPUcUcUl:
		mflr     r0
		stmw     r13,-64(SP)
		stw      r0,8(SP)
		stwu     SP,-128(SP)
		mr       r28,r3
		mr       r29,r4
		mr       r23,r5
		mr       r24,r6
		mr       r16,r7
		mr       r25,r8
		mr       r17,r9
		mr       r18,r10
		lwz      r19,188(SP)
		lbz      r20,195(SP)
		lwz      r21,196(SP)
		lwz      r15,0(r25)
		lwz      r30,28(r25)
		lwz      r14,36(r25)
		lwz      r10,40(r25)
		lwz      r27,64(r25)
		lwz      r13,72(r25)
		lwz      r11,76(r25)
		lwz      r4,4(r25)
		add      r4,r4,r15
		stw      r4,4(r25)
		
C_OuterLoop:
		addis    r5,r30,1
		subi     r5,r5,1
		clrrwi   r5,r5,16
		addis    r6,r27,1
		subi     r6,r6,1
		clrrwi   r6,r6,16
		sub.     r31,r6,r5
		ble      C_CheckDMinus
		
		addis    r7,r30,1
		subi     r7,r7,1
		clrrwi   r7,r7,16
		sub      r31,r7,r30
		lis      r3,1
		mr       r4,r16
		bl       .fix_div_asm
		mr       r26,r3
		
		mr       r3,r23
		mr       r4,r26
		bl       .fix_mul_asm_safe
		mr       r23,r3
		
		mr       r3,r24
		mr       r4,r26
		bl       .fix_mul_asm_safe
		mr       r24,r3
		
		mr       r3,r23
		mr       r4,r31
		bl       .fix_mul_asm
		add      r28,r28,r3
		
		mr       r3,r24
		mr       r4,r31
		bl       .fix_mul_asm
		add      r29,r29,r3
		
		addis    r8,r30,1
		addis    r7,r27,1
		addis    r9,r30,1
		subi     r8,r8,1
		subi     r9,r9,1
		subi     r7,r7,1
		srawi    r8,r8,16
		srawi    r9,r9,16
		srawi    r7,r7,16
		add      r22,r17,r8
		sub.     r31,r7,r9
		
		mtctr	 r31
		beq-	 C_LoopSkip
		addi	 r22,r22,-1
		
C_InnerLoop:
		srawi    r6,r28,16
		srawi    r5,r29,16
		clrlwi   r3,r20,24
		slw      r5,r5,r3
		add      r6,r6,r5
		add      r28,r28,r23
		and      r6,r6,r21
		lbzx     r6,r18,r6
		add      r29,r29,r24
		lbzx     r6,r19,r6
		stbu     r6,1(r22)
		bdnz     C_InnerLoop

C_LoopSkip:
		lwz      r5,52(r25)
		lwz      r7,88(r25)
		add      r14,r14,r5
		mr       r28,r14
		
		add      r13,r13,r7
		sub      r23,r13,r28
		
		lwz      r3,56(r25)
		lwz      r4,92(r25)
		add      r29,r10,r3
		mr		 r10,r29
		
		add      r11,r11,r4
		sub      r24,r11,r29
		
		lwz      r5,48(r25)
		lwz      r6,84(r25)
		add      r30,r30,r5
		
		add      r27,r27,r6
		sub      r16,r27,r30
		
		addic.   r15,r15,-1		

		lwz      r7,184(SP)
		add      r17,r17,r7
		
		bgt      C_OuterLoop
		
		stw      r30,28(r25)
		stw      r14,36(r25)
		stw      r10,40(r25)
		stw      r27,64(r25)
		stw      r13,72(r25)
		stw      r11,76(r25)
		
		li       r3,0
		
C_Done:
		lwz      r0,136(SP)
		addi     SP,SP,128
		mtlr     r0
		lmw      r13,-76(SP)
		blr
		
C_CheckDMinus:
		cmpwi    r31,0
		bge+     C_LoopSkip
		li       r3,1
		b        C_Done



;---------------------------------------------------
; int Handle_TLit_Lin_Loop2_PPC();  C++ routine
;---------------------------------------------------
		EXPORT	.Handle_TLit_Lin_Loop2_PPC
;		EXPORT	.Handle_TLit_Lin_Loop2_PPC__FlllllP18grs_tmap_loop_infoPUcPUclllPUcUcUl
	
	.Handle_TLit_Lin_Loop2_PPC:
;	.Handle_TLit_Lin_Loop2_PPC__FlllllP18grs_tmap_loop_infoPUcPUclllPUcUcUl:
		mflr     r0
		stmw     r16,-64(SP)
		stw      r0,8(SP)
		stwu     SP,-128(SP)
		mr       r27,r3
		mr       r28,r4
		mr       r22,r5
		mr       r23,r6
		stw      r7,168(SP)
		mr       r26,r8
		stw      r9,176(SP)
		mr       r18,r10
		lwz      r29,188(SP)
		lwz      r24,192(SP)
		lwz      r19,196(SP)
		lbz      r20,203(SP)
		lwz      r21,204(SP)
		lwz      r17,28(r26)
		lwz      r16,64(r26)
		lwz      r3,0(r26)
		lwz      r4,4(r26)
		add      r4,r4,r3
		stw      r4,4(r26)
		
T_OuterLoop:
		addis    r5,r17,1
		subi     r5,r5,1
		clrrwi   r5,r5,16
		addis    r6,r16,1
		subi     r6,r6,1
		clrrwi   r6,r6,16
		sub.     r30,r6,r5
		ble      T_CheckDMinus
		addis    r7,r17,1
		subi     r7,r7,1
		clrrwi   r7,r7,16
		sub      r30,r7,r17
		lis      r3,256
		lwz      r4,168(SP)
		bl       .fix_div_asm
		mr       r31,r3
		mr       r3,r24
		mr       r4,r31
		bl       .fix_mul_asm_safe
		addi     r3,r3,255
		
		srawi    r24,r3,8
		srawi    r31,r31,8
		mr       r3,r22
		mr       r4,r31
		bl       .fix_mul_asm_safe
		mr       r22,r3
		
		mr       r3,r23
		mr       r4,r31
		bl       .fix_mul_asm_safe
		mr       r23,r3
		
		mr       r3,r22
		mr       r4,r30
		bl       .fix_mul_asm
		add      r27,r27,r3
		
		mr       r3,r23
		mr       r4,r30
		bl       .fix_mul_asm
		add      r28,r28,r3
		
		mr       r3,r24
		mr       r4,r30
		bl       .fix_mul_asm
		add      r29,r29,r3
		
		addis    r8,r17,1
		addis    r9,r16,1
		subi     r8,r8,1
		srawi    r9,r9,16
		srawi    r8,r8,16
		subi     r9,r9,1
#		extsh    r8,r8
		stw      r8,60(SP)
#		extsh    r9,r9
		stw      r9,56(SP)
		
		lwz      r12,60(SP)
		lwz      r3,56(SP)
		sub.     r30,r3,r12

		lwz      r10,176(SP)
		lwz      r11,60(SP)
		add      r25,r10,r11

		beq		 T_LoopSkip	

		mtctr	 r30
		addi	 r25,r25,-1
		
T_InnerLoop:
		srawi    r4,r27,16
		srawi    r5,r28,16
		clrlwi   r6,r20,24
		slw      r5,r5,r6
		add      r4,r4,r5
		and      r31,r4,r21
		lbzx     r31,r18,r31
		rlwinm   r7,r29,24,16,23
		cmpwi    r31,0
		add      r7,r7,r19
		beq-     AssumeSkip
AssumeDraw:
		add      r27,r27,r22
		lbzx     r7,r31,r7
		add      r28,r28,r23
		add      r29,r29,r24
		stbu     r7,1(r25)
Skip_Pix:
		bdnz     T_InnerLoop
		b 		 T_LoopSkip

T_SkipInnerLoop:	
		srawi    r4,r27,16
		srawi    r5,r28,16
		clrlwi   r6,r20,24
		slw      r5,r5,r6
		add      r4,r4,r5
		and      r31,r4,r21
		lbzx     r31,r18,r31
		rlwinm   r7,r29,24,16,23
		cmpwi    r31,0
		add      r7,r7,r19
		bne-     AssumeDraw
		
AssumeSkip:
		add      r27,r27,r22
		add      r28,r28,r23
		add      r29,r29,r24
		addi	 r25,r25,1
		bdnz     T_SkipInnerLoop
		
T_LoopSkip:
		lwz      r8,52(r26)
		lwz      r9,36(r26)
		add      r9,r9,r8
		stw      r9,36(r26)
		mr       r27,r9
		lwz      r10,88(r26)
		lwz      r11,72(r26)
		add      r11,r11,r10
		stw      r11,72(r26)
		lwz      r12,72(r26)
		sub      r22,r12,r27
		lwz      r3,56(r26)
		lwz      r4,40(r26)
		add      r4,r4,r3
		stw      r4,40(r26)
		mr       r28,r4
		lwz      r5,92(r26)
		lwz      r6,76(r26)
		add      r6,r6,r5
		stw      r6,76(r26)
		lwz      r7,76(r26)
		sub      r23,r7,r28
		lwz      r8,60(r26)
		lwz      r9,44(r26)
		add      r9,r9,r8
		stw      r9,44(r26)
		mr       r29,r9
		lwz      r10,96(r26)
		lwz      r11,80(r26)
		add      r11,r11,r10
		stw      r11,80(r26)
		lwz      r12,80(r26)
		sub      r24,r12,r29
		lwz      r3,48(r26)
		add      r17,r17,r3
		lwz      r4,84(r26)
		add      r16,r16,r4
		sub      r5,r16,r17
		stw      r5,168(SP)
		lwz      r6,184(SP)
		lwz      r7,176(SP)
		add      r7,r7,r6
		stw      r7,176(SP)
		lwz      r8,0(r26)
		subi     r8,r8,1
		stw      r8,0(r26)
		cmpwi    r8,0
		bgt      T_OuterLoop
		
		stw      r17,28(r26)
		stw      r16,64(r26)
		
		li       r3,0
T_Done:
		lwz      r0,136(SP)
		addi     SP,SP,128
		mtlr     r0
		lmw      r16,-64(SP)
		blr
		
T_CheckDMinus:
		cmpwi    r30,0
		bge      T_LoopSkip
		li       r3,1
		b        T_Done

