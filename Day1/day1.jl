data = map(x->parse(Int,x),readlines("data.txt"));
nInc = x->sum(x[2:end].>x[1:end-1]);
print("Answer 1 = $(nInc(data))\n")

rolSum = cumsum(data);
rolSum = rolSum[3:end]-[0; rolSum[1:end-3]];
print("Answer 2 = $(nInc(rolSum))\n")
