	ORG	$9000
	bra	APT3INIT
	bra	APT3INIT
	bra	APL

	DC.B	'SNDH'
	DC.B	'HDNS'

INCW:
	move.l	a6,-(sp)
	move.l	sp,a6
	move.l	8(a6),a2
	move.l	8(a6),a3
	move.w	(a3),d2
	and.l	#65535,d2
	add.l	12(a6),d2
	move.w	d2,(a2)
	unlk	a6
	move.l	(sp)+,a0
	add.l	#8,sp
	move.l	a0,-(sp)
	rts
AABS:
	move.l	a6,-(sp)
	move.l	sp,a6
	sub.l	#4,sp
	move.l	8(a6),d0
	tst.l	d0
	bpl	noneg
	neg.l	d0
noneg:
	move.l	d0,-4(a6)
	move.l	-4(a6),d0
	unlk	a6
	move.l	(sp)+,a0
	add.l	#4,sp
	move.l	a0,-(sp)
	rts
INCI:
	move.l	a6,-(sp)
	move.l	sp,a6
	move.l	8(a6),a2
	move.l	8(a6),a3
	move.w	(a3),d2
	ext.l	d2
	add.l	12(a6),d2
	move.w	d2,(a2)
	unlk	a6
	move.l	(sp)+,a0
	add.l	#8,sp
	move.l	a0,-(sp)
	rts
INCB:
	move.l	a6,-(sp)
	move.l	sp,a6
	move.l	8(a6),a2
	move.l	8(a6),a3
	move.b	(a3),d2
	and.l	#255,d2
	add.l	12(a6),d2
	move.b	d2,(a2)
	unlk	a6
	move.l	(sp)+,a0
	add.l	#8,sp
	move.l	a0,-(sp)
	rts
INCS:
	move.l	a6,-(sp)
	move.l	sp,a6
	move.l	8(a6),a2
	move.l	8(a6),a3
	move.b	(a3),d2
	ext.w	d2
	ext.l	d2
	add.l	12(a6),d2
	move.b	d2,(a2)
	unlk	a6
	move.l	(sp)+,a0
	add.l	#8,sp
	move.l	a0,-(sp)
	rts
