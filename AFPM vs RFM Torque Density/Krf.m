function K = Krf(ri, hpm, hs, alpha_t, ro, Qs, p, J, ltot)
%Krf Electrical loading of radial-flux machine

Br = 1.35;
mur_pm = 1.05;
delta = 0.5e-3;
ffill = 0.35;
%xi = 0.95;

%tooth width
wtooth = 2*pi*ri / Qs * alpha_t;

%slot area
Aslot = pi*( (ri+hs)^2 - ri^2 )/Qs - wtooth*hs;

%electric loading (rms)
K = Aslot*ffill*J / (2*pi*ri/Qs);

end