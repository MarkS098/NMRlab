close all; clc; clearvars;
format long

gradient_data = table2array(readtable('MRI.xlsx','Sheet','Gradient'));
I_P_data = readtable('MRI.xlsx','Sheet','T1',ReadVariableNames=true);

h = gradient_data(:,1);
f = gradient_data(:,2);

% Creating the model function
grad_model = 'a*x + b';

% Initial point guess
startPointsT1 = [1, 1];

% Performing the fit according to T1 decay model
f1 = fit(h, f, grad_model, 'Start', startPointsT1)

% reading T1 data
cell_header = readcell('MRI.xlsx','Sheet','T1');
header = cell_header(1,:);
header = header(2:end);
P_data = table2array(I_P_data(:,1));
neopreme_data = table2array(I_P_data(:,2));
buna_data = table2array(I_P_data(:,3));
silicone_data = table2array(I_P_data(:,4));
pvc_data = table2array(I_P_data(:,5));

% larmor frequency vs height plot
figure (1)
hold on
grid on

plot(f1, h, f)
xlim([1.1*min(h), 1.1*max(h)])
ylim([0 1.1*max(f)])
xlabel('h (mm)')
ylabel('f (kHz)')

% T1 plots
figure (2)
hold on
grid on

plot (P_data,neopreme_data)
plot (P_data,buna_data)
plot (P_data,silicone_data)
plot (P_data,pvc_data)

legend(header)
xlabel('P (ms)')
ylabel('Intensity')
