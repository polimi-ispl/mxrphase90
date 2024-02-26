clear; close all; clc; 

%% Copyright (C) 2024 Riccardo Giampiccolo
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

%% Parameters

% Input Signal
f0 = 1000;
fs = 96000;
Ts = 1/fs;
StopTime = 1;
t = 0:Ts:StopTime;
Vin = sin(2*pi*f0*t);
N = length(Vin);

% LFO Signal
f_LFO = 2;
duty_cycle = 0.65;
LFO = 0.15*sawtooth(2*pi*f_LFO*t,duty_cycle) + 3.25;

% Input Buffer Stage
R1 = 10e3;
Z_C1 = Ts/(2*0.01e-6);
RL = 1e9;
R2 = 470e3;
    
Z_in = diag([R1 Z_C1 RL R2]);

Qv = [1     0    -1    -1; % Fundamental Cut-Set matrix of the V-net
      0     1    -1    -1];
Qi = [1     0     0    -1; % Fundamental Cut-Set matrix of the I-net
      0     1     0    -1];
S_in = 2*Qv'*((Qi/Z_in*Qv')\(Qi/Z_in)) - eye(4); % Scattering Matrix

% Phase-Shifting Stage
Vref = 5.1;

R5 = 24e3;
R3 = 10e3;
Z_C2 = Ts/(2*47e-9);
R4 = R3;
Z_ss = diag([1e-6 R5 R3 Z_C2 R4 0 RL 1e-6]);

Qv = [1     0     0     0     0     0    -1    -1; % Fundamental Cut-Set matrix of the V-net
      0     1     0     0     0     1     0    -1;
      0     0     1     0     0     0    -1     0;
      0     0     0     1     1     0    -1    -1];
Qi = [1     0     0     0    -1     0     0    -1; % Fundamental Cut-Set matrix of the I-net
      0     1     0     0     0     1     0    -1;
      0     0     1     0    -1     0     0     0;
      0     0     0     1     0     0     0    -1];
S_ss = @(Z) 2*Qv.'*((Qi/Z*Qv.')\(Qi/Z)) - eye(8); % Scattering Matrix

% Output Stage
mkupGain = 12;
R6 = 150e3;
Z2 = R6;
Z_C3 = Ts/(2*47e-9);
R7 = 56e3;

Z_out = diag([R6 Z2 Z_C3 R7 R6 R6]);

Q = [1     0     0    -1     1    -1; % Fundamental Cut-Set matrix
     0     1     0    -1     0    -1;
     0     0     1     0     0    -1];
S_out = 2*Q.'*((Q/Z_out*Q.')\(Q/Z_out)) - eye(6); % Scattering Matrix

% Initialization of vectors/variables
b_in = zeros(4,1); 
V1 = zeros(N,1);
b_ss1 = zeros(8,1);
b_ss2 = zeros(8,1);
b_ss3 = zeros(8,1);
b_ss4 = zeros(8,1);
V2 = zeros(N,1);
Vds_ss1 = 0;
Vds_ss2 = 0;
Vds_ss3 = 0;
Vds_ss4 = 0;
b_out = zeros(6,1);
Vout = zeros(N,1);

% Initialization of capacitor memory
a_old_C1 = -5.1;
a_old_C2_1 = 3.5227e-13;
a_old_C2_2 = -3.5227e-13;
a_old_C2_3 = -3.5227e-13;
a_old_C2_4 = 3.5227e-13;
a_old_C3 = -1.0164;

%% Algorithm

for n = 1 : N
    
    % Input Buffer Stage
    b_in(1) = -Vin(n); 
    b_in(2) = a_old_C1;
    b_in(4) = Vref;

    a_in = S_in*b_in;
    
    a_old_C1 = a_in(2);

    V1(n) = (a_in(3) + b_in(3))/2;

    % Phase-Shifting Unit: 1
    Vgs = LFO(n) - Vref;
    Z_ss(6,6) = nJFETresistanceApprox(Vgs, Vds_ss1);
    S_temp = S_ss(Z_ss);

    b_ss1(1) = -V1(n); 
    b_ss1(4) = a_old_C2_1;
    b_ss1(8) = Vref;

    a_ss1 = S_temp*b_ss1;
    
    a_old_C2_1 = a_ss1(4);
    Vds_ss1 = (a_ss1(6)+b_ss1(6))/2;

    % Phase-Shifting Unit: 2
    Z_ss(6,6) = nJFETresistanceApprox(Vgs, Vds_ss2);
    S_temp = S_ss(Z_ss);

    b_ss2(1) = -(a_ss1(7) + b_ss1(7))/2;
    b_ss2(4) = a_old_C2_2;
    b_ss2(8) = Vref;

    a_ss2 = S_temp*b_ss2;
    
    a_old_C2_2 = a_ss2(4);
    Vds_ss2 = (a_ss2(6)+b_ss2(6))/2;

    % Phase-Shifting Unit: 3
    Z_ss(6,6) = nJFETresistanceApprox(Vgs, Vds_ss3);
    S_temp = S_ss(Z_ss);

    b_ss3(1) = -(a_ss2(7) + b_ss2(7))/2;
    b_ss3(4) = a_old_C2_3;
    b_ss3(8) = Vref;

    a_ss3 = S_temp*b_ss3;
    
    a_old_C2_3 = a_ss3(4);
    Vds_ss3 = (a_ss3(6)+b_ss3(6))/2;

    % Phase-Shifting Unit: 4
    Z_ss(6,6) = nJFETresistanceApprox(Vgs, Vds_ss4);
    S_temp = S_ss(Z_ss);

    b_ss4(1) = -(a_ss3(7) + b_ss3(7))/2;
    b_ss4(4) = a_old_C2_4;
    b_ss4(8) = Vref;

    a_ss4 = S_temp*b_ss4;
    
    a_old_C2_4 = a_ss4(4);
    Vds_ss4 = (a_ss4(6)+b_ss4(6))/2;
    V2(n) = (a_ss4(7)+b_ss4(7))/2;

    % Output Stage
    b_out(1) = V2(n);
    b_out(5) = V1(n);
    b_out(3) = a_old_C3;

    a_out = S_out*b_out;
    
    a_old_C3 = a_out(3);

    Vout(n) = mkupGain*(a_out(6) + b_out(6))/2;
    
end

%% Plot

figure('Color', 'white')
plot(t, Vout, 'Color', [0.3010 0.7450 0.9330], 'LineWidth', 2)
xlabel('Time [s]','interpreter','latex','FontSize',18);
ylabel('Voltage [V]','interpreter','latex','FontSize',18);

