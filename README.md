# Factorio tweeks by billbo99

Some times mods I use dont behave in the way I think they should,  this mod will allow me to tweek these mods adhoc while I wait for the original mod owners to agree or disagree with my ideas

Darkstar changes
---------

- Roboport power consumption 

Original Darkstar roboport power consumption was 
```
   roboport              4x ports    1000kW each    = 4MW (Vanilla roboport)
   roboport-mk2          4x ports    4000MW each    = 16GW (max consumption)
   roboport-mk3         25x ports   16000MW each    = 400GW (max consumption)
   roboport-charger    162x ports  340000MW each    = 55TW (max consumption)
```
Now, I have changed it to 4x times the previous tier
```
   roboport-mk2          4x ports    4000kW each    = 16MW (max consumption)
   roboport-mk3         25x ports   16000kW each    = 400MW (max consumption)
   roboport-charger    162x ports   64000kW each    = 10GW (max consumption)
```
- Prod module support for deadlock smelting

If deadlock-experiments is installed with Darkstar allow lead and gold to also be effected by prod modules when smelting.

