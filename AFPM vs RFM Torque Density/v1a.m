
ro = 20e-2/2;
Qs = 12*4;
p = 5*4;

J = 80e6;
Kmax = 60e3;
Bymax = 1.7;
Btmax = 1.8;

ltot = 2e-2;

%SPM(ri, hpm, hs, alpha_t, ro, Qs, p, J, ltot)
fun = @(x)( -SPM(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot) );

x0 = [0.6*ro; 5e-3; 5e-3; 0.5];
lb = [0.1*ro; 0.5e-3; 1e-3; 0.005];
ub = [0.9*ro; 15e-3; 0.9*ro; 0.995];

nlcon = @(x)( [-Kmax + Krf(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot);
     -Bymax + Bys_rf(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot);
     -Btmax + Bt_rf(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot);
     x(1)+x(3)-ro] );
 
 %return;


%x = fminsearch(fun, x0)
x = opt_DE(fun, lb, ub, nlcon);
fun(x)

nlcon2 = @(x2)( [-Kmax + Kaf(x2(1), x2(2), x2(3), x2(4), ro, Qs, p, J, ltot);
    -Btmax + Bt_af(x2(1), x2(2), x2(3), x2(4), ro, Qs, p, J, ltot)]);

fun2 = @(x)( -AFM(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot) );
x2 = opt_DE(fun2, lb, ub, nlcon2, false);
fun2(x2)

return

ls = linspace(2e-2, 30e-2, 20);
Ts = zeros(1, numel(ls));
for k = 1:numel(ls)
    ltot = ls(k);
    
    fun = @(x)( -SPM(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot) );
    nlcon = @(x)( [-Kmax + Krf(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot);
     -Bymax + Bys_rf(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot);
     -Btmax + Bt_rf(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot);
      x(1)+x(3)-ro] );
     
     x = opt_DE(fun, lb, ub, nlcon);
     Ts(k) = fun(x);
end

figure(1); clf; hold on;
plot(ls*1e2, -Ts  );