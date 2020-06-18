%load the ecg file
clc
load('100m.mat');
ecg=(val-0)/200;
fs=360;
N=length(ecg);
t=((0:length(ecg)-1)/fs);
figure(1)
plot(t,ecg)
title('Corrupted ECG Signal')
xlabel('Time[sec]')
ylabel('Amplitude')
grid on

%high pass filter to remove baseline noise
[b2,a2]=butter(2,.5/(fs/2),'high');
m=filtfilt(b2,a2,ecg);
figure(2)
plot(t,ecg,t,m)
title('Filtered ECG signal with baseline removed')
xlabel('Time[sec]')
ylabel('Amplitude')
legend('unfiltered','filtered')


% m = designfilt('bandstopiir','FilterOrder',2, ...
%                'HalfPowerFrequency1',0.1,'HalfPowerFrequency2',0.5, ...
%                'DesignMethod','butter','SampleRate',fs);
% fvtool(m,'fs',fs)

%to check freq response of orignal signal

Ys=fft(ecg);
Ys=fftshift(Ys);
equal_space=linspace(0,0.5,N/2); %adjusting freq range interval
freq=(fs/2)*equal_space;
Ys=Ys(1:ceil(N)/2);
figure(3)
plot(freq,2*abs(Ys))
title('ECG signal in freq Domain(original)')
xlabel('Frequency(Hz)')
ylabel('|Y(f)|')

%To check frequency response of filtered signal
% 
% Ys=fft(m);
% Ys=fftshift(Ys);
% equal_space=linspace(0,0.5,N/2); %adjusting freq range interval
% freq=(fs/2)*equal_space;
% Ys=Ys(1:ceil(N)/2);
% figure(4),
% plot(freq,2*abs(Ys))
% title('ECG signal in freq Domain(Baseline Noise free)')
% xlabel('Frequency(Hz)')
% ylabel('|Y(f)|')


%designing of low pass notch filter

w=60/(360/2);
bw=w/35;
[d,c]=iirnotch(w,bw); % notch filter implementation 
ecg_notch=filter(d,c,m);
figure(4)
N1=length(ecg_notch);
t1=(0:N1-1)/fs;
y1 = sgolayfilt(ecg_notch,0,5);
plot(t1,ecg,t1,y1);
legend('unfiltered','filtered')
title('Filtered ECG signal with powerline removed ')             
xlabel('time')
ylabel('amplitude')

%To check freq response of filtered signal
Ys=fft(y1);
Ys=fftshift(Ys);
equal_space=linspace(0,0.5,N/2); %adjusting freq range interval
freq=(fs/2)*equal_space;
Ys=Ys(1:ceil(N)/2);
figure(5),
plot(freq,2*abs(Ys))
title('ECG signal in freq Domain(Powerline noise free')
xlabel('Frequency(Hz)')
ylabel('|Y(f)|')