function T = AFM(ri, hpm, hs, alpha_t, ro, Qs, p, J, ltot)
%AFM Torque of axial-flux motor.

Br = 1.35;
mur_pm = 1.05;
delta = 0.5e-3;
ffill = 0.35;
xi = 0.95;
Byr_max = 1.8; %rotor yoke flux density

%airgap flux density (fundamental of square-wave)
Bag = Br*hpm/mur_pm / (hpm/mur_pm + delta) * 4/pi;

%tooth width
wtooth = 2*pi*ri / Qs * alpha_t;

%slot width
ws = 2*pi*ri/Qs - wtooth;

%outer radius of core = max radius minus EW thickness
ro_core = ro - ws/2;

%rotor yoke thickess = half of pole-flux (at outer periphery) per max
%allowed B
hyr = Br*hpm/mur_pm / (hpm/mur_pm + delta) * 2*pi*ro_core/(2*p)/2 / Byr_max;

%cor length
l_core = ltot - 2*hpm - 2*hyr - 2*delta;

%slot area (perpendicular to winding direction)
Aslot = ws*l_core;

%torque
T = Bag * Aslot*ffill*sqrt(2)*J/2 * xi * Qs * (ri+ro_core)/2 * (ro_core-ri);

end

