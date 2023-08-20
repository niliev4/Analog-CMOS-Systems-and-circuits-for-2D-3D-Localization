
* declare Global VDD node
.GLOBAL Vdd_top

* declare Global Virtual VDD node
.GLOBAL vdd!

* common mode  node
*.GLOBAL net14

.OP

.TEMP 25.0

.INCLUDE "PMOS_VTL.inc"
.INCLUDE "NMOS_VTL.inc"

* global Vdd DC source
*  lower than 1V for lower power
*   must adjust Vcoeff1,2,3 sources for it
vdd_glob Vdd_top 0 DC=0.6


* Power Gating Gate control DC source
* power  ON = 0
* power OFF = 1
pwr_c pwrG_ctrl 0 DC=0

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


.hdl "inverter2.va"

* opamp for X coordinate which is  voltage out*30
* begin

xinvrt2 out2 outv2 inverter2 
xamp1 inp inm out  opamp
rf inm out 100k
r1 outv2 inm 400k
rpf inp  0 100k

Vcoeff  vrp1 0 dc 0.2


rp1  vrp1 inp 800k

rpy  inp 0 800k
* end


* opamp for Y coordinate which is voltage out2 * 30
* begin

xamp2 inp2 inm2 out2  opamp
rf2 inm2 out2 100k
r12 out inm2 37.495k

* gain (noninv terminal) is 1  + 1.667 = 2.667 
rpf2 inp2  0 100k

Vcoeff2  vrp2 0 dc 0.5667


rp12  vrp2 inp2 100k

rpy2  inp2 0 59.988k
* end


* opamp for Z coordinate which is voltage out3 * 30
* begin

xinvrt3 out2 outv3 inverter2 

xamp3 inp3 inm3 out3  opamp

rf3 inm3 out3 100k
r13 outv3 inm3 119.976k

rpf3 inp3  0 100k

Vcoeff3  vrp3 0 dc 0.072


rp13  vrp3 inp3 239.952k

rpy3  inp3 0 239.952k
* end



.PROBE V(out)
.PROBE V(out2)
.PROBE V(out3)


.tran 10p 6u 0.0 0.01u

.measure tran curr_vdd1 avg I(vdd_glob) FROM=1ns TO=6u
.measure tran pwr_vdd1 PARAM='curr_vdd1*1.0'


.measure tran curr_vco1 avg I(Vcoeff) FROM=1ns TO=6u
.measure tran pwr_vco1 PARAM='curr_vco1*0.333'

.measure tran curr_vco2 avg I(Vcoeff2) FROM=1ns TO=6u
.measure tran pwr_vco2 PARAM='curr_vco2*0.944'

.measure tran curr_vco3 avg I(Vcoeff3) FROM=1ns TO=6u
.measure tran pwr_vco3 PARAM='curr_vco3*0.12'

.measure tran total_pwr PARAM='pwr_vdd1+pwr_vco1+pwr_vco2+pwr_vco3'






***--------------------------
.OPTION  INGOLD=2 ARTIST=2 PSF=2 PROBE=0 GMMIN=1e-15 METHOD=GEAR
.OPTION POST
*.TEMP  30
.OPTIONS SCALE = 1.00
.SAVE

.end
