* Testing DE_Solver for 2D, with verilog-A models

.hdl "ota_diff_In_single_Out_V3.va"
* .hdl "ota_sina_ckt.va"
.hdl "opamp.va"


*   X coordinate  OTA
xota_w_agnd   AGnd  Ib Outp  Vdd Vss in_neg Vxs  ota_w_agnd

* set common mode
Vcm in_neg 0 dc 0.5


ib_in  0 Ib dc 0.1mA   
VDDin  Vdd  0 dc 1  
VSSin  Vss 0  dc  0 
VGndy  AGnd 0 dc 0

* this will change DC sweep result
ib1 Outp  0 600uA

* X coordinate op-amp
* xamp1 begin

Vcm_1 inp1 0 dc 0.5

rf1 Outp Vys 100k
cf1 Outp Vys 20p

xamp1 Outp inp1 Vys 0 opamp

* xamp1 end


* Y coordinate OTA
xota_x_w_agnd AGndx  Ibx Outpx  Vddx Vssx inx_neg Vys  ota_w_agnd


* set common mode
Vinx_cm inx_neg 0 dc 0.5

ib_inx  0 Ibx dc 0.1mA   
VDDinx  Vddx  0 dc 1  
VSSinx  Vssx 0  dc  0 
VGndx  AGndx 0 dc 0


ibx Outpx 0 70uA

* Y coordinate op-amp
* xamp2 begin

Vcm_x inpx 0 dc 0.5

rf2 Outpx Vxs 200k
cf2 Outpx Vxs 20p

xamp2 Outpx inpx Vxs 0 opamp

* xamp2 end


* TMP1
*.DC Vin_sweep 0 1 0.01
*.PROBE I(Vcm_out)  

.PROBE V(Vys) V(Vxs)

*.PROBE  I(Vys) 

.tran 0.001n 700u

***--------------------------
.OPTION  INGOLD=2 ARTIST=2 PSF=2 PROBE=0 GMMIN=1e-15 METHOD=GEAR
.OPTION POST
*.TEMP  30
.OPTIONS SCALE = 1.00 
.SAVE
.end
