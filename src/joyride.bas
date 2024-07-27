0 c=40
10 if peek(43)<>1 goto 150
20 if peek(44)=8 and peek(56)=160 goto 1064:rem c64
30 if peek(44)=4 and peek(56)=30 goto 1020:rem vic-20 3k
40 if peek(44)=16 goto 200
50 if peek(44)<>18 goto 150
60 if peek(56)=64 goto 1020:rem vic-20 8k
70 if peek(56)=96 goto 1020:rem vic-20 16k
80 if peek(56)=128 goto 1020:rem vic-20 24k

150 if peek(46)=28 and peek(45)=1 goto 1128:rem c128
160 if peek(223)=1 and peek(224)=8 goto 1216:rem x16
170 if peek(194)=1 and peek(195)=32 goto 1065:rem mega65
180 goto 1000

200 if peek(56)=30 goto 1020:rem vic-20 0k
210 if peek(56)=63 goto 1016:rem c16
220 if peek(56)=253 goto 1004:rem plus/4
230 goto 1000

400 if peek(215)>127 then c=80
500 poke 53280,15
510 poke 53281,15
520 print"{dark gray}";
530 d=186
540 return

1000 print"{clear}computer not recognized.":end
1004 c$="plus/4":goto 4000
1016 f$="c16":goto 4000
1020 f$="vic-20":goto 4000
1064 f$="joyride c64":gosub 500:goto 3000
1065 f$="mega65":goto 4000
1128 f$="joyride c128":gosub 400:goto 3000
1216 c$="commander x16":goto 4000

3000 print"{clear}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}"
3010 p=c/2-7
3050 printspc(p+3-len(f$)/2)"loading "f$
3060 d=peek(d)
3070 if d=0 then d=8
3080 loadf$,d

4000 print"{clear}sorry, there is no version of anykey for the "c$" yet.":end
