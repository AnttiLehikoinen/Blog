function T = SPM(ri, hpm, hs, alpha_t, ro, Qs, p, J, ltot)
%SPM Torque of RF-SPM

%hardcoded dimensions
Br = 1.35;
mur_pm = 1.05;
delta = 0.5e-3; %airgap
ffill = 0.35; %filling factor
xi = 0.95; %winding factor

%airgap flux density (square-wave fundamental)
Bag = Br*hpm/mur_pm / (hpm/mur_pm + delta) * 4/pi;

wtooth = 2*pi*ri / Qs * alpha_t; %tooth width
wsb = 2*pi*(ri+hs)/Qs - wtooth; %slot bottom width
lcore = ltot - wsb/2*2; %core length

%slot area
Aslot = pi*( (ri+hs)^2 - ri^2 )/Qs - wtooth*hs;

%torque= B_1 * NI_1/2 * winding factor * airgap radius * core length
T = Bag * Aslot*ffill*sqrt(2)*J/2 * xi * Qs * ri * lcore;

end