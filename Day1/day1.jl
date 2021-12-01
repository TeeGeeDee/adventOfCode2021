data = readlines("data.txt");
data = map(x->parse(Int,x),data);
sumIncreases = x->sum(x[2:end].>x[1:end-1]);
print("Number of increases = "*string(numIncreases(data))*"\n")

rolSum = cumsum(data);
rolSum = rolSum[3:end]-[0; rolSum[1:end-3]];
print("Number of increases in rolling sum = "*string(numIncreases(rolSum)))
