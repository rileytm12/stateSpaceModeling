function feval = optFunction(delta_v)

    %{

        Input: delta_v (Velocity change from the impulse)
    
        Minimizes the change in velocity that happens during the impulse
        while still getting the S/C back to Earth
    
        Output: feval (The minimized delta_v)

    %}

    % Generate initial vector and constants
    y0 = getinitial();
    tspan = [0 1000000];
    
    % Establish options 
    options = odeset('Events',@myevents, 'RelTol',1e-3,'AbsTol',1e-6, 'MaxStep',5);
    
    % Calling ODE45
    [t, X] = ode45(@(t, y) RHS(t, y, delta_v), tspan, y0, options);

    %% Plotting 
    figure(1); % Create plot of Spacecraft motion
    plot(X(:,5), X(:,6)); % Plot S/C over time
    title('Delta_V Minimization') % S/C over time
    hold on; xlabel('X-distance (x)'); ylabel('Y-distance (m)')
    legend('S/C', 'Moon', 'Location','southeast');    
    plot(X(:,3), X(:,4)); % Plot moon over moon
    hold on; 
    viscircles([X(end,3),X(end, 4)], 1737100) % Plot moon at end of time
    viscircles([0,0], 6371000) % Plot the Earth
    xlim([-1e8 3.2e8]); 
    ylim([-1e8 3.2e8]);
    
    % Optimization and output
    if t(end) < 999995 % This tells whether or not the S/C returned to Earth or is still in orbit   
        feval = abs(delta_v);    
    else 
        feval = 10000; % Reports a high feval so the optimizer doesn't choose a path that misses Earth
    end
end