* Simulation File*
.protect
.lib 'cic018.l' TT
.unprotect
.temp 27
.option post
+accurate=1
+ingold=2
+runlvl=6

.inc pressure_time.cir
*.inc sig_time.cir
.inc sig_2024_bias900mV_time.cir

*=========Input signals =========*
Vdd vdd gnd 1.8
xecg vin gnd ecg
xori vori gnd ori
vclk clk gnd pulse(0 1.8 0 10p 10p 2.5e-5 5e-5)	*design by yourself
*================================*
.subckt nor2 vdd gnd A B out
mp0 vdd A n1  vdd p_18 w=0.47u l=0.18u
mp1 n1  B out vdd p_18 w=0.47u l=0.18u
mn0 out A gnd gnd n_18 w=0.47u l=0.18u
mn1 out B gnd gnd n_18 w=0.47u l=0.18u
.ends
.subckt inv vdd gnd in out
mp0 vdd in out vdd p_18 w=0.47u l=0.18u
mn0 gnd in out gnd n_18 w=0.47u l=0.18u
.ends
.subckt buf vdd gnd in out
x0 vdd gnd in n1  inv
x1 vdd gnd n1 out inv
.ends
.subckt non_overlapped vdd gnd clk out_ck1 out_ck2
x0 vdd gnd clk clkb inv

x1 vdd gnd clk  n1 out_ck1 nor2
x2 vdd gnd clkb n2 out_ck2 nor2
***delay up***
x3 vdd gnd out_ck2 n3 buf
x4 vdd gnd n3 n1 buf
***delay down***
x5 vdd gnd out_ck1 n4 buf
x6 vdd gnd n4 n5 buf
x7 vdd gnd n6 n5 buf 
x8 vdd gnd n6 n2 buf
.ends
.subckt tg vdd gnd clk clkb in out 
mp0 in clk  out vdd p_18 w=1u l=0.18u ***
mn0 in clkb out gnd n_18 w=1u l=0.18u ***
.ends
*** OPAMP ***
.SUBCKT bias_OP GND VB0 VB1 VDD ibias
*.PININFO GND:I VDD:I VB0:O VB1:O ibias:O
MM7 VB1 VB1 ibias GND N_18 m=1 l=10.0u w=1.875u
MM6 ibias ibias GND GND N_18 m=1 l=10.0u w=1.875u
MM0 net1 net1 GND GND N_18 m=1 l=10.0u w=535.0n
MM9 VB1 VB1 VDD VDD P_18 m=1 l=40.0u w=250.0n
MM5 VB0 VB0 VDD VDD P_18 m=1 l=10.0u w=1.2u
MM4 net1 net1 VB0 VDD P_18 m=1 l=10.0u w=1.2u
.ENDS

.SUBCKT OP GND V+ V- VB0 VB1 VDD Vo ibias
*.PININFO GND:I V+:I V-:I VB0:I VB1:I VDD:I ibias:I Vo:O
MM3 VB2 VB0 net35 GND    N_18 m=1 l=2.0u w=768.0n
MM2 Vo VB0 net38 GND     N_18 m=1 l=2.0u w=768.0n
MM1 net38 V- net15 GND   N_18 m=1 l=2.0u w=464.0n
MM0 net35 V+ net15 GND   N_18 m=1 l=2.0u w=464.0n
MM8 net15 ibias GND GND  N_18 m=1 l=2.0u w=12.94u
MM7 net37 VB2 VDD VDD    P_18 m=1 l=2.0u w=393.0n
MM6 net1 VB2 VDD VDD     P_18 m=1 l=2.0u w=393.0n
MM5 Vo VB1 net37 VDD     P_18 m=1 l=2.0u w=11.31u
MM4 VB2 VB1 net1 VDD     P_18 m=1 l=2.0u w=11.31u
.ENDS
*==========Your filter ==========*
.subckt filter vin vout clk vdd gnd

x20 vdd gnd clk out_ck1 out_ck2 non_overlapped
***Notch Filter stage1***
.param NRB = 0.11G
.param NRA = 0.12G

.param NR = 2.7G
.param NC = 11.02p

*rn1 vin   node1   2*NR
x29 vdd gnd out_ck1 out_ck2 vin  sc14  tg
x30 vdd gnd out_ck2 out_ck1 sc14 node1  tg
c14 sc14 gnd 0.0003f

*rn2 node1 node3   2*NR
x27 vdd gnd out_ck2 out_ck1 node1  sc13  tg
x28 vdd gnd out_ck1 out_ck2 sc13  node3  tg
c13 sc13 gnd 0.0003f

cn1 node1 node4   2*NC

cn2 vin   node2   NC
cn3 node2 node3   NC

*rn3 node2 node4   NR 
x25 vdd gnd out_ck1 out_ck2 node2  sc12  tg
x26 vdd gnd out_ck2 out_ck1 sc12  node4  tg
c12 sc12 gnd 8f

*rn4 out_NF node4  NRA
x23 vdd gnd out_ck1 out_ck2 out_NF sc11  tg
x24 vdd gnd out_ck2 out_ck1 sc11  node4  tg
c11 sc11 gnd 416.54f

*rn5 node4  gnd    NRB
x21 vdd gnd out_ck1 out_ck2 node4 sc10 tg
x22 vdd gnd out_ck2 out_ck1 sc10  gnd  tg
c10 sc10 gnd 454.54f

xOP1 gnd node3 out_NF VB0 VB1 vdd out_NF ibias OP
xbias_OP1 gnd VB0 VB1 vdd ibias bias_OP
***Low Pass Filter stage 1*** 
.param R1_s1 = 0.04G
.param R2_s1 = 2.13G
.param C1_s1 = 0.97p
.param C2_s1 = 0.67p

*rl1 out_NF n1 R1_s1
x1 vdd gnd out_ck1 out_ck2 out_NF sc1 tg
x2 vdd gnd out_ck2 out_ck1 sc1  n1 tg
c1 sc1 gnd 1210f

cl1 n1 vo1    C1_s1

*rl2 n1 n2     R2_s1
x3 vdd gnd out_ck1 out_ck2 n1 sc2 tg
x4 vdd gnd out_ck2 out_ck1 sc2  n2 tg
c2 sc2 gnd 23.47f

cl2 n2 gnd    C2_s1

xOP2 gnd n2 vo1 VB0 VB1 vdd vo1 ibias OP
***Low Pass Filter stage 2*** 
.param R1_s2 = 0.27G
.param R2_s2 = 0.34G
.param C1_s2 = 6.21p
.param C2_s2 = 0.97p

*rl5  vo1  n4  R1_s2
x5 vdd gnd out_ck1 out_ck2 vo1 sc3 tg
x6 vdd gnd out_ck2 out_ck1 sc3  n4 tg
c3 sc3 gnd 185.19f

cl3  n4   vo2 C1_s2

*rl6  n4   n5  R2_s2
x7 vdd gnd out_ck1 out_ck2 n4 sc4 tg
x8 vdd gnd out_ck2 out_ck1 sc4  n5 tg
c4 sc4 gnd 147.06f

cl4  n5   gnd C2_s2

xOP3 gnd n5 vo2 VB0 VB1 vdd vo2 ibias OP
***Notch Filter stage2***
.param NRB1 = 5.15G
.param NRA1 = 0.85G

.param NR1 = 0.24G
.param NC1 = 1.65p

*rn11 vo2    node11   2*NR1
x9  vdd gnd out_ck1 out_ck2 vo2  sc5    tg
x10 vdd gnd out_ck2 out_ck1 sc5  node11 tg
c5 sc5 gnd 104.17f

*rn12 node11 node13   2*NR1
x11 vdd gnd out_ck2 out_ck1 node11  sc6 tg
x12 vdd gnd out_ck1 out_ck2 sc6  node13 tg
c6 sc6 gnd 104.17f

cn11 node11 node14   2*NC1

cn12 vo2    node12   NC1
cn13 node12 node13   NC1

*rn13 node12 node14   NR1
x13 vdd gnd out_ck1 out_ck2 node12 sc7 tg
x14 vdd gnd out_ck2 out_ck1 sc7  node14 tg
c7 sc7 gnd 208.35f

*rn14 vout   node14   NRA1
x15 vdd gnd out_ck1 out_ck2 vout sc8 tg
x16 vdd gnd out_ck2 out_ck1 sc8  node14 tg
c8 sc8 gnd 0.59f

*rn15 node14 gnd      NRB1
x17 vdd gnd out_ck1 out_ck2 node14 sc9 tg
x18 vdd gnd out_ck2 out_ck1 sc9  gnd tg
c9 sc9 gnd 9.71f

xOP4 gnd node13 vout VB0 VB1 vdd vout ibias OP
.ends
*================================*
xfilter vin vout clk vdd gnd filter
Cload vout gnd 1p

.tran 0.01m 0.946
*============Power===============*
.meas tran power AVG PAR('V(vdd)*abs(I(vdd))') from=0.1ms to=0.946ms
*================================*
.end
