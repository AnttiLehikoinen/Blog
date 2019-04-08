%Generate plots for blog post

%combinations to consider
Js = [15 30 60]*1e6; %current densities
Ks = [50 100 200]*1e3; %surface current densities
ps = [1 2 4]; %pole-slot multiplier (10/12 base)

ls = linspace(3e-2, 10e-2, 10); %lengths

ro = 20e-2/2; %outer radius
Bymax = 1.7; %max yoke density
Btmax = 1.9; %max tooth density

cols = {'k', 'r', 'b'};

%going through combinations
for kk = 1:numel(Ks)
    figure(kk); clf;
    Kmax = Ks(kk);
    
    for kj = 1:numel(Js)
        J = Js(kj);
        
        subplot(1, numel(Js), kj); hold on; box on; grid on;
        title(['J = ' num2str(J*1e-6) ' A/mm^2']);
        drawnow;
        
        hs = zeros(numel(ps), 1);
        
        for kp = 1:numel(ps)
            Qs = 12*ps(kp);
            p = 5*ps(kp);
            
            Tax = zeros(1, numel(ls));
            Tr = zeros(1, numel(ls));
            
            for kl = 1:numel(ls)
                ltot = ls(kl);
                
                %initial guess and lower/upper bounds
                %Variables:
                % - inner diameter
                % - PM height
                % - slot heigth
                % - tooth width to slot slot pitch ratio
                
                x0 = [0.6*ro; 5e-3; 5e-3; 0.5];
                lb = [0.1*ro; 0.5e-3; 1e-3; 0.005];
                ub = [0.9*ro; 30e-3; 0.9*ro; 0.995];
                
                % optimizing radial-flux machine
                %cost function
                fun = @(x)( -SPM(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot) );
                
                %constraints (Kmax, tooth-B, yoke-B, slot height)
                nlcon = @(x)( [-Kmax + Krf(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot);
                    -Bymax + Bys_rf(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot);
                    -Btmax + Bt_rf(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot);
                    x(1)+x(3)-ro] );
                
                x = opt_DE(fun, lb, ub, nlcon);
                Tr(kl) = -fun(x);
                
                % optimizing axial-flux machine
                
                %Variables:
                % - inner diameter
                % - PM height
                % - slot heigth (unused)
                % - tooth width to slot slot pitch ratio
                
                %cost function
                fun2 = @(x)( -AFM(x(1), x(2), x(3), x(4), ro, Qs, p, J, ltot) );
                
                %constraints (Kmax, tooth-B)
                nlcon2 = @(x2)( [-Kmax + Kaf(x2(1), x2(2), x2(3), x2(4), ro, Qs, p, J, ltot);
                    -Btmax + Bt_af(x2(1), x2(2), x2(3), x2(4), ro, Qs, p, J, ltot)]);
                
                
                x2 = opt_DE(fun2, lb, ub, nlcon2, false);
                Tax(kl) = -fun2(x2);
            end
            
            hs(kp) = plot( 1e2*ls, Tr, cols{kp}, 'linestyle', '-');
            plot( 1e2*ls, Tax, cols{kp}, 'linestyle', '--');
            
            if kp == numel(ps)
                legend(hs, strcat('p = ', num2str(5*ps')));
                axis tight;
            end
                       
            drawnow;
        end
        if kj == 1
            ylabel('Torque (Nm)');
        elseif kj == 2
            %ylabel('Torque (Nm)');
            xlabel('Length (cm)');
        elseif kj == 3
            %xlabel('Length (cm)');
        end
        drawnow;
    end
end