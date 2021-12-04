file = "data.txt";
freq = [[c=='1' for c in s] for s in eachline(file)];
gammabin = sum(freq).>(length(freq)/2);
bin2dec(binarray) = parse(Int,reduce(*,map(x->string(Int(x)),binarray)),base=2)
gamma = bin2dec(gammabin)
epsilon = bin2dec(.!gammabin)
print("Answer 1 = $(gamma*epsilon)\n")

function applyrule(mydata,incond)
    pos = 0;
    while (pos<length(mydata[1])) & (length(mydata)>1)
        pos += 1;
        mydata = mydata[incond([d[pos] for d in mydata])]
    end
    return parse(Int,mydata[1],base=2)
end

oxygenincluded(x) = x.== if sum(x.=='1')>=(length(x)/2) '1' else '0' end
co2included(x) = .!oxygenincluded(x)
oxygen = applyrule(readlines(file),oxygenincluded)
co2 = applyrule(readlines(file),co2included)
print("Answer 2 = $(oxygen*co2)\n")

