% PDE-Based Heat Transfer & Solidification Model
%                   Coded by
%              Roozbeh Aghabarari
%  
%                  Contact Me
%            ro.aghabarari@gmail.com
%           www.roozbehaghabarari.com
%
% Parameters
L = 0.762;                % Length of the ingot (m)
Tmax = 6000;              % Maximum simulation time (s)
dx = 0.009525;            % Spatial step (m)
dt = 0.1;                 % Time step (s)
K = 30;                   % Thermal conductivity (W/(m*K))
T_wall = 1150;            % Fixed wall temperature (°C)
T_inf = 20;               % Ambient temperature (°C)
rho = 7200;               % Density of steel (kg/m^3)
cp_solid = 682;           % Specific heat capacity of solid steel (J/(kg*K))
cp_liquid = 710;          % Specific heat capacity of liquid steel (J/(kg*K))
Lf = 262500;              % Latent heat of fusion (J/kg)
Tm = 1500;                % Melting temperature of steel (°C)

% Discretization
x = 0:dx:L;               % Spatial grid in x-direction
y = 0:dx:L;               % Spatial grid in y-direction
time = 0:dt:Tmax;         % Time grid
Nx = length(x);           % Number of spatial points in x-direction
Ny = length(y);           % Number of spatial points in y-direction
Nt = length(time);        % Number of time points

% Initial condition
T = ones(Nx, Ny) * 1535;  % Initial temperature (molten steel at 1535°C)

% Pre-allocate temperature and solidification fraction arrays
T_all = zeros(Nx, Ny, Nt);
solid_frac_all = zeros(Nx, Ny, Nt);
T_all(:, :, 1) = T;
solid_frac_all(:, :, 1) = solid_fraction(T, Tm);  % Initial solidification fraction should be zero

% Main simulation loop
for n = 1:Nt-1
    T_new = T;
    cp_eff = effective_cp(T, cp_solid, cp_liquid, Lf, Tm);
    
    for i = 2:Nx-1
        for j = 2:Ny-1
            T_new(i, j) = T(i, j) + (K / (rho * cp_eff(i, j))) * dt / dx^2 * ...
                          ((T(i+1, j) - 2*T(i, j) + T(i-1, j)) + ...
                           (T(i, j+1) - 2*T(i, j) + T(i, j-1)));
        end
    end
    
    % Fixed boundary condition at all walls
    T_new(1, :) = T_wall;
    T_new(Nx, :) = T_wall;
    T_new(:, 1) = T_wall;
    T_new(:, Ny) = T_wall;
    
    T = T_new;
    T_all(:, :, n+1) = T;
    solid_frac_all(:, :, n+1) = solid_fraction(T, Tm);  % Calculate solidification fraction
end

% Indices for the center of the quarter of the ingot and the center of the ingot
quarter_idx = floor(Nx/4);
half_idx = floor(Nx/2);

% Extract temperatures versus time
temperature_quarter = squeeze(T_all(quarter_idx, quarter_idx, :));
temperature_center = squeeze(T_all(half_idx, half_idx, :));

% Plot temperature versus time
figure;
plot(time, temperature_quarter, 'r', 'LineWidth', 2); hold on;
plot(time, temperature_center, 'b', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Temperature vs Time');
legend('Quarter Center', 'Ingot Center');
grid on;

% Plot contour plots of temperature distribution at specific time points
time_points = 0:1000:Tmax;  % Specific time points for contour plots (based on hw-pde file)

figure;
for i = 1:length(time_points)
    subplot(2, 4, i);
    contourf(x, y, T_all(:, :, time_points(i)/dt + 1)', 20, 'LineColor', 'none');
    colorbar;
    axis equal;  % Ensure the plot is cubic
    xlabel('x (m)');
    ylabel('y (m)');
    title(['t = ', num2str(time_points(i)), ' s']);
    hold on;
    plot(x(quarter_idx), y(quarter_idx), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    plot(x(half_idx), y(half_idx), 'bo', 'MarkerSize', 10, 'LineWidth', 2);
end
sgtitle('Temperature Contours at Different Time Points');
hold off;

% Calculate average solidification fraction versus time
avg_solid_frac = squeeze(mean(mean(solid_frac_all, 1), 2));

% Plot average solidification fraction versus time
figure;
plot(time, avg_solid_frac, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Solidification Fraction');
title('Solidification Fraction vs Time');
grid on;

% Solidification fraction calculation function
function sf = solid_fraction(T, Tm)
    Tm_range = 1;  % Define a range around Tm in order to consider solidus and liquidus temperatures
    sf = zeros(size(T));
    sf(T <= Tm - Tm_range) = 1;
    sf(T >= Tm + Tm_range) = 0;
    phase_change_indices = (T > Tm - Tm_range) & (T < Tm + Tm_range);
    sf(phase_change_indices) = (Tm + Tm_range - T(phase_change_indices)) / (2 * Tm_range);
end

% Effective heat capacity function
function cp_eff = effective_cp(T, cp_solid, cp_liquid, Lf, Tm)
    cp_eff = cp_solid * ones(size(T));
    liquid_indices = T > Tm;
    cp_eff(liquid_indices) = cp_liquid;
    % Linear approximation of the phase change region
    phase_change_indices = (T > Tm - 1) & (T < Tm + 1);
    cp_eff(phase_change_indices) = cp_solid + (Lf / ((Tm + 1)-(Tm - 1)));
end
