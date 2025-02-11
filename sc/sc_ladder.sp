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
mp0 vdd A n1  vdd p_18 w=1u l=0.18u
mp1 n1  B out vdd p_18 w=1u l=0.18u
mn0 out A gnd gnd n_18 w=1u l=0.18u
mn1 out B gnd gnd n_18 w=1u l=0.18u
.ends
.subckt inv vdd gnd in out
mp0 vdd in out vdd p_18 w=1u l=0.18u
mn0 gnd in out gnd n_18 w=1u l=0.18u
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
mp0 in clk  out vdd p_18 w=1u l=0.18u
mn0 in clkb out gnd n_18 w=1u l=0.18u
.ends
*==========Your filter ==========*
.subckt filter vin vout clk vdd gnd

x20 vdd gnd clk out_ck1 out_ck2 non_overlapped
***Notch Filter ***
.param NRB = 0.11G
.param NRA = 0.12G

.param NR = 2.7G
.param NC = 9.82p

rn1 vin   node1   2*NR
rn2 node1 node3   2*NR
cn1 node1 node4   2*NC

cn2 vin   node2   NC
cn3 node2 node3   NC

*rn3 node2 node4   NR 
x25 vdd gnd out_ck1 out_ck2 node2  sc12  tg
x26 vdd gnd out_ck2 out_ck1 sc12  node4  tg
c12 sc12 gnd 10f

*rn4 out_NF node4  NRA
x23 vdd gnd out_ck1 out_ck2 out_NF sc11  tg
x24 vdd gnd out_ck2 out_ck1 sc11  node4  tg
c11 sc11 gnd 416.54f

*rn5 node4  gnd    NRB
x21 vdd gnd out_ck1 out_ck2 node4 sc10 tg
x22 vdd gnd out_ck2 out_ck1 sc10  gnd  tg
c10 sc10 gnd 454.54f

rn6 out_NF node3  100K ***Rin=100K***
rn7 OP_NF  out_NF 1K   ***Rout=1K***

En1 OP_NF gnd OPAMP node3 out_NF 100K ***Av=100K***
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

rl3 vo1 n2 100K ***Rin=100K***
rl4 OPo1 vo1 1K ***Rout=1K***

El1 OPo1 gnd OPAMP n2 vo1 100K ***Av=100K***
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

rl7  vo2   n5 100K ***Rin=100K***
rl8  OPo2 vo2 1K ***Rout=1K***

El2  OPo2 gnd OPAMP n5 vo2 100K ***Av=100K***
***Notch Filter stage2***
.param NRB1 = 5.15G
.param NRA1 = 0.85G

.param NR1 = 0.24G
.param NC1 = 1.65p

rn11 vo2    node11   2*NR1
*x9  vdd gnd out_ck1 out_ck2 vo2 sc5 tg
*x10 vdd gnd out_ck2 out_ck1 sc5  node11 tg
*c5 sc5 gnd 104.17f


rn12 node11 node13   2*NR1
*x11 vdd gnd out_ck1 out_ck2 node11 sc6 tg
*x12 vdd gnd out_ck2 out_ck1 sc6  node13 tg
*c6 sc6 gnd 104.17f

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
*c8 sc8 gnd 2f

*rn15 node14 gnd      NRB1
x17 vdd gnd out_ck1 out_ck2 node14 sc9 tg
x18 vdd gnd out_ck2 out_ck1 sc9  gnd tg
c9 sc9 gnd 9.71f

rn16 vout    node13  100K ***Rin=100K***
rn17 OP_NF1  vout    1K   ***Rout=1K***

En2 OP_NF1 gnd OPAMP node13 vout 100K ***Av=100K***
.ends
*================================*
xfilter vin vout clk vdd gnd filter
Cload vout gnd 1p

.tran 10m 0.946  

vin+ vtest gnd dc=1v ac=1 
xfilter1 vtest vtest_o clk vdd gnd filter
Cload1 vtest_o gnd 1p

.ac dec 100 1 1000g
*============Power===============*
.meas tran power AVG PAR('V(vdd)*abs(I(vdd))') from=0.1ms to=0.946
*================================*
.end
