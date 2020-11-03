;ACME 0.95.6
    !cpu 6510
    ;!to "superpad64.prg", cbm
    basicstart = $0801

; BASIC header
    * = basicstart
    !word line2 
    !word 10            ; Line number
    !byte $9e           ; SYS
    !byte '0' + start % 10000 / 1000
    !byte '0' + start %  1000 /  100
    !byte '0' + start %   100 /   10
    !byte '0' + start %    10
    !byte $00           ; end of line
line2
    !byte $00, $00      ; end of basic

; 'pads' stores the button state of each controller.
; Low Byte  = Cursor Up, C-Down. C-Left, C-Right, A, X, L, R
; High Byte = x, x, x, x, B, Y, Select, Start
pads 
    !word 0,0,0,0,0,0,0,0

tmp = $02
scn = $FC
tmp16 = $39

; Kernal functions
SCINIT = $FF81
CHROUT = $FFD2

; Register definitions
CIA2_PRA = $DD00
CIA2_PRB = $DD01
CIA2_DDRA = $DD02
CIA2_DDRB = $DD03

; Output position
SCREEN_POS = 1024 + 9 * 40 + 6  ; 10th line


text
    !pet "superpad64 controller test",13, 13
    !pet "        s         ",13
    !pet "        es   r    ",13
    !pet "        lt dli    ",13
    !pet "        ea oeg    ",13
    !pet "        cruwfh    ",13
    !pet "      byttpnttaxlr",13,13
    !pet "pad 1",13
    !pet "pad 2",13
    !pet "pad 3",13
    !pet "pad 4",13
    !pet "pad 5",13
    !pet "pad 6",13
    !pet "pad 7",13
    !pet "pad 8",13
    !by 0


start

    jsr sp64_init       
    jsr SCINIT      ; Clear screen

    ; Print Menu Text
    ldy #0
load
    lda text,y
    beq +
    jsr CHROUT
    iny
    bne load
    inc load+2
    bne load
+


    
mainloop

    ; ============= Read ===============    
    lda #12
    jsr sp64_read

    ; ============= Output ===============  
    jsr output


    jmp mainloop
    rts ; never reached



; === Initialization ===
sp64_init
    lda #0
    sta CIA2_DDRB   ; Port B = input
    lda CIA2_DDRA
    ora #$04
    sta CIA2_DDRA   ; PA2 = output for latch signal
    rts


; ===========================================
; =========== Read all 8 gamepads ===========
; Input:  A: Number of bits to read from controllers
; Output: Array 'pads' (8 x 16-bits): Button states (low-active)
; Uses zero page variable 'tmp'
;
sp64_read    
    sta tmp         ; bit counter
    
    ; Generate latch pulse to store button data
    lda CIA2_PRA
    ora #$04
    sta CIA2_PRA    ; Latch = 1
    and #$FB
    sta CIA2_PRA    ; Latch = 0
    
sp64_bitloop 
    lda CIA2_PRB    ; Read data from Port B...
    ldx #0
sp64_padloop        ; ... and shift them in array 'pads'
    lsr             ;
    rol pads,x      ; bits: Up Down Left Right A X L R
    rol pads+1,x    ; bits: x x x x B Y Select Start
    inx
    inx
    cpx #16
    bmi sp64_padloop
    dec tmp
    bne sp64_bitloop
    rts


; ===========================================
; Output controller states to screen
output

    ldx #0      ; for all 8 pads
    lda #<SCREEN_POS
    sta scn
    lda #>SCREEN_POS
    sta scn+1

outputloop      
    ldy #0
    
    lda #11
    sta tmp     ; bitcounter
     
    lda pads,x
    sta tmp16
    lda pads+1,x
    sta tmp16+1
    
-   lda tmp16+1
    and #$08
    beq +
    lda #'-'    
    bne ++
+   lda #'0'
++          
    sta (scn),y
    iny

    rol tmp16
    rol tmp16+1        
            
    dec tmp 
    bpl -
    
    ;scn + #40, next line
    clc
    lda scn
    adc #40 
    sta scn
    lda scn+1
    adc #0
    sta scn+1
    
    inx
    inx
    cpx #16
    bmi outputloop
    rts
