data = parse.(Int,readlines("data.txt"));
nincreases(x) = sum(x[i]>x[i-1] for i in 2:length(x));
print("Answer 1 = $(nincreases(data))\n")

rolsum = cumsum(data);
rolSum = rolsum[3:end]-[0; rolsum[1:end-3]];
print("Answer 2 = $(nincreases(rolsum))\n")
