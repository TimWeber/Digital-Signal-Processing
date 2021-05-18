%% Initalise
clear
close all
clc

%% 30 Coefficients with scaled passband
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  LP = [0.00163910777009216,0.00155701635298055,-0.000271572826526228,...
      -0.00385917663976946,-0.00606289884257316,-0.00166747354046879,...
      0.00996727307770561,0.0192219088590945,0.0112033063378050,...
      -0.0181373548137942,-0.0487371498908121,-0.0431826559547432,...
      0.0251171075749825,0.143345012478025,0.257488262486346,...
      0.304758575143311,0.257488262486346,0.143345012478025,...
      0.0251171075749825,-0.0431826559547432,-0.0487371498908121,...
      -0.0181373548137942,0.0112033063378050,0.0192219088590945,...
      0.00996727307770561,-0.00166747354046879,-0.00606289884257316,...
      -0.00385917663976946,-0.000271572826526228,0.00155701635298055,...
      0.00163910777009216];
  
  BP = [-0.00246046373959296,0.000457995014070803,-0.000268534006959518,...
      3.49611480652042e-05,0.0112111638335817,0.00494146602025231,...
      -0.0239457094072450,-0.0123820598608381,0.00910924130250227,...
      -0.0131957334520216,0.0403491781279102,0.109156697590956,...
      -0.0734325840992597,-0.240541301122175,0.0379759202770763,...
      0.303972122377013,0.0379759202770763,-0.240541301122175,...
      -0.0734325840992597,0.109156697590956,0.0403491781279102,...
      -0.0131957334520216,0.00910924130250227,-0.0123820598608381,...
      -0.0239457094072450,0.00494146602025231,0.0112111638335817,...
      3.49611480652042e-05,-0.000268534006959518,0.000457995014070803,...
      -0.00246046373959296];
  
  HP = [0.000831572552628297,-0.00202557609781988,0.000543317525020118,...
      0.00384191569607685,-0.00520135689377324,-0.00330206810194288,...
      0.0141057088706359,-0.00683948489989314,-0.0204307235644867,...
      0.0315131561069495,0.00832211523285791,-0.0665646970098028,...
      0.0487311231199695,0.0982737032782511,-0.296937456524611,...'
      0.390134702692845,-0.296937456524611,0.0982737032782511,...
      0.0487311231199695,-0.0665646970098028,0.00832211523285791,...
      0.0315131561069495,-0.0204307235644867,-0.00683948489989314,...
      0.0141057088706359,-0.00330206810194288,-0.00520135689377324,...
      0.00384191569607685,0.000543317525020118,-0.00202557609781988,...
      0.000831572552628297];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate signal

Fs = 48e3;            % Sampling Frequency  
Ts = 1/Fs;            % Sampling Period 
length = Fs/2;        % length of signal
dt = (0:length-1)*Ts; % Sampling Duration

% Select a range of frequencies within the signal
f0  = 0.5e3;
f1  = 1e3;
f2  = 5e3;
f3  = 7.33e3;
f4  = 10e3;
f5  = 12e3;
f6  = 15e3;
f7  = 20e3;
f8  = 22e3;
f9  = 25e3;
f10 = 30e3;

% Create singal
signal = sin(2*pi*f0*dt) + sin(2*pi*f1*dt)  + sin(2*pi*f2*dt) +...
         sin(2*pi*f3*dt) + sin(2*pi*f4*dt)  + sin(2*pi*f5*dt) + ...
         sin(2*pi*f6*dt) + sin(2*pi*f7*dt) + sin(2*pi*f8*dt) + ...
         sin(2*pi*f9*dt) + sin(2*pi*f10*dt);

%% Display Filters

figure
freqz(LP); % Display Lowpass Filter
hold on
freqz(BP); % Display Bandpass Filter
hold on
freqz(HP); % Display Highpass Filter
hold off

% Display Magnitude Response
magnitudeResponse = dfilt.parallel(LP, BP, HP);
freqz(magnitudeResponse)

%% Initial signal
%figure
subplot(5,1,1)
plot(1000*dt,signal)
title('Generated Signal')
xlabel('Time (mS)')
ylabel('X(t)')

%% FFT of signal
Y = fft(signal);
P2 = abs(Y/length);
P1 = P2(1:length/2+1);
P1(2:end-1) = 2* P1(2:end-1);
f = Fs*(0:(length/2))/length;
subplot(5,1,2)
plot(f,P1)
title('FFT of Generated Signal ')
xlabel('frequency(Hz)')
ylabel('|P1(f)|')

%% Low-pass

con_LP = conv(signal, LP);
Y_LP = fft(con_LP);
P2_LP = abs(Y_LP/length);
P1_LP = P2_LP(1:length/2+1);
P1_LP(2:end-1) = 2* P1_LP(2:end-1);
subplot(5,1,3)
plot(f,P1_LP)
title('Output Low-Pass')
xlabel('frequency(Hz))')
ylabel('|P1(f)|')

%% Band-pass

con_BP = conv(signal, BP);
Y_BP = fft(con_BP);
P2_BP = abs(Y_BP/length);
P1_BP = P2_BP(1:length/2+1);
P1_BP(2:end-1) = 2* P1_BP(2:end-1);
subplot(5,1,4)
plot(f,P1_BP)
title('Output Band-Pass')
xlabel('frequency(Hz)')
ylabel('|p1(f)|')

%% High-pass

con_HP = conv(signal, HP);
Y_HP = fft(con_HP);
P2_HP = abs(Y_HP/length);
P1_HP = P2_HP(1:length/2+1);
P1_HP(2:end-1) = 2* P1_HP(2:end-1);
subplot(5,1,5)
plot(f,P1_HP)
title('Output High-Pass')
xlabel('frequency(Hz)')
ylabel('|P1(f)|')

%% Comination equaliser
% Initial signal
figure
subplot(3,1,1)
plot(1000*dt,signal)
title('Generated Signal')
xlabel('Time (mS)')
ylabel('X(t)')

% FFT of signal
Y = fft(signal);
P2 = abs(Y/length);
P1 = P2(1:length/2+1);
P1(2:end-1) = 2* P1(2:end-1);
f = Fs*(0:(length/2))/length;
subplot(3,1,2)
plot(f,P1)
title('FFT of Generated Signal ')
xlabel('frequency(Hz)')
ylabel('|P1(f)|')

% combine the convolved signals from the filters
allFilters = con_LP + con_BP + con_HP;
Y_t = fft(allFilters);
P2_t = abs(Y_t/length);
P1_t = P2_t(1:length/2+1);
P1_t(2:end-1) = 2* P1_t(2:end-1);
subplot(3,1,3)
plot(f,P1_t)
title('Output of EQ ')
xlabel('frequency(Hz)')
ylabel('|P1(f)|')