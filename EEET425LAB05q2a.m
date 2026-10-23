%EEET 425 LAB 06 Q2a

B = 3; %number of fractional bits
N = 30; %number of output samples
n = 0:N-1; %time index

x = zeros(1, N); %input signal
x(1) = 0.375; %x(n) = 0.375 delta(n), only x(0) is nonzero

y_round = zeros(1, N); %preallocate rounding output
y_trunc = zeros(1, N); %preallocate truncation output
y1 = 0; %y(n-1), initially relaxed
y2 = 0; %y(n-2), initially relaxed

for i = 1:N
    q1 = round(0.875 * y1 * (2^B)) * (2^(-B)); %rounding of the 0.875y(n-1) product
    q2 = round(-0.75 * y2 * (2^B)) * (2^(-B)); %rounding of the -0.75y(n-2) product
    y_round(i) = q1 + q2 + x(i);
    y2 = y1; %shift the delays
    y1 = y_round(i);
end

figure;
stem(n, y_round, 'filled'); %rounding output

y1 = 0; %reset y(n-1) = 0
y2 = 0; %reset y(n-2) = 0

for i = 1:N
    q1 = floor(0.875 * y1 * (2^B)) * (2^(-B)); %truncation of the 0.875y(n-1) product
    q2 = floor(-0.75 * y2 * (2^B)) * (2^(-B)); %truncation of the -0.75y(n-2) product
    y_trunc(i) = q1 + q2 + x(i);
    y2 = y1; %shift the delays
    y1 = y_trunc(i);
end

figure;
stem(n, y_trunc, 'filled'); %truncation output
disp([n', y_round', y_trunc']); %columns: n, round, trunc