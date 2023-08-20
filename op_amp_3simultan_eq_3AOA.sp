*- OpAmp
.hdl "opamp.va"
.hdl "inverter2.va"

* opamp for X coordinate which is  voltage out*14
* begin

xinvrt2 out2 outv2 inverter2 

xamp1 inm inp out 0 opamp

rf inm out 100k
r1 outv2 inm 400k


rpf inp  0 100k

Vcoeff  vrp1 0 dc 0.7143


rp1  vrp1 inp 800k

rpy  inp 0 800k
* end

* opamp for Y coordinate which is voltage out2 * 14
* begin


xamp2 inm2 inp2 out2 0 opamp
rf2 inm2 out2 100k
r12 out inm2 37.495k

* gain (noninv terminal) is 1  + 1.667 = 2.667 
rpf2 inp2  0 100k

Vcoeff2  vrp2 0 dc 2.0239 

*xtest2 vrp2 out2 settling_test v0=0 v1=0.5 interval=10u

rp12  vrp2 inp2 100k

rpy2  inp2 0 59.988k
* end

* opamp for Z coordinate which is voltage out3 * 14
* begin

xinvrt3 out2 outv3 inverter2 

xamp3 inm3 inp3 out3 0 opamp

rf3 inm3 out3 100k
r13 outv3 inm3 119.976k

rpf3 inp3  0 100k

Vcoeff3  vrp3 0 dc 0.2574


rp13  vrp3 inp3 239.952k

rpy3  inp3 0 239.952k
* end





*.DC Vcoeff -1 20 0.1
*.DC Vcoeff2 -1 5 0.1

.PROBE V(out)
.PROBE V(out2)

* diverges if simulated for more than 4u
.tran 10p 4u 0.0 0.01u

***--------------------------
.OPTION  INGOLD=2 ARTIST=2 PSF=2 PROBE=0 GMMIN=1e-15 METHOD=GEAR
.OPTION POST
*.TEMP  30
.OPTIONS SCALE = 1.00
.SAVE

.end
