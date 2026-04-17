% RHS function for time minimization

function dXdt = RHS(t, X)

    %{

        Input: time (time of the current position in sim), State Vector
        (Current state of S/C, moon, and Earth)
    
        The function called by ODE45. Determines the position and velocity of
        the S/C, moon, and Earth. These values are then integrated by ODE45
        which gives the acceleration and velocity. These values are then used
        to calculate the sim state for all three bodies. 
    
        Output: dxdt (The position and velocities of the bodies)

    %}

    %% Establish Constants 
    mass_moon = 7.34767309 * 10^22;
    mass_earth = 5.97219 * 10^24;
    mass_sc = 28833;
    G = 6.674*10^-11;

    %% Establish distances
    d_msc = sqrt((X(3)-X(5))^2 + (X(4)-X(6))^2);
    d_me = sqrt((X(3)-X(1))^2 + (X(4)-X(2))^2);
    d_esc = sqrt((X(1)-X(5))^2 + (X(2)-X(6))^2);

    %% Forces
    % Gravitational force from moon acting on sc
    f_msc_x = (G*mass_moon*mass_sc*(X(3)-X(5))) / d_msc^3;
    f_msc_y = (G*mass_moon*mass_sc*(X(4)-X(6))) / d_msc^3;
    f_esc_x = (G*mass_earth*mass_sc*(X(1)-X(5))) / d_esc^3;
    f_esc_y = (G*mass_earth*mass_sc*(X(2)-X(6))) / d_esc^3;
    f_em_x = (G*mass_moon*mass_earth*(X(1)-X(3))) / d_me^3;
    f_em_y = (G*mass_moon*mass_earth*(X(2)-X(4))) / d_me^3;

    %% Sum forces in each direction for each body 
    % Spacecraft
    f_sc_x = f_msc_x + f_esc_x;     % Spacecraft x-direction
    f_sc_y = f_msc_y + f_esc_y;     % Spacecraft y-direction 

    % Moon
    f_m_x = -f_msc_x + f_em_x;    % Moon x-direction
    f_m_y = -f_msc_y + f_em_y;    % Moon y-direction  

    %% Calculate Accel
    % Spacecraft
    a_sc_x = f_sc_x / mass_sc;    % X-direction SC accel
    a_sc_y = f_sc_y / mass_sc;    % Y-direction SC accel

    % Moon
    a_m_x = f_m_x / mass_moon;    % X-direction moon accel
    a_m_y = f_m_y / mass_moon;    % Y-direction moon accel

    % Output 
    dXdt = [X(7); X(8); X(9); X(10); X(11); X(12); 0; 0; a_m_x; a_m_y; a_sc_x; a_sc_y];

end