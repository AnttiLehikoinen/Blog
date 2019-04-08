function Bt = Bt_rf(ri, hpm, hs, alpha_t, ro, Qs, p, J, ltot)
%Bt tooth flux density of radial-flux machine

Br = 1.35;
mur_pm = 1.05;
delta = 0.5e-3;
ffill = 0.35;
%xi = 0.95;

%airgap flux density (square-wave peak)
Bag = Br*hpm/mur_pm / (hpm/mur_pm + delta);

Bt = Bag / alpha_t;

end