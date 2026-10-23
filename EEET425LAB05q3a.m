%%EEET 425 LAB 06 Q3a

B = 3; %number of fractional bits
N = 30; %number of output samples
n = 0:N-1; %time index

y_ideal = zeros(1, N); %preallocate ideal output
y_sat = zeros(1, N); %preallocate rounding and saturation output
y_2c = zeros(1, N); %preallocate rounding and 2C overflow output

y1 = -0.875; %y(-1)
y2 = 0.875; %y(-2)
for i = 1:N
    y_ideal(i) = 0.875 * y1 - 0.875 * y2; %no quantization, no overflow
    y2 = y1; %shift the delays
    y1 = y_ideal(i);
end
figure;
stem(n, y_ideal, 'filled'); %part a ideal output

y1 = -0.875; %reset y(-1)
y2 = 0.875; %reset y(-2)

for i = 1:N
    q1 = round(0.875 * y1 * (2^B)) * (2^(-B)); %rounding of the 0.875y(n-1) product
    q2 = round(-0.875 * y2 * (2^B)) * (2^(-B)); %rounding of the -0.875y(n-2) product
    s = q1 + q2; %addition, can go outside [-1, 1)
    y_sat(i) = max(-1, min(s, 1 - 2^(-B))); %saturation
    y2 = y1; %shift the delays
    y1 = y_sat(i);
end

figure;
stem(n, y_sat, 'filled'); %part b rounding and saturation output

y1 = -0.875; %reset y(-1)
y2 = 0.875; %reset y(-2)
for i = 1:N
    s = 0.875 * y1 - 0.875 * y2; %sum before quantization
    s = round(s * (2^B)) * (2^(-B)); %rounding of the whole sum
    y_2c(i) = 2 * (mod((s / 2) - 0.5, 1) - 0.5); %2C overflow
    y2 = y1; %shift the delays
    y1 = y_2c(i);
end

figure;
stem(n, y_2c, 'filled'); %part c rounding and 2C overflow output