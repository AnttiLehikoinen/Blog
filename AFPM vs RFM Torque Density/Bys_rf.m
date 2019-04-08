function Byoke = Bys_rf(ri, hpm, hs, alpha_t, ro, Qs, p, J, ltot)
%Bys_rf Stator yoke flux density of radial-flux machine

Br = 1.35;
mur_pm = 1.05;
delta = 0.5e-3;

%airgap flux density (square-wave peak)
Bag = Br*hpm/mur_pm / (hpm/mur_pm + delta);

%yoke heigth
hys = ro - ri - hs;

%yoke flux density = half of pole-flux per yoke height
Byoke = Bag * 2*pi*ri/(2*p)/2 / hys;

end