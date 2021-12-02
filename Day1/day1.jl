data = map(x->parse(Int,x),readlines("data.txt"));
nincreases = x->sum(x[2:end].>x[1:end-1]);
print("Answer 1 = $(nincreases(data))\n")

rolsum = cumsum(data);
rolSum = rolsum[3:end]-[0; rolsum[1:end-3]];
print("Answer 2 = $(nincreases(rolsum))\n")
