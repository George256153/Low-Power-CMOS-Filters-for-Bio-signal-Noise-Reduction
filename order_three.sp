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
.inc sig_time.cir
*.inc sig_2024_bias900mV_time.cir

*=========Input signals =========*
Vdd vdd gnd 1.8
xecg vin gnd ecg
xori vori gnd ori
vclk clk gnd pulse(0 1.8 0 10p 10p 2.5e-5 5e-5)	*design by yourself
*================================*

*==========Your filter ==========*
.subckt filter vin vout clk vdd gnd

***Notch Filter ***
.param NRB = 0.11G
.param NRA = 0.12G

.param NR = 2.7G
.param NC = 9.82p

rn1 vin   node1 2*NR
rn2 node1 node3 2*NR
cn1 node1 node4 2*NC

cn2 vin   node2 NC
cn3 node2 node3 NC
rn3 node2 node4 NR 

rn4 out_NF node4 NRA
rn5 node4 gnd   NRB

rn6 out_NF node3 100K ***Rin=100K***
rn7 OP_NF out_NF 1K ***Rout=1K***

En1 OP_NF gnd OPAMP node3 out_NF 100K ***Av=100K***
***Low Pass Filter stage 1*** 
.param R1_s1 = 3.6G
.param R2_s1 = 3.6G
.param C1_s1 = 1p
.param C2_s1 = 1p

r1_s1 out_NF n1_s1  R1_s1
c1_s1 n1_s1  out_s1 C1_s1
r2_s1 n1_s1  n2_s1  R2_s1
c2_s1 n2_s1  gnd    C2_s1

r3_s1 out_s1 n2_s1 100K ***Rin=100K***
r4_s1 OP_s1 out_s1 1K ***Rout=1K***

E1_s1 OP_s1 gnd OPAMP n2_s1 out_s1 100K ***Av=100K***
***Low Pass Filter stage 2*** 
.param R1_s2 = 3.4G
.param R2_s2 = 3.4G
.param C1_s2 = 1p
.param C2_s2 = 1p

r1_s2 out_NF n1_s2  R1_s2
c1_s2 n1_s2  out_s2 C1_s2
r2_s2 n1_s2  n2_s2  R2_s2
c2_s2 n2_s2  gnd    C2_s2

r3_s2 out_s2 n2_s2 100K ***Rin=100K***
r4_s2 OP_s2 out_s2 1K ***Rout=1K***

E1_s2 OP_s2 gnd OPAMP n2_s2 out_s2 100K ***Av=100K***
***Low Pass Filter stage 3*** 
.param R1_s3 = 1.27G
.param R2_s3 = 1.27G
.param C1_s3 = 1p
.param C2_s3 = 1p

r1_s3 out_NF n1_s3  R1_s3
c1_s3 n1_s3  out_s3 C1_s3
r2_s3 n1_s3  n2_s3  R2_s3
c2_s3 n2_s3  gnd    C2_s3

r3_s3 out_s3 n2_s3 100K ***Rin=100K***
r4_s3 OP_s3 out_s3 1K ***Rout=1K***

E1_s3 OP_s3 gnd OPAMP n2_s3 out_s3 100K ***Av=100K***
.ends

*================================*
xfilter vin vout clk vdd gnd filter
Cload vout gnd 1p

.tran 0.1m 0.946

*vin+ vtest gnd dc=1v ac=1 
*xfilter1 vtest vtest_o clk vdd gnd filter
*Cload1 vtest_o gnd 1p

*.ac dec 100 1 1000g
*============Power===============*
.meas tran power AVG PAR('V(vdd)*abs(I(vdd))') from=0.1ms to=0.946ms
*================================*
.end
