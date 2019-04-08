function K = Kaf(ri, hpm, hs, alpha_t, ro, Qs, p, J, ltot)
%Kaf Electrical loading of axial-flux machine.

%same old story as in AFM.m
Br = 1.35;
mur_pm = 1.05;
delta = 0.5e-3;
ffill = 0.35;
Byr_max = 1.8;


wtooth = 2*pi*ri / Qs * alpha_t;
ws = 2*pi*ri/Qs - wtooth;

ro_core = ro - ws/2;

hyr = Br*hpm/mur_pm / (hpm/mur_pm + delta) * 2*pi*ro_core/(2*p)/2 / Byr_max;
l_core = ltot - 2*hpm - 2*hyr - 2*delta;

Aslot = ws*l_core;

%electrical loading at inner diameter
K = Aslot*ffill*J / (2*pi*ri/Qs) /2;

end