* Testbench for two stage opamp @ AC *
.protect
.lib cic018.l tt
.unprotect
.inc bias_OP.spi
.inc OP.spi
***************test Av***************
vdd vdd gnd dc=1.8v
vin- v- gnd dc=0.9v
vin+ v+ gnd dc=0.9v ac=1 

xOP GND V+ V- VB0 VB1 VDD Vo ibias OP
xbias_OP GND VB0 VB1 VDD ibias bias_OP
C0 Vo GND 50p
*************************************
.op
.options post
.ac dec 100 10 10g
.PROBE   AC VDB(vo)
.MEASURE AC unit_gain when VDB(vo)=0
.MEASURE AC phase_margin find par('180+VP(vo)') when VDB(vo)=0
.MEASURE AC gain_dB max VDB(vo)

.END
