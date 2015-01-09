C = dlmread ("numbers.txt");
H = hist (C, max (C));
C = H ./ sum (H);
figure;
bar(C);
print -dsvg hist.svg
