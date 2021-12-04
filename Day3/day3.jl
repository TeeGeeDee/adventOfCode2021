data = readlines(if isempty(ARGS) "data.txt" else ARGS[1] end);
freq = [[c=='1' for c in s] for s in data];
gammabin = sum(freq).>(length(freq)/2);
bin2dec(binarray) = parse(Int,reduce(*,map(x->string(Int(x)),binarray)),base=2)
gamma   = bin2dec(gammabin)
epsilon = bin2dec(.!gammabin)
print("Answer 1 = $(gamma*epsilon)\n")

function applyrule(mydata,inrule)
    pos = 0;
    while length(mydata)>1
        pos += 1;
        mydata = mydata[inrule([d[pos] for d in mydata])]
    end
    return parse(Int,mydata[1],base=2)
end

oxygenrule(x) = x.== if sum(x.=='1')>=(length(x)/2) '1' else '0' end;
co2rule(x) = .!oxygenrule(x);
oxygen = applyrule(data,oxygenrule);
co2    = applyrule(data,co2rule);
print("Answer 2 = $(oxygen*co2)\n")

