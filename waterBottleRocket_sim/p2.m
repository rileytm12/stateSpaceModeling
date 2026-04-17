%% Riley Martin 
% Project 2
% Predict the flight path of a bottle rocket using ODE45 and graph the
% conditions

clear;
clc;
close all;


%% Set up

const = getConst();

% initial conditions for 7 variables
d0 = 0; % Horizontal distance (m)
h0 = 0.25; % Verticle distance (m)
vx0 = 0; % m/s
vz0 = 0; % m/s
mass = const.mass_initial;
volume_air = const.volume_air_initial;
mass_air = const.mass_air_initial;

% Initial condition vector
X0 = [d0; vx0; h0; vz0; mass; volume_air; mass_air]; 

% Time span
tspan = [0 5]; % sec

% ODE45
%[t, X] = ode45(@(t, X) ascent_clear; clc; close all; 
[t, X] = ode45(@(t, X) ascent_eq(X, const), tspan, X0);

% Extracting thrust
for i = 1:length(X)
    [~, thrusty(i)] = ascent_eq(X(i,:), const);
end

%% Individual Plots
% Loading varification
load("project2verification.mat")

% Height vs distance 
plot(X(:,1), X(:,3)) % Data
hold on
plot(verification.distance, verification.height, LineStyle="--") % Verification
grid on
xlabel('Distance (m)')
ylabel('Height (m)')
title('Height vs Distance')
legend('Graphed Data', 'Verification', Location='northwest') 


% Thrust vs time 
time = linspace(0,5, length(X));
figure()
plot(t, thrusty) % Data
hold on
plot(verification.time, verification.thrust, LineStyle="--") % Verification
grid on
xlabel('Time (s)')
ylabel('Thrust (N)')
title('Thrust vs Time')
legend('Graphed Data', 'Verification') 
xlim([0, 0.5]);
ylim([0, 300]);

% Air volume vs time 
figure()
plot(t, X(:,6)) % Data
hold on
plot(verification.time, verification.volume_air, LineStyle="--") % Verification
grid on
xlabel('Time')
ylabel('Air Volume')
title('Air Volume vs Time')
legend('Graphed Data', 'Verification')
xlim([0, 0.5]);

% Z-velocity vs time
figure()
plot(t, X(:,4)) % Data
hold on
plot(verification.time, verification.velocity_y, LineStyle="--") % Verification
grid on
xlabel('Time')
ylabel('Z-Velocity')
title('Z-Velocity vs Time')
legend('Graphed Data', 'Verification')
% x_min = 0;
% x_max = 1; 
% xlim([x_min, x_max]);

% X-velocity vs time
figure()
plot(t, X(:,2)) % Data
hold on
plot(verification.time, verification.velocity_x, LineStyle="--") % Verification
grid on
xlabel('Time')
ylabel('X-Velocity')
title('X-Velocity vs Time')
legend('Graphed Data', 'Verification')
x_min = 0;
x_max = 5; 
xlim([x_min, x_max]);
y_min = -5;
y_max = 35; 
ylim([y_min, y_max]);

%% Adjustment Loop Plots 

% Initial Pressure Loop for plotting 

%% Original Initial gauge pressure: 441953.56

% Set max and min to view 
max_ip = 1200000; % Pa
min_ip = 400000; % Pa
initial_pressure = linspace(min_ip, max_ip, 10);

for i = 1:length(initial_pressure)
    
    % Set constants
    const.pressure_air_initial = initial_pressure(i);
    const.mass_air_initial = (const.pressure_air_initial * const.volume_air_initial) / (const.R_air * const.temperature_air_initial);
    const.mass_initial = const.mass_air_initial + const.mass_water_initial + const.mass_empty;    
    
    % Set initial conditions
    m_air_i = const.mass_air_initial;
    mass_t_i = const.mass_initial;

    % Apply initial conditions and run ODE45
    X01 = [d0; vx0; h0; vz0; mass_t_i; volume_air; m_air_i];
    [t, P] = ode45(@(t, X) ascent_eq(X, const), tspan, X01);
    height = P(:,3);

    IP(i) = (initial_pressure(i));
    D(i) = P(length(P),1);
    H(i) = max(height);

    % Reads the initial pressure when distance is 85 m 
    if D(i) >= 83 && D(i) <= 87
        initial_pressure85 = IP(i);
    end

end

%% Initial water volume fraction of water Loop for plotting 

% Original Initial water volume fraction: 1
min_IR = 0;
max_IR = 1;
initial_ratio = linspace(min_IR, max_IR, 10);

% Reset Constants
const.pressure_air_initial = 358527  + 83426.56; % Pa
const.mass_air_initial = (const.pressure_air_initial * const.volume_air_initial) / (const.R_air * const.temperature_air_initial);

for j = 1:length(initial_ratio)
    
    % Set constants
    const.volume_water_initial = initial_ratio(j) * 0.00095; % m^3
    const.volume_air_initial = const.volume_empty - const.volume_water_initial; % m^3
    const.mass_air_initial = (const.pressure_air_initial * const.volume_air_initial) / (const.R_air * const.temperature_air_initial);
    const.mass_water_initial = const.density_water * const.volume_water_initial;
    const.mass_initial = const.mass_air_initial + const.mass_water_initial + const.mass_empty;    

    % Set initial conditions
    m_air_i2 = const.mass_air_initial;
    mass_t_i2 = const.mass_initial;
    volume_a_i = const.volume_air_initial;

    % Apply initial conditions and run ODE45 and set new time span
    X01 = [d0; vx0; h0; vz0; mass_t_i2; volume_a_i; m_air_i2];
    tspan2 = [0 6];
    [t, R] = ode45(@(t, X) ascent_eq(X, const), tspan2, X01);    
    height = R(:,3);
    
    IR(j) = initial_ratio(j);
    D2(j) = R(length(R),1);
    H2(j) = max(height);
end


%% Drag coefficient loop for plotting

% Original drag coefficient: 0.48
min_DC = 0;
max_DC = 1;
dragco = linspace(min_DC, max_DC, 10);

% Reset Constants
    const.volume_water_initial = 0.00095; % m^3
    const.volume_air_initial = const.volume_empty - const.volume_water_initial; % m^3
    const.mass_air_initial = (const.pressure_air_initial * const.volume_air_initial) / (const.R_air * const.temperature_air_initial);
    const.mass_water_initial = const.density_water * const.volume_water_initial;
    const.mass_initial = const.mass_air_initial + const.mass_water_initial + const.mass_empty;

for k = 1:length(dragco)

    % Set constant
    const.drag_co = dragco(k);
    
    % Run ODE45
    [t, dc] = ode45(@(t, X) ascent_eq(X, const), tspan, X0);
    height = dc(:,3);

    DCO(k) = dragco(k);
    D3(k) = dc(length(dc),1);
    H3(k) = max(height);
end



%% Launch angle loop for plotting

% Original launch angle: 42
min_LA = 0;
max_LA = 1.4;
launch_angle = linspace(min_LA, max_LA, 10);

    % Reset Constant
    const.drag_co = 0.48;

for f = 1:length(launch_angle)
        
    % Set constant
    const.angle_initial = launch_angle(f);
    
    % Run ODE45
    [t, la] = ode45(@(t, X) ascent_eq(X, const), tspan, X0);
    height = la(:,3);
    
    LA(f) = launch_angle(f);
    D4(f) = la(length(la),1);
    H4(f) = max(height);

end

%% Create Subplots

line85 = ones(length(D)) * 85;

% Distance graphs
% Initial pressure
figure()
subplot(2,2,1)
plot(IP, D)
hold on
plot(linspace(min_ip,max_ip,length(D)), line85)
xlabel('Initial Pressure (Pa)')
ylabel('Distance (m)')
title('Differing Initial Air Pressure vs Distance')

% Water volume
subplot(2,2,2)
plot(IR, D2)
hold on
plot(linspace(min_IR,max_IR,length(D)), line85)
ylabel('Distance (m)')
title('Differing Water Volume Percentage vs Distance')
xlabel('Water Volume (%)')

% Drag coefficient
subplot(2,2,3)
plot(DCO, D3)
hold on
plot(linspace(min_DC,max_DC,length(D)), line85)
ylabel('Distance (m)')
title('Differing Drag Coefficient vs Distance')
xlabel('Drag Coefficient')

% Launch Angle
subplot(2,2,4)
plot(LA, D4)
hold on
plot(linspace(min_LA,max_LA,length(D)), line85)
ylabel('Distance (m)')
title('Differing Launch Angle vs Distance')
xlabel('Launch Angle (radians)')


% Height graphs

% Initial pressure
figure()
subplot(2,2,1)
plot(IP, H)
ylabel('Height (m)')
xlabel('Initial Pressure (Pa)')
title('Differing Initial Air Pressure vs Height')

% Water volume
subplot(2,2,2)
plot(IR, H2)
ylabel('Height (m)')
title('Differing Water Volume Percentage vs Height')
xlabel('Water Volume (%)')

% Drag coefficient
subplot(2,2,3)
plot(DCO, H3)
ylabel('Height(m)')
title('Differing Drag Coefficient vs Height')
xlabel('Drag Coefficient')

% launch angle
subplot(2,2,4)
plot(LA, H4)
ylabel('Height (m)')
title('Differing Launch Angle vs Height')
xlabel('Launch Angle (radians')

%% Hitting the Target

% Set initial pressure
initial_pressure = initial_pressure85;

    % Relient Constants
    const.pressure_air_initial = initial_pressure;
    const.mass_air_initial = (const.pressure_air_initial * const.volume_air_initial) / (const.R_air * const.temperature_air_initial);
    const.mass_initial = const.mass_air_initial + const.mass_water_initial + const.mass_empty;

    % Set initial conditions
    m_air_i = const.mass_air_initial;
    mass_t_i = const.mass_initial;

    % Apply initial conditions
    X01 = [d0; vx0; h0; vz0; mass_t_i; volume_air; m_air_i];

% Set initial water ratio
initial_ratio = 1;

    % Relient Constants
    const.volume_water_initial = initial_ratio * 0.00095; % m^3
    const.volume_air_initial = const.volume_empty - const.volume_water_initial; % m^3
    const.mass_air_initial = (const.pressure_air_initial * const.volume_air_initial) / (const.R_air * const.temperature_air_initial);
    const.mass_water_initial = const.density_water * const.volume_water_initial;
    const.mass_initial = const.mass_air_initial + const.mass_water_initial + const.mass_empty;    

% Set drag coefficient
dragco = 0.48;

    % Relient Constants
    const.drag_co = dragco; 

% Set launch angle in rad
launch_angle = 0.73038;

    % Relient Constants and unit conversion
    const.angle_initial = launch_angle;

% Plot target graphs 

% Height vs distance
figure()
[t85, T] = ode45(@(t, X) ascent_eq(X, const), tspan, X01);
plot(T(:,1), T(:,3))
hold on
xline(83) % 85 line
xline(82, '--red') % error
xline(84, '--red') % error
legend('Projectile Motion', '83', '83 \pm 1', Location='northwest')
xlabel('Distance (m)')
ylabel('Height (m)')
title('Distance vs Height (Aiming for 83)')
% xline(0.185, '--black')
% xline(0.216, '--black')

for i = 1:length(T)
    [~, thrusty2(i)] = ascent_eq(T(i,:), const);
end

% Thrust vs time
time = linspace(0,5, length(X));
figure()
plot(t85, thrusty2) % Data
grid on
xlabel('Time (s)')
ylabel('Thrust (N)')
title('Thrust vs Time')
xlim([0, 0.5]);
ylim([0, 300]);


%% Functions

% Constant function
function const = getConst()
    const.g = 9.807; % m/s^2
    const.discharge_co = 0.8; 
    const.density_amb = 0.961; % kg/m^3
    const.volume_empty = 0.002; % m^3
    const.pressure_atmospheric = 83426.56; % Pa
    const.ratio_specific = 1.4; 
    const.density_water = 1000; % kg/m^3
    const.throat_diameter = 0.021; % m
    const.bottle_diameter = 0.105; % m
    const.R_air = 287; % J/(kg*K)
    const.mass_empty = 0.15; % kg
    const.drag_co = 0.48;
    const.pressure_air_initial = 358527  + 83426.56; % Pa
    const.volume_water_initial = 0.00095; % m^3
    const.temperature_air_initial = 300; % K
    const.velocity_initial = 0; % m/s
    const.angle_initial = 0.733038; % radians
    const.distance_hor_initial = 0; % m 
    const.distance_vert_initial = 0.25; % m 
    const.test_stand_length = 0.5; % m
    const.area_bottle = (const.bottle_diameter/2)^2 * pi; % m^2
    const.volume_air_initial = const.volume_empty - const.volume_water_initial; % m^3
    const.area_throat = (const.throat_diameter/2)^2 * pi;
    const.mass_air_initial = (const.pressure_air_initial * const.volume_air_initial) / (const.R_air * const.temperature_air_initial);
    const.mass_water_initial = const.density_water * const.volume_water_initial;
    const.mass_initial = const.mass_air_initial + const.mass_water_initial + const.mass_empty;    

end

%% ODE45 Equation creator
function [dXdt, thrusty] = ascent_eq(X, const)
    
    % Initialize changing variables group section
%     pressure_i = group(1);
%     volume_water_i = group(2) * const.volume_water_initial;
%     dragco_i = group(3);
%     lunch_angle_i = group(4);

    % Initialize Variables
    state(1,:) = X(1); % Position x
    state(2,:) = X(2); % Position z
    state(3,:) = X(3); % Velocity x
    state(4,:) = X(4); % Velocity z
    state(5,:) = X(5); % Mass of rocket
    state(6,:) = X(6); % Volume of air
    state(7,:) = X(7); % Mass of air

%% Angle of attack

    length = sqrt(X(1)^2 + (X(3) - const.distance_vert_initial)^2); % length of the parabola being traveled by the rocket

    if length < const.test_stand_length % Rocket is still on stand
        angle = const.angle_initial;
    else % If the rocket has travled the length of the test span
        angle = atan(X(4) / X(2));
    end

    velocity = sqrt(X(2)^2 + X(4)^2); % Total velocity not using angle

%% Stage 1
    
    % General

        % Pressure
        pressure = const.pressure_air_initial * (const.volume_air_initial / X(6))^1.4;
    
    % Water

        % Exit Velocity 
        exit_velocity = sqrt(2*(pressure - const.pressure_atmospheric) / const.density_water);

        % Water flow rate
        water_mass_flow_rate = - const.discharge_co * const.density_water * const.area_throat * exit_velocity;

    % Forces

        % gravity
        gravity = const.g * X(5);

        % Thrust
        thrustx = cos(angle) * -water_mass_flow_rate * exit_velocity;
        thrustz = sin(angle) * -water_mass_flow_rate * exit_velocity;
    
        % Drag 
        dragx = cos(angle) * (1/2 * const.density_amb * velocity^2) * const.drag_co * const.area_bottle;
        dragz = sin(angle) * (1/2 * const.density_amb * velocity^2) * const.drag_co * const.area_bottle;

   % Air
            
        % Change of air volume
        dair_volume = const.discharge_co * const.area_throat * exit_velocity;

%% Stage 2
   
%     % General

        % Pressure at end of water phase
        pressure_end = const.pressure_air_initial * (const.volume_air_initial / const.volume_empty)^1.4;

        % Pressure as air is expelled
        pressure_2 = pressure_end * (X(7) / const.mass_air_initial)^1.4;

        % Temperature at end of water phase
        temperture_end = const.temperature_air_initial * (const.volume_air_initial / const.volume_empty)^.4;
        
        % Density empty
        density_empty = X(7) / const.volume_empty;

        % Temperature as air is expelled
        temperature = pressure_2 / (const.R_air * density_empty);

    % Air
        
        % Critical pressure
        pressure_crit = pressure_2 * (2/2.4)^(1.4/.4);
 

%% Stages of flight

    % Determines the stage of flight 
    %% Water powered phase  
    if X(6) < const.volume_empty    

        % Outputted thrust
        thrusty = sqrt(thrustx^2 + thrustz^2);

        % Net forces
        netx = thrustx - dragx;
        netz = thrustz - dragz - gravity;

        % Assign state values 
        state(1) = X(2); % Assign x position deriv
        state(2) = netx / X(5); % Calculate x velocity deriv
        state(3) = X(4); % Assign z position deriv
        state(4) = netz / X(5); % Calculate z velocity deriv
        state(5) = water_mass_flow_rate; % Assign mass deriv 
        state(6) = dair_volume; % Assign volume of air deriv
        state(7) = 0; % Assign mass air deriv
        thrusty = sqrt(thrustx^2 + thrustz^2); % Outputted thrust

    %% Air powered phase
    else % Air powered phase 
        
        if pressure_crit >= const.pressure_atmospheric % Check to see if bottle is still expelling water
            
            t_e = (2 / 2.4) * temperature;
            exit_velocity = sqrt(1.4 * const.R_air * t_e);
            pressure_exit = pressure_crit;
            exit_density = pressure_exit / (const.R_air * t_e);

            air_mass_flow_rate = -const.discharge_co * exit_density * const.area_throat * exit_velocity;

            % Thrust
            thrustx = cos(angle) * -air_mass_flow_rate * exit_velocity + cos(angle) * (pressure_exit - const.pressure_atmospheric) * const.area_throat;
            thrustz = sin(angle) * -air_mass_flow_rate * exit_velocity + sin(angle) * (pressure_exit - const.pressure_atmospheric) * const.area_throat;

            thrusty = sqrt(thrustx^2 + thrustz^2);% Outputted thrust
            t2 = sqrt(thrustx^2 + thrustz^2);% Outputted thrust
        else
            mach_exit = sqrt( 5 * ( (pressure_2 / const.pressure_atmospheric)^(0.4 / 1.4) - 1));
            t_e = temperature / (1 + mach_exit^2 * 0.4 / 2);
            exit_velocity = mach_exit * sqrt(1.4 * const.R_air * t_e);  
            pressure_exit = const.pressure_atmospheric;
            exit_density = const.pressure_atmospheric / (const.R_air * t_e);
    
            air_mass_flow_rate = -const.discharge_co * exit_density * const.area_throat * exit_velocity;
    
            thrustx = cos(angle) * -air_mass_flow_rate * exit_velocity;
            thrustz = sin(angle) * -air_mass_flow_rate * exit_velocity;
            thrusty = sqrt(thrustx^2 + thrustz^2); % Outputted thrust
        end

        if pressure_2 > const.pressure_atmospheric
            % Net forces (with thrust)
            netx = thrustx - dragx;
            netz = thrustz - dragz - gravity;

            % Assign State Values
            state(1) = state(2); % Assign x position deriv
            state(2) = netx / state(5); % Calculate x velocity deriv;
            state(3) = state(4); % Assign z position deriv
            state(4) = netz / state(5); % Calculate z velocity deriv;
            state(5) = air_mass_flow_rate; % Assign deriv of air mass (total mass)
            state(6) = 0;
            state(7) = air_mass_flow_rate; % Assign deriv of air mass

        else
            % Net forces (without thrust)
            netx = -dragx;
            netz = -dragz - gravity;
        
            thrusty = 0;
            
            state(1) = state(2); % Assign x position deriv
            state(2) = netx / state(5); % Calculate x velocity deriv;
            state(3) = state(4); % Assign z position deriv
            state(4) = netz / state(5); % Calculate z velocity deriv;
            state(5) = 0;
            state(6) = 0;
            state(7) = 0;

            if X(3) <= 0 % Check to see if landed 
            thrusty = 0;
            state(1) = 0;
            state(2) = 0;
            state(3) = 0;
            state(4) = 0;
            state(5) = 0;
            state(6) = 0;
            state(7) = 0;
           
            end

        end

        
    end
    
    % Output 
    dXdt = state; % Position ; Velocity
end
