close all; clc; clearvars;
format long

% Reading data files
FID = table2array(readtable('fid.csv'));
inv_rec = table2array(readtable('Part 1.xlsx'));

% Reading FID components
t_FID = FID(:,1);
M = FID(:,2);

% Reading inversion recovery data
tau = inv_rec(:,1);
I = inv_rec(:,2);
[I_min,min_index] = min(I);
I_plot = cat(1, -I(1:min_index), I(min_index + 1:end));

% Creating the model function
exp_decay = 'a*(1 - 2*exp(-x/b))';

% Initial point guess
startPoints = [1, 1];

% Performing the fit according to the exponential decay model
f1 = fit(tau, I_plot, exp_decay, 'Start', startPoints)
M0 = f1.a;
T1 = f1.b;

% Plotting the data together with the fit curve for inversion recovery
figure (1)
hold on
grid on
plot(f1, tau, I_plot)
ylabel('Intensity')
xlabel('\tau (s)')

% FID point plot
figure (2)
hold on
grid on
plot(t_FID, M)
xlabel('Magnetization')
ylabel('t')
