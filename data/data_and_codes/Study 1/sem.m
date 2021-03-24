function e=sem(x)

s = nanstd(x);
n = (sum(~isnan(x)));
e = s/sqrt(n);


end