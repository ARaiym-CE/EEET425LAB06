%EEET 425 LAB 06 Q1a

B = 3; %number of fractional bits
N = 16; %number of output samples
n = 0:N-1; %time index
alpha = 1/2; %high-pass filter

x = zeros(1, N); %input signal
x(1) = 7/8; %x(n) = 7/8 delta(n), only x(0) is nonzero

y_round = zeros(1, N); %preallocate rounding output
y_trunc = zeros(1, N); %preallocate truncation output
yprev = 0; %y(-1) = 0

for i = 1:N
    q = round(alpha * yprev * (2^B)) * (2^(-B)); %rounding operation on the multiplication
    y_round(i) = q + x(i);
    yprev = y_round(i);
end

figure;
stem(n, y_round, 'filled'); %rounding output
yprev = 0; %reset y(-1) = 0

for i = 1:N
    q = floor(alpha * yprev * (2^B)) * (2^(-B)); %truncation operation on the multiplication
    y_trunc(i) = q + x(i);
    yprev = y_trunc(i);
end

figure;
stem(n, y_trunc, 'filled'); %truncation output
