% Basic myevents

function [value, isterminal, direction] = myevents(t,X)
    
    %{

        Input: time (time of the current position in sim), State Vector
        (Current state of S/C, moon, and Earth)
    
        Determines when certain requirements are met and when they are met a
        notification is sent to ODE45 to stop the simulation.
    
        Output: Value (passes value to isterminal), isterminal (1-stop sim,
        0-continue), direction (Passes 0 when necesary)

    %}

    distance_msc = sqrt((X(3)-X(5))^2 + (X(4)-X(6))^2);
    r_moon = 1737100;

    distance_esc = sqrt((X(1)-X(5))^2 + (X(2)-X(6))^2);
    r_earth = 6371000;

    distance_em = sqrt((X(1)-X(3))^2 + (X(2)-X(4))^2);

    value(1) = distance_msc-r_moon; % Ends sim when S/C collides with the moon
    value(2) = distance_esc-r_earth; % Ends sim when S/C collides with Earth
    value(3) = (2*distance_em)-distance_esc; % Ends sim when S/C is lost in sapce

    isterminal(1:3) = 1;

    direction(1:3) = 0;

end