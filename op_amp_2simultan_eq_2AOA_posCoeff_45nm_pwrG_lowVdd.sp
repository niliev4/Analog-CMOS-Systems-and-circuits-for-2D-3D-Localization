
* declare Global VDD node
.GLOBAL Vdd_top

* declare Global Virtual VDD node
.GLOBAL vdd!


.OP

.TEMP 25.0

.INCLUDE "PMOS_VTL.inc"
.INCLUDE "NMOS_VTL.inc"

* global Vdd DC source
*  must adjust Vcoeff 1,2 source for 0.6
vdd_glob Vdd_top 0 DC=0.6


* Power Gating Gate control DC source
* power  ON = 0
* power OFF = 1
pwr_c pwrG_ctrl 0 DC=1

* PMOS Power Gating Transistor
*     D      G        S       B
* m444 vdd! pwrG_ctrl  Vdd_top Vdd_top PMOS_VTL L=100e-9 W=60e-6 AD=6.3e-12 AS=6.3e-12 PD=60.21e-6 PS=60.21e-6 M=1
m444 vdd! pwrG_ctrl  Vdd_top Vdd_top PMOS_VTL L=120e-9 W=15e-6 AD=1.575e-12 AS=1.575e-12 PD=15.21e-6 PS=15.21e-6 M=1

*- OpAmp
** Cell name: opamp
** View name: schematic

* positive in _net0  negative in _net1

.subckt opamp _net0 _net1 vout
m272 vout net7 0 0 NMOS_VTL L=100e-9 W=5e-6 AD=525e-15 AS=525e-15 PD=5.21e-6 PS=5.21e-6 M=1
m269 net20 _net0 net14 0 NMOS_VTL L=120e-9 W=30e-6 AD=3.15e-12 AS=3.15e-12 PD=30.21e-6 PS=30.21e-6 M=1
m265 net15 _net1 net14 0 NMOS_VTL L=120e-9 W=30e-6 AD=3.15e-12 AS=3.15e-12 PD=30.21e-6 PS=30.21e-6 M=1
m340 net29 net7 0 0 NMOS_VTL L=100e-9 W=2.5e-6 AD=262.5e-15 AS=262.5e-15 PD=2.71e-6 PS=2.71e-6 M=1
m341 net14 net4 net29 0 NMOS_VTL L=100e-9 W=2.5e-6 AD=262.5e-15 AS=262.5e-15 PD=2.71e-6 PS=2.71e-6 M=1
m338 net7 net4 net30 0 NMOS_VTL L=100e-9 W=2.5e-6 AD=262.5e-15 AS=262.5e-15 PD=2.71e-6 PS=2.71e-6 M=1
m339 net30 net7 0 0 NMOS_VTL L=100e-9 W=2.5e-6 AD=262.5e-15 AS=262.5e-15 PD=2.71e-6 PS=2.71e-6 M=1
m337 net4 net4 0 0 NMOS_VTL L=200e-9 W=500e-9 AD=52.5e-15 AS=52.5e-15 PD=710e-9 PS=710e-9 M=1
m271 vout net20 vdd! vdd! PMOS_VTL L=100e-9 W=60e-6 AD=6.3e-12 AS=6.3e-12 PD=60.21e-6 PS=60.21e-6 M=1
m268 net20 net15 vdd! vdd! PMOS_VTL L=120e-9 W=15e-6 AD=1.575e-12 AS=1.575e-12 PD=15.21e-6 PS=15.21e-6 M=1
m266 net15 net15 vdd! vdd! PMOS_VTL L=120e-9 W=15e-6 AD=1.575e-12 AS=1.575e-12 PD=15.21e-6 PS=15.21e-6 M=1



r249 net20 net32 820
r42 vdd! net7 5e3
r41 vdd! net4 20e3
c18 net32 vout 160e-15
.ends opamp
** End of subcircuit definition.




* opamp for X coordinate
* begin


xamp1 inp inm out  opamp

rf inm out 100k
r1 out2 inm 300k


rpf inp  0 100k


* original (2/3)*6 = 4V, divide down by 7.067 
*   for 0.6V supply
Vcoeff  vrp1 0 dc 0.566



rp1  vrp1 inp 600k

rpy  inp 0 600k
* end

* opamp for Y coordinate
* begin

* gain (inverting terminal) is -0.5

xamp2 inp2 inm2 out2  opamp
rf2 inm2 out2 100k
r12 out inm2 300k

* gain (noninv terminal) is 0.25 + 0.25 

* 1/3  + 1/3
rpf2 inp2  0 100k

* scale dc source up  to 2 (from 0.5) to make up for gain of 0.25 < 1
* original 5*4 = 20 , 20 divided down by 24 for 1V supply

* (2/3)*6 = 4   scaled down by 7.067 = 0.566

Vcoeff2  vrp2 0 dc 0.566 



rp12  vrp2 inp2 600k

rpy2  inp2 0 600k
* end



.PROBE V(out)
.PROBE V(out2)

.tran 10p 6u 0.0 0.01u

.measure tran curr_vdd1 avg I(vdd_glob) FROM=1ns TO=6u
.measure tran pwr_vdd1 PARAM='curr_vdd1*1'


.measure tran curr_vco1 avg I(Vcoeff) FROM=1ns TO=6u
.measure tran pwr_vco1 PARAM='curr_vco1*0.566'

.measure tran curr_vco2 avg I(Vcoeff2) FROM=1ns TO=6u
.measure tran pwr_vco2 PARAM='curr_vco2*0.566'

.measure tran total_pwr PARAM='pwr_vdd1+pwr_vco1+pwr_vco2'






***--------------------------
.OPTION  INGOLD=2 ARTIST=2 PSF=2 PROBE=0 GMMIN=1e-15 METHOD=GEAR
.OPTION POST
*.TEMP  30
.OPTIONS SCALE = 1.00
.SAVE

.end
