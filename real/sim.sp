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
MM3 VB2 VB0 net35 GND N_18 m=4 l=2.0u w=768.0n
MM2 Vo VB0 net38 GND N_18 m=4 l=2.0u w=768.0n
MM1 net38 V- net15 GND N_18 m=4 l=2.0u w=464.0n
MM0 net35 V+ net15 GND N_18 m=4 l=2.0u w=464.0n
MM8 net15 ibias GND GND N_18 m=4 l=2.0u w=12.94u
MM7 net37 VB2 VDD VDD P_18 m=4 l=2.0u w=393.0n
MM6 net1 VB2 VDD VDD P_18 m=4 l=2.0u w=393.0n
MM5 Vo VB1 net37 VDD P_18 m=4 l=2.0u w=11.31u
MM4 VB2 VB1 net1 VDD P_18 m=4 l=2.0u w=11.31u
.ENDS
*==========Your filter ==========*
.subckt filter vin vout clk vdd gnd

***Notch Filter stage1***
.param NRB = 0.11G
.param NRA = 0.12G

.param NR = 2.7G
.param NC = 9.82p

rn1 vin   node1   2*NR
rn2 node1 node3   2*NR
cn1 node1 node4   2*NC

cn2 vin   node2   NC
cn3 node2 node3   NC
rn3 node2 node4   NR 

rn4 out_NF node4  NRA
rn5 node4  gnd    NRB

xOP1 gnd node3 out_NF VB0 VB1 vdd out_NF ibias OP
xbias_OP1 gnd VB0 VB1 vdd ibias bias_OP
***Low Pass Filter stage 1*** 
.param R1_s1 = 0.04G
.param R2_s1 = 2.13G
.param C1_s1 = 0.97p
.param C2_s1 = 0.67p

rl1 out_NF n1 R1_s1
cl1 n1 vo1    C1_s1
rl2 n1 n2     R2_s1
cl2 n2 gnd    C2_s1

xOP2 gnd n2 vo1 VB2 VB3 vdd vo1 ibias1 OP
xbias_OP2 gnd VB2 VB3 vdd ibias1 bias_OP
***Low Pass Filter stage 2*** 
.param R1_s2 = 0.27G
.param R2_s2 = 0.34G
.param C1_s2 = 6.21p
.param C2_s2 = 0.97p

rl5  vo1  n4  R1_s2
cl3  n4   vo2 C1_s2
rl6  n4   n5  R2_s2
cl4  n5   gnd C2_s2

xOP3 gnd n5 vo2 VB4 VB5 vdd vo2 ibias2 OP
xbias_OP3 gnd VB4 VB5 vdd ibias2 bias_OP
***Notch Filter stage2***
.param NRB1 = 5.15G
.param NRA1 = 0.85G

.param NR1 = 0.24G
.param NC1 = 1.65p

rn11 vo2    node11   2*NR1
rn12 node11 node13   2*NR1
cn11 node11 node14   2*NC1

cn12 vo2    node12   NC1
cn13 node12 node13   NC1
rn13 node12 node14   NR1

rn14 vout   node14   NRA1
rn15 node14 gnd      NRB1

xOP4 gnd node13 vout VB6 VB7 vdd vout ibias3 OP
xbias_OP4 gnd VB6 VB7 vdd ibias3 bias_OP
.ends
*================================*
xfilter vin vout clk vdd gnd filter
Cload vout gnd 1p

.tran 0.1m 0.946

vin+ vtest gnd dc=1v ac=1 
xfilter1 vtest vtest_o clk vdd gnd filter
Cload1 vtest_o gnd 1p

.ac dec 100 1 1000g
*============Power===============*
.meas tran power AVG PAR('V(vdd)*abs(I(vdd))') from=0.1ms to=0.946ms
*================================*
.end
