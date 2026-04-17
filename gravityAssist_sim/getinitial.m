function y_vec = getinitial()
    
    %{

    Input: N/A 

    Outputs the initial condition in vector form.

    Output: y_vec (A vector taht contains the initial state)

    %}

    G = 6.674*10^-11;
    mass_moon = 7.34767309 * 10^22;
    mass_earth = 5.97219 * 10^24;
    
    % Spaceship initial
    d_es_0 = 340000000; % distance magnitude of S/C (m)
    theta_s = 50; % direction of velocity vector S/C 
    v_s_0 = 1000; % velocity vector magnitude S/C
    x_s_0 = d_es_0*cosd(theta_s); % X position S/C
    y_s_0 = d_es_0*sind(theta_s); % Y position S/C
    v_s_x = v_s_0 * cosd(theta_s); % X velocity S/C
    v_s_y = v_s_0 * sind(theta_s); % Y velocity S/C
    
    % Moon initial
    d_em_0 = 384403000; % distance magnitude of moon (m)
    theta_m = 42.5; % direction of velocity vector vector
    v_m_0 = sqrt((G * mass_earth^2) / (d_em_0*(mass_moon + mass_earth))); % velocity vector magnitude
    x_m_0 = d_em_0*cosd(theta_m); % X position 
    y_m_0 = d_em_0*sind(theta_m); % Y position
    v_m_x = -v_m_0 * cosd(theta_m); % X velocity
    v_m_y = v_m_0 * sind(theta_m); % Y velocity

    % Earth initial
    x_e_0 = 0; % X position 
    y_e_0 = 0; % Y position
    v_e_x = 0; % X velocity
    v_e_y = 0; % Y velocity

    y_vec = [x_e_0; y_e_0; x_m_0; y_m_0; x_s_0; y_s_0; v_e_x; v_e_y; v_m_x; v_m_y; v_s_x; v_s_y];
end