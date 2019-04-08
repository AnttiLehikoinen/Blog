function xopt = opt_DE(f, LB, UB, con, varargin)

n = numel(LB);

if numel(varargin)
    plotting_on = varargin{1};
else
    plotting_on = false;
end

N = 75; %number of particles
Ngen = 200;

Nmax = 50e3;

%initialization
x = zeros(n, N); %particles' positions
Nobj = numel(f(x(:,1)));
fp = zeros(Nobj, N); %particles' best

ri = 1;
for k = 1:N
    while true
        x(:,k) = rand(n,1).*(UB-LB);
        
        cons = con(x(:,k));
        if any(isnan(cons)) || any(cons>0)
            continue;
        end
        fp(:,k) = f( x(:,k) );
        if ~any(isnan(fp(:,k)))
            break;
        end
        ri = ri+1;
        if ri > Nmax
            xopt = NaN*ones(size(x));
            return
        end
    end
end
disp('Initialized');

%figname = 'test.gif';

%running
CR = 0.3;
F = 2;
for kg = 1:Ngen
    for ki = 1:N
        while true
            ind_others = randsample(setdiff(1:N, ki), 3);
            
            R = randsample(n, 1);
            xprev = x(:,ki);
            for k = 1:n
                ri = rand();
                if (ri < CR) || k == R
                    x(k,ki) = x(k, ind_others(1)) + F*( x(k, ind_others(2)) - x(k, ind_others(3)) );
                end
            end
            
            x(:,ki) = max(x(:,ki), LB);
            x(:,ki) = min(x(:,ki), UB);
            
            cons = con(x(:,ki));
            if any(isnan(cons)) || any(cons>0)
                x(:,ki) = xprev;
                continue;
            end
            
            f_cand = f( x(:,ki) );
            
            if any(isnan(f_cand))
                x(:,ki) = xprev;
                continue;
            end
            
            if Nobj == 1
                if f_cand < fp(:,ki)
                    fp(:,ki) = f_cand;
                else
                    x(:,ki) = xprev;
                end
                break;
            else
                if all(f_cand<=fp(:,ki)) && any(f_cand<fp(:,ki))
                    fp(:,ki) = f_cand;
                else
                    x(:,ki) = xprev;
                end
            end
        end
    end
    
    %continue;
    if plotting_on
        figure(10); clf; plot(x(1,:), x(2,:), 'k.'); 
        title(['Gen = ' num2str(kg) ', best = ' num2str(min(fp))]);
        axis([LB(1) UB(1) LB(2) UB(2)]);
    end
end

[~, ind] = min(fp);
xopt = x(:,ind);