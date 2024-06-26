;Program compiled by Great Cow BASIC (0.98.<<>> 2021-<<>>-24 (Linux 64 bit) : Build 1005) for Microchip MPASM
;Need help? See the GCBASIC forums at http://sourceforge.net/projects/gcbasic/forums,
;check the documentation or email w_cholmondeley at users dot sourceforge dot net.

;********************************************************************************

;Chip Model: TINY85
;Assembler header file
.INCLUDE "tn85def.inc"

;SREG bit names (for AVR Assembler compatibility, GCBASIC uses different names)
#define C 0
#define H 5
#define I 7
#define N 2
#define S 4
#define T 6
#define V 3
#define Z 1

;********************************************************************************

;Set aside memory locations for variables
.EQU	COUNTERVALUE_0=96
.EQU	COUNTERVALUE_1=97
.EQU	SAVESREG=98
.EQU	SAVESYSTEMP1=99
.EQU	SAVESYSVALUECOPY=100
.EQU	SYSINTSTATESAVE0=101
.EQU	T0=102
.EQU	T1=103
.EQU	TMR0_TMP=104
.EQU	TMR1_TMP=105
.EQU	TMRNUMBER=106
.EQU	TMRPRES=107
.EQU	TMRSOURCE=108

;********************************************************************************

;Register variables
.DEF	SYSBITTEST=r5
.DEF	SYSCALCTEMPA=r22
.DEF	SYSCALCTEMPB=r28
.DEF	SYSVALUECOPY=r21
.DEF	SYSTEMP1=r0
.DEF	SYSTEMP2=r16
.DEF	SYSTEMP3=r1

;********************************************************************************

;Vectors
;Interrupt vectors
.ORG	0
	rjmp	BASPROGRAMSTART ;Reset
.ORG	1
	reti	;INT0
.ORG	2
	reti	;PCINT0
.ORG	3
	reti	;TIMER1_COMPA
.ORG	4
	rjmp	IntTIMER1_OVF ;TIMER1_OVF
.ORG	5
	rjmp	IntTIMER0_OVF ;TIMER0_OVF
.ORG	6
	reti	;EE_RDY
.ORG	7
	reti	;ANA_COMP
.ORG	8
	reti	;ADC
.ORG	9
	reti	;TIMER1_COMPB
.ORG	10
	reti	;TIMER0_COMPA
.ORG	11
	reti	;TIMER0_COMPB
.ORG	12
	reti	;WDT
.ORG	13
	reti	;USI_START
.ORG	14
	reti	;USI_OVF

;********************************************************************************

;Start of program memory page 0
.ORG	16
BASPROGRAMSTART:
;Initialise stack
	ldi	SysValueCopy,high(RAMEND)
	out	SPH, SysValueCopy
	ldi	SysValueCopy,low(RAMEND)
	out	SPL, SysValueCopy
;Call initialisation routines
	rcall	INITSYS
;Enable interrupts
	sei
	lds	SysValueCopy,SYSINTSTATESAVE0
	sbr	SysValueCopy,1<<0
	sts	SYSINTSTATESAVE0,SysValueCopy
;Automatic pin direction setting
	sbi	DDRB,1
	sbi	DDRB,0

;Start of the main program
START:
;Source:F1L6S0I6
;Source:F1L7S0I7
;Source:F1L8S0I8
;Source:F1L9S0I9
;Source:F1L10S0I10
	in	SysValueCopy,TIMSK
	sbr	SysValueCopy,1<<TOIE0
	out	TIMSK,SysValueCopy
;Source:F1L11S0I11
	in	SysValueCopy,TIMSK
	sbr	SysValueCopy,1<<TOIE1
	out	TIMSK,SysValueCopy
;Source:F1L13S0I13
	lds	SysBitTest,SYSINTSTATESAVE0
	sbrc	SysBitTest,0
	sei
;Source:F1L16S0I16
	ldi	SysValueCopy,1
	sts	TMRSOURCE,SysValueCopy
	ldi	SysValueCopy,1
	sts	TMRPRES,SysValueCopy
	rcall	INITTIMER0179
;Source:F1L17S0I17
	ldi	SysValueCopy,0
	sts	TMRNUMBER,SysValueCopy
	rcall	STARTTIMER
;Source:F1L18S0I18
	ldi	SysValueCopy,128
	out	TCNT0,SysValueCopy
;Source:F1L21S0I21
	ldi	SysValueCopy,1
	sts	TMRSOURCE,SysValueCopy
	ldi	SysValueCopy,7
	sts	TMRPRES,SysValueCopy
	rcall	INITTIMER1
;Source:F1L22S0I22
	ldi	SysValueCopy,1
	sts	TMRNUMBER,SysValueCopy
	rcall	STARTTIMER
;Source:F1L23S0I23
	ldi	SysValueCopy,6
	out	TCNT1,SysValueCopy
MAIN:
;Source:F1L26S0I26
SysDoLoop_S1:
;Source:F1L27S0I27
	in	SysValueCopy,TCNT1
	sts	T1,SysValueCopy
;Source:F1L28S0I28
	in	SysValueCopy,TCNT0
	sts	T0,SysValueCopy
;Source:F1L29S0I29
	ldi	SysCalcTempA,128
	lds	SysCalcTempB,COUNTERVALUE_0
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF1
	sbi	PORTB,0
ENDIF1:
;Source:F1L30S0I30
	lds	SysCalcTempA,COUNTERVALUE_0
	cpi	SysCalcTempA,128
	brsh	ENDIF2
	cbi	PORTB,0
ENDIF2:
;Source:F1L31S0I31
	ldi	SysCalcTempA,128
	lds	SysCalcTempB,COUNTERVALUE_1
	cp	SysCalcTempA,SysCalcTempB
	brsh	ENDIF3
	sbi	PORTB,1
ENDIF3:
;Source:F1L32S0I32
	lds	SysCalcTempA,COUNTERVALUE_1
	cpi	SysCalcTempA,128
	brsh	ENDIF4
	cbi	PORTB,1
ENDIF4:
;Source:F1L33S0I33
	rjmp	SysDoLoop_S1
SysDoLoop_E1:
;Source:F2L5S0I5
;Source:F2L25S0I18
;Source:F3L159S0I159
;Source:F3L160S0I160
;Source:F3L164S0I164
;Source:F3L170S0I170
;Source:F3L175S0I175
;Source:F3L177S0I177
;Source:F3L178S0I178
;Source:F3L179S0I179
;Source:F3L180S0I180
;Source:F3L182S0I182
;Source:F3L185S0I185
;Source:F3L186S0I186
;Source:F3L187S0I187
;Source:F3L188S0I188
;Source:F3L189S0I189
;Source:F3L190S0I190
;Source:F3L191S0I191
;Source:F3L195S0I195
;Source:F3L196S0I196
;Source:F3L197S0I197
;Source:F3L198S0I198
;Source:F3L199S0I199
;Source:F3L200S0I200
;Source:F3L201S0I201
;Source:F3L202S0I202
;Source:F3L203S0I203
;Source:F3L204S0I204
;Source:F3L205S0I205
;Source:F3L206S0I206
;Source:F3L207S0I207
;Source:F3L208S0I208
;Source:F3L209S0I209
;Source:F3L210S0I210
;Source:F3L211S0I211
;Source:F3L212S0I212
;Source:F3L213S0I213
;Source:F3L214S0I214
;Source:F3L215S0I215
;Source:F3L216S0I216
;Source:F3L217S0I217
;Source:F3L218S0I218
;Source:F3L219S0I219
;Source:F3L220S0I220
;Source:F3L221S0I221
;Source:F3L222S0I222
;Source:F3L223S0I223
;Source:F3L224S0I224
;Source:F3L225S0I225
;Source:F3L226S0I226
;Source:F3L227S0I227
;Source:F3L228S0I228
;Source:F3L229S0I229
;Source:F3L231S0I231
;Source:F3L232S0I232
;Source:F3L233S0I233
;Source:F3L234S0I234
;Source:F3L235S0I235
;Source:F3L236S0I236
;Source:F3L237S0I237
;Source:F3L238S0I238
;Source:F3L239S0I239
;Source:F3L240S0I240
;Source:F3L241S0I241
;Source:F3L242S0I242
;Source:F3L243S0I243
;Source:F3L244S0I244
;Source:F3L245S0I245
;Source:F3L246S0I246
;Source:F3L247S0I247
;Source:F3L248S0I248
;Source:F3L249S0I249
;Source:F3L250S0I250
;Source:F3L251S0I251
;Source:F3L252S0I252
;Source:F3L253S0I253
;Source:F3L254S0I254
;Source:F3L255S0I255
;Source:F3L256S0I256
;Source:F3L257S0I257
;Source:F3L258S0I258
;Source:F3L259S0I259
;Source:F3L260S0I260
;Source:F3L261S0I261
;Source:F3L262S0I262
;Source:F3L263S0I263
;Source:F3L264S0I264
;Source:F3L265S0I265
;Source:F3L268S0I268
;Source:F3L269S0I269
;Source:F3L270S0I270
;Source:F3L271S0I271
;Source:F3L272S0I272
;Source:F3L273S0I273
;Source:F3L274S0I274
;Source:F3L275S0I275
;Source:F3L276S0I276
;Source:F3L277S0I277
;Source:F3L278S0I278
;Source:F3L279S0I279
;Source:F3L280S0I280
;Source:F3L281S0I281
;Source:F3L283S0I283
;Source:F3L284S0I284
;Source:F3L285S0I285
;Source:F3L286S0I286
;Source:F3L287S0I287
;Source:F3L288S0I288
;Source:F3L289S0I289
;Source:F3L290S0I290
;Source:F3L291S0I291
;Source:F3L292S0I292
;Source:F3L293S0I293
;Source:F3L294S0I294
;Source:F3L295S0I295
;Source:F3L296S0I296
;Source:F3L297S0I297
;Source:F3L298S0I298
;Source:F3L299S0I299
;Source:F3L300S0I300
;Source:F3L301S0I301
;Source:F3L302S0I302
;Source:F3L303S0I303
;Source:F3L304S0I304
;Source:F3L305S0I305
;Source:F3L306S0I306
;Source:F3L307S0I307
;Source:F3L308S0I308
;Source:F3L309S0I309
;Source:F3L310S0I310
;Source:F3L311S0I311
;Source:F3L312S0I312
;Source:F3L313S0I313
;Source:F3L314S0I314
;Source:F3L315S0I315
;Source:F3L316S0I316
;Source:F3L317S0I317
;Source:F3L318S0I318
;Source:F3L321S0I321
;Source:F3L322S0I322
;Source:F3L323S0I323
;Source:F3L324S0I324
;Source:F3L325S0I325
;Source:F3L326S0I326
;Source:F3L327S0I327
;Source:F3L328S0I328
;Source:F3L329S0I329
;Source:F3L330S0I330
;Source:F3L331S0I331
;Source:F3L332S0I332
;Source:F3L333S0I333
;Source:F3L334S0I334
;Source:F3L335S0I335
;Source:F3L336S0I336
;Source:F3L337S0I337
;Source:F3L338S0I338
;Source:F3L339S0I339
;Source:F3L340S0I340
;Source:F3L341S0I341
;Source:F3L342S0I342
;Source:F3L343S0I343
;Source:F3L344S0I344
;Source:F3L345S0I345
;Source:F3L346S0I346
;Source:F3L347S0I347
;Source:F3L348S0I348
;Source:F3L349S0I349
;Source:F3L350S0I350
;Source:F3L351S0I351
;Source:F3L352S0I352
;Source:F3L353S0I353
;Source:F3L354S0I354
;Source:F3L355S0I355
;Source:F3L2503S0I40
;Source:F3L2504S0I41
;Source:F4L133S0I133
;Source:F4L134S0I134
;Source:F4L135S0I135
;Source:F4L136S0I136
;Source:F4L138S0I138
;Source:F4L2184S0I1992
;Source:F4L2472S0I101
;Source:F4L2696S0I36
;Source:F4L5249S0I160
;Source:F5L59S0I59
;Source:F5L60S0I60
;Source:F5L61S0I61
;Source:F5L64S0I64
;Source:F5L65S0I65
;Source:F5L68S0I68
;Source:F5L70S0I70
;Source:F5L119S0I119
;Source:F6L166S0I84
;Source:F7L28S0I28
;Source:F7L29S0I29
;Source:F7L57S0I23
;Source:F8L43S0I43
;Source:F8L44S0I44
;Source:F8L45S0I45
;Source:F8L46S0I46
;Source:F8L47S0I47
;Source:F8L48S0I48
;Source:F8L49S0I49
;Source:F8L51S0I51
;Source:F8L54S0I54
;Source:F8L55S0I55
;Source:F8L56S0I56
;Source:F8L249S0I21
;Source:F10L66S0I66
;Source:F10L69S0I69
;Source:F10L70S0I70
;Source:F10L74S0I74
;Source:F10L76S0I76
;Source:F10L79S0I79
;Source:F10L80S0I80
;Source:F10L82S0I82
;Source:F10L84S0I84
;Source:F10L87S0I87
;Source:F10L89S0I89
;Source:F10L92S0I92
;Source:F10L95S0I95
;Source:F10L97S0I97
;Source:F10L99S0I99
;Source:F10L101S0I101
;Source:F10L104S0I104
;Source:F10L106S0I106
;Source:F10L108S0I108
;Source:F10L111S0I111
;Source:F10L114S0I114
;Source:F10L117S0I117
;Source:F10L120S0I120
;Source:F10L121S0I121
;Source:F10L123S0I123
;Source:F10L124S0I124
;Source:F10L125S0I125
;Source:F10L127S0I127
;Source:F10L128S0I128
;Source:F10L130S0I130
;Source:F10L131S0I131
;Source:F10L134S0I134
;Source:F10L135S0I135
;Source:F10L138S0I138
;Source:F10L142S0I142
;Source:F10L143S0I143
;Source:F10L146S0I146
;Source:F10L149S0I149
;Source:F11L36S0I36
;Source:F11L37S0I37
;Source:F11L38S0I38
;Source:F11L39S0I39
;Source:F11L40S0I40
;Source:F11L41S0I41
;Source:F11L42S0I42
;Source:F11L43S0I43
;Source:F12L209S0I209
;Source:F12L223S0I223
;Source:F12L269S0I269
;Source:F12L270S0I270
;Source:F12L271S0I271
;Source:F12L272S0I272
;Source:F12L273S0I273
;Source:F12L337S0I337
;Source:F12L338S0I338
;Source:F12L339S0I339
;Source:F12L340S0I340
;Source:F12L341S0I341
;Source:F12L342S0I342
;Source:F12L344S0I344
;Source:F12L345S0I345
;Source:F12L346S0I346
;Source:F12L347S0I347
;Source:F12L348S0I348
;Source:F12L349S0I349
;Source:F12L351S0I351
;Source:F12L352S0I352
;Source:F12L353S0I353
;Source:F12L354S0I354
;Source:F12L355S0I355
;Source:F12L356S0I356
;Source:F12L358S0I358
;Source:F12L359S0I359
;Source:F12L360S0I360
;Source:F12L361S0I361
;Source:F12L362S0I362
;Source:F12L363S0I363
;Source:F12L365S0I365
;Source:F12L366S0I366
;Source:F12L367S0I367
;Source:F12L368S0I368
;Source:F12L369S0I369
;Source:F12L370S0I370
;Source:F12L372S0I372
;Source:F12L373S0I373
;Source:F12L374S0I374
;Source:F12L375S0I375
;Source:F12L376S0I376
;Source:F12L377S0I377
;Source:F12L382S0I382
;Source:F12L383S0I383
;Source:F12L384S0I384
;Source:F12L386S0I386
;Source:F12L387S0I387
;Source:F12L388S0I388
;Source:F12L389S0I389
;Source:F12L391S0I391
;Source:F12L393S0I393
;Source:F12L395S0I395
;Source:F12L396S0I396
;Source:F12L397S0I397
;Source:F12L398S0I398
;Source:F12L399S0I399
;Source:F12L400S0I400
;Source:F12L401S0I401
;Source:F12L402S0I402
;Source:F12L403S0I403
;Source:F12L404S0I404
;Source:F12L405S0I405
;Source:F12L406S0I406
;Source:F12L407S0I407
;Source:F12L408S0I408
;Source:F12L409S0I409
;Source:F12L410S0I410
;Source:F12L412S0I412
;Source:F12L413S0I413
;Source:F12L414S0I414
;Source:F12L415S0I415
;Source:F12L416S0I416
;Source:F12L417S0I417
;Source:F12L418S0I418
;Source:F12L419S0I419
;Source:F12L420S0I420
;Source:F12L421S0I421
;Source:F12L422S0I422
;Source:F12L423S0I423
;Source:F12L424S0I424
;Source:F12L425S0I425
;Source:F12L426S0I426
;Source:F12L427S0I427
;Source:F12L431S0I431
;Source:F12L432S0I432
;Source:F12L433S0I433
;Source:F12L434S0I434
;Source:F12L435S0I435
;Source:F12L436S0I436
;Source:F12L437S0I437
;Source:F12L438S0I438
;Source:F12L439S0I439
;Source:F12L440S0I440
;Source:F12L441S0I441
;Source:F12L442S0I442
;Source:F12L443S0I443
;Source:F12L444S0I444
;Source:F12L445S0I445
;Source:F12L446S0I446
;Source:F12L450S0I450
;Source:F12L451S0I451
;Source:F12L452S0I452
;Source:F12L453S0I453
;Source:F12L454S0I454
;Source:F12L455S0I455
;Source:F12L456S0I456
;Source:F12L457S0I457
;Source:F12L458S0I458
;Source:F12L459S0I459
;Source:F12L460S0I460
;Source:F12L461S0I461
;Source:F12L462S0I462
;Source:F12L522S0I522
;Source:F12L523S0I523
;Source:F12L525S0I525
;Source:F12L526S0I526
;Source:F12L528S0I528
;Source:F12L529S0I529
;Source:F12L531S0I531
;Source:F12L532S0I532
;Source:F12L534S0I534
;Source:F12L535S0I535
;Source:F12L537S0I537
;Source:F12L538S0I538
;Source:F12L550S0I550
;Source:F12L551S0I551
;Source:F12L552S0I552
;Source:F12L553S0I553
;Source:F12L554S0I554
;Source:F12L555S0I555
;Source:F12L556S0I556
;Source:F12L557S0I557
;Source:F12L560S0I560
;Source:F12L561S0I561
;Source:F12L562S0I562
;Source:F12L563S0I563
;Source:F12L566S0I566
;Source:F12L567S0I567
;Source:F12L568S0I568
;Source:F12L569S0I569
;Source:F12L572S0I572
;Source:F12L573S0I573
;Source:F12L574S0I574
;Source:F12L575S0I575
;Source:F12L578S0I578
;Source:F12L579S0I579
;Source:F12L580S0I580
;Source:F12L581S0I581
;Source:F12L692S0I692
;Source:F12L693S0I693
;Source:F12L694S0I694
;Source:F12L695S0I695
;Source:F12L698S0I698
;Source:F12L699S0I699
;Source:F12L700S0I700
;Source:F12L701S0I701
;Source:F13L82S0I82
;Source:F13L83S0I83
;Source:F13L84S0I84
;Source:F13L85S0I85
;Source:F13L88S0I88
;Source:F13L89S0I89
;Source:F13L90S0I90
;Source:F13L91S0I91
;Source:F13L92S0I92
;Source:F13L95S0I95
;Source:F13L96S0I96
;Source:F13L98S0I98
;Source:F13L100S0I100
;Source:F13L101S0I101
;Source:F13L102S0I102
;Source:F13L103S0I103
;Source:F13L104S0I104
;Source:F13L105S0I105
;Source:F13L106S0I106
;Source:F13L107S0I107
;Source:F13L108S0I108
;Source:F14L60S0I60
;Source:F14L61S0I61
;Source:F14L62S0I62
;Source:F14L63S0I63
;Source:F14L64S0I64
;Source:F14L65S0I65
;Source:F14L66S0I66
;Source:F14L70S0I70
;Source:F14L71S0I71
;Source:F14L72S0I72
;Source:F14L73S0I73
;Source:F14L76S0I76
;Source:F14L77S0I77
;Source:F14L78S0I78
;Source:F14L79S0I79
;Source:F14L80S0I80
;Source:F14L81S0I81
;Source:F14L82S0I82
;Source:F14L83S0I83
;Source:F14L84S0I84
;Source:F14L87S0I87
;Source:F14L617S0I11
;Source:F15L57S0I57
;Source:F15L64S0I64
;Source:F15L66S0I66
;Source:F15L67S0I67
;Source:F15L68S0I68
;Source:F15L69S0I69
;Source:F15L70S0I70
;Source:F15L71S0I71
;Source:F15L72S0I72
;Source:F16L22S0I22
;Source:F16L25S0I25
;Source:F17L299S0I60
;Source:F18L116S0I116
;Source:F18L120S0I120
;Source:F18L123S0I123
;Source:F19L137S0I137
;Source:F19L138S0I138
;Source:F19L139S0I139
;Source:F19L140S0I140
;Source:F19L144S0I144
;Source:F19L145S0I145
;Source:F19L146S0I146
;Source:F19L147S0I147
;Source:F19L149S0I149
;Source:F19L150S0I150
;Source:F19L151S0I151
;Source:F19L156S0I156
;Source:F19L158S0I158
;Source:F19L159S0I159
;Source:F20L68S0I68
;Source:F20L96S0I96
;Source:F20L99S0I99
;Source:F20L100S0I100
;Source:F20L102S0I102
;Source:F20L103S0I103
;Source:F20L104S0I104
;Source:F20L105S0I105
;Source:F20L106S0I106
;Source:F20L108S0I108
;Source:F20L109S0I109
;Source:F20L110S0I110
;Source:F20L111S0I111
;Source:F20L414S0I19
;Source:F20L501S0I57
;Source:F20L715S0I17
;Source:F20L716S0I18
;Source:F20L717S0I19
;Source:F20L719S0I21
;Source:F20L720S0I22
;Source:F20L721S0I23
;Source:F20L722S0I24
;Source:F20L723S0I25
;Source:F20L724S0I26
;Source:F20L725S0I27
;Source:F20L726S0I28
;Source:F20L727S0I29
;Source:F20L729S0I31
;Source:F20L730S0I32
;Source:F20L731S0I33
;Source:F20L732S0I34
;Source:F20L733S0I35
;Source:F20L734S0I36
;Source:F20L735S0I37
;Source:F20L736S0I38
;Source:F20L737S0I39
;Source:F20L738S0I40
;Source:F20L740S0I42
;Source:F20L743S0I45
;Source:F20L744S0I46
;Source:F20L745S0I47
;Source:F20L747S0I49
;Source:F21L69S0I69
;Source:F21L273S0I20
;Source:F21L356S0I53
;Source:F21L423S0I32
;Source:F21L424S0I33
;Source:F21L425S0I34
;Source:F21L427S0I36
;Source:F21L428S0I37
;Source:F21L429S0I38
;Source:F21L430S0I39
;Source:F21L431S0I40
;Source:F21L432S0I41
;Source:F21L433S0I42
;Source:F21L434S0I43
;Source:F21L435S0I44
;Source:F21L437S0I46
;Source:F21L438S0I47
;Source:F21L439S0I48
;Source:F21L440S0I49
;Source:F21L441S0I50
;Source:F21L442S0I51
;Source:F21L443S0I52
;Source:F21L444S0I53
;Source:F21L445S0I54
;Source:F21L446S0I55
;Source:F21L448S0I57
;Source:F21L451S0I60
;Source:F21L452S0I61
;Source:F21L453S0I62
;Source:F21L455S0I64
;Source:F22L48S0I48
;Source:F22L49S0I49
;Source:F22L50S0I50
;Source:F22L51S0I51
;Source:F22L52S0I52
;Source:F22L53S0I53
;Source:F22L54S0I54
;Source:F22L55S0I55
;Source:F22L56S0I56
;Source:F22L57S0I57
;Source:F22L58S0I58
;Source:F22L59S0I59
;Source:F22L63S0I63
;Source:F22L64S0I64
;Source:F23L67S0I67
;Source:F23L68S0I68
;Source:F23L69S0I69
;Source:F23L70S0I70
;Source:F24L145S0I145
;Source:F24L146S0I146
;Source:F24L147S0I147
;Source:F25L30S0I30
;Source:F25L31S0I31
;Source:F25L32S0I32
;Source:F25L33S0I33
;Source:F25L34S0I34
;Source:F25L35S0I35
;Source:F25L36S0I36
;Source:F25L37S0I37
;Source:F25L38S0I38
;Source:F25L39S0I39
;Source:F25L42S0I42
;Source:F25L43S0I43
;Source:F25L45S0I45
;Source:F25L48S0I48
;Source:F25L49S0I49
;Source:F25L50S0I50
;Source:F25L51S0I51
;Source:F25L54S0I54
;Source:F25L55S0I55
;Source:F25L56S0I56
;Source:F25L58S0I58
;Source:F25L59S0I59
;Source:F25L60S0I60
BASPROGRAMEND:
	sleep
	rjmp	BASPROGRAMEND

;********************************************************************************

INCCOUNTER_0:
;Source:F1L37S1I2
	lds	SysTemp1,COUNTERVALUE_0
	inc	SysTemp1
	sts	COUNTERVALUE_0,SysTemp1
	ret

;********************************************************************************

INCCOUNTER_1:
;Source:F1L41S2I1
	ldi	SysValueCopy,6
	out	TCNT1,SysValueCopy
;Source:F1L42S2I2
	lds	SysTemp1,COUNTERVALUE_1
	inc	SysTemp1
	sts	COUNTERVALUE_1,SysTemp1
	ret

;********************************************************************************

INITSYS:
;Source:F13L1248S195I1094
	ldi	SysValueCopy,0
	out	PORTB,SysValueCopy
	ret

;********************************************************************************

INITTIMER0179:
;Source:F12L1523S179I112
	lds	SysCalcTempA,TMRSOURCE
	cpi	SysCalcTempA,2
	brne	ENDIF7
;Source:F12L1524S179I113
	ldi	SysValueCopy,7
	sts	TMRPRES,SysValueCopy
;Source:F12L1525S179I114
ENDIF7:
;Source:F12L1532S179I121
	lds	SysValueCopy,TMRPRES
	sts	TMR0_TMP,SysValueCopy
	ret

;********************************************************************************

INITTIMER1:
;Source:F12L1664S180I127
	lds	SysValueCopy,TMRPRES
	sts	TMR1_TMP,SysValueCopy
;Source:F12L1665S180I128
	lds	SysCalcTempA,TMRSOURCE
	cpi	SysCalcTempA,2
	brne	ENDIF8
;Source:F12L1666S180I129
	ldi	SysValueCopy,7
	sts	TMR1_TMP,SysValueCopy
;Source:F12L1667S180I130
ENDIF8:
	ret

;********************************************************************************

IntTIMER0_OVF:
	rcall	SysIntContextSave
	rcall	INCCOUNTER_0
	in	SysValueCopy,TIFR
	cbr	SysValueCopy,1<<TOV0
	out	TIFR,SysValueCopy
	rjmp	SysIntContextRestore

;********************************************************************************

IntTIMER1_OVF:
	rcall	SysIntContextSave
	rcall	INCCOUNTER_1
	in	SysValueCopy,TIFR
	cbr	SysValueCopy,1<<TOV1
	out	TIFR,SysValueCopy
	rjmp	SysIntContextRestore

;********************************************************************************

STARTTIMER:
;Source:F12L793S173I89
	lds	SysCalcTempA,TMRNUMBER
	tst	SysCalcTempA
	brne	ENDIF5
;Source:F12L794S173I90
	ldi	SysTemp2,248
	in	SysTemp3,TCCR0B
	and	SysTemp3,SysTemp2
	mov	SysTemp1,SysTemp3
	lds	SysTemp3,TMR0_TMP
	or	SysTemp3,SysTemp1
	out	TCCR0B,SysTemp3
;Source:F12L795S173I91
ENDIF5:
;Source:F12L811S173I107
	lds	SysCalcTempA,TMRNUMBER
	cpi	SysCalcTempA,1
	brne	ENDIF6
;Source:F12L812S173I108
	ldi	SysTemp2,240
	in	SysTemp3,TCCR1
	and	SysTemp3,SysTemp2
	mov	SysTemp1,SysTemp3
	lds	SysTemp3,TMR1_TMP
	or	SysTemp3,SysTemp1
	out	TCCR1,SysTemp3
;Source:F12L813S173I109
ENDIF6:
	ret

;********************************************************************************

SysIntContextRestore:
;Restore registers
	lds	SysTemp1,SaveSysTemp1
;Restore SREG
	lds	SysValueCopy,SaveSREG
	out	SREG,SysValueCopy
;Restore SysValueCopy
	lds	SysValueCopy,SaveSysValueCopy
	reti

;********************************************************************************

SysIntContextSave:
;Store SysValueCopy
	sts	SaveSysValueCopy,SysValueCopy
;Store SREG
	in	SysValueCopy,SREG
	sts	SaveSREG,SysValueCopy
;Store registers
	sts	SaveSysTemp1,SysTemp1
	ret

;********************************************************************************


