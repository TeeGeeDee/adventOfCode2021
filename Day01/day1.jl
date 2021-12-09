function day1(file)
    data = parse.(Int,readlines(file));
    nincreases(x) = sum(x[i]>x[i-1] for i in 2:length(x));
    rolsum = cumsum(data);
    rolsum = rolsum[3:end]-[0; rolsum[1:end-3]];
    return nincreases(data),nincreases(rolsum)
end
