close all; clc; clearvars;
format long

% Converting data to arrays
FID_data = table2array(readtable('fid.csv'));
inv_rec_data = table2array(readtable('Part 1.xlsx','Sheet','Sheet1'));
I_P_data = table2array(readtable('Part 1.xlsx','Sheet','Sheet2'));
echo_gm_on_data = table2array(readtable('echomgon.csv'));
echo_gm_off_data = table2array(readtable('echomgoff.csv'));

% Reading FID components
t_FID = FID_data(:,1);
I_FID = FID_data(:,2);

% Reading magnitude I and repetition time P data
P = I_P_data(:,1);
I = I_P_data(:,2);

% Reading inversion recovery data
tau = inv_rec_data(:,1);
I_inv = inv_rec_data(:,2);
[~,min_index] = min(I_inv);
I_plot = cat(1, -I_inv(1:min_index), I_inv(min_index + 1:end));

% Creating the model function
T1_decay = 'a*(1 - 2*exp(-x/b))';

% Initial point guess
startPointsT1 = [1, 1];

% Performing the fit according to T1 decay model
f1 = fit(tau, I_plot, T1_decay, 'Start', startPointsT1)
M0 = f1.a;
T1 = f1.b;

% Reading Hahn echo data with G-M mode turned on
t_gm_on = echo_gm_on_data(:,1);
I_gm_on = echo_gm_on_data(:,2);

% Reading Hahn echo data with G-M mode turned off
t_gm_off = echo_gm_off_data(:,1);
I_gm_off = echo_gm_off_data(:,2);



% Calculating peak positions
is_max = islocalmax(I_gm_on,'MinProminence', 2.25);
echo_max = I_gm_on(is_max == 1);
t_fit = t_gm_on(is_max == 1);

% Calculating peak positions
is_max = islocalmax(I_gm_off,'MinProminence', 0.65);
echo_max_off = I_gm_off(is_max == 1);
echo_max_off = echo_max_off(2:end - 1)
t_fit_off = t_gm_off(is_max == 1);
t_fit_off = t_fit_off(2:end -1 );

% Performing fit according to T2 decay model
T2_decay = 'c*(exp(-x/d + f))';
startPointsT2 = [1, 1, 1];
f2 = fit(t_fit, echo_max, T2_decay, 'Start', startPointsT2)
f3 = fit(t_fit_off, echo_max_off, T2_decay, 'Start', startPointsT2)
T2 = f2.d/2;

% FID point plot
figure (1)
hold on
grid on
scatter(t_FID, I_FID, '.')
xlabel('t (s)')
ylabel('Magnetization')

figure(2)
hold on
grid on
scatter(P, I, 'or')
xlabel('P (s)')
ylabel('Intensity')
ylim([-0.2*max(I), 1.2*max(I)])
xlim([-0.2*max(P), 1.2*max(P)])

% T1 Inversion recovery plot
figure (3)
hold on
grid on
plot(f1, tau, I_plot)
title('Inversion recovery for T1')
ylabel('Intensity')
xlabel('t (s)')

% T2 exponential decay plot for Hahn echo with G-M mode turned on
figure (4)
hold on
grid on
title('Hahn echo plot for T2, MG-on')
plot(t_gm_on,echo_gm_on_data)
plot(f2, t_fit, echo_max)
xlabel('t (s)')
ylabel('Intensity')

% T2 exponential decay plot for Hahn echo with G-M mode turned on
figure (5)
hold on
grid on
title('Hahn echo plot for T2, MG-off')
plot(t_gm_off,echo_gm_off_data)
plot(f3, t_fit_off, echo_max_off)
xlabel('t (s)')
ylabel('Intensity')