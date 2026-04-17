function feval = opt_t_Function(x)

    %{

        Input: x (initial condition vector)
    
        Minimizes the time of the S/C's return to Earth
    
        Output: feval (The minimized time)

    %}

    % Generate initial vector and constants
    y0 = optimized_getinitial(x);
    tspan = [0 1500000];
    
    % Establish options 
    options = odeset('Events',@myevents, 'RelTol',1e-3,'AbsTol',1e-6, 'MaxStep',5);
    
    % Calling ODE45
    [t, X] = ode45(@RHS, tspan, y0, options);

    %% Plotting 
    figure(1); % Create plot of Spacecraft motion
    plot(X(:,5), X(:,6)); title('Time Minimization') % S/C over time
    hold on; xlabel('X-distance (x)'); ylabel('Y-distance (m)')
    legend('S/C', 'Moon', 'Location','southeast');
    plot(X(:,3), X(:,4));  % Moon over time
    hold on; 
    viscircles([X(end,3),X(end, 4)], 1737100) % Moon at end of sim
    viscircles([0,0], 6371000) % Earth
    xlim([-1e8 3.2e8]); 
    ylim([-1e8 3.2e8]);
    
    % Optimization and output
    if t(end) >= tspan(end)   % never hit Earth
        feval = 1e9;          % heavy penalty
    elseif t(end) < 190000    % your moon crash condition
        feval = 1e10;
    else
        feval = t(end);
    end  
end