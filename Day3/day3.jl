data = readlines(if isempty(ARGS) "data.txt" else ARGS[1] end);
mat = reduce(vcat,permutedims.(collect.(data))).=='1';
gammabin = sum(mat,dims=1) .>= size(mat,1)/2;
bin2dec(binarray) = parse(Int,reduce(*,map(x->string(Int(x)),binarray)),base=2);
gamma   = bin2dec(gammabin);
epsilon = bin2dec(.!gammabin);
print("Answer 1 = $(gamma*epsilon)\n")

function applyrule(m,inrule)
    j = 0;
    while size(m,1)>1
        j += 1;
        m = m[inrule(m[:,j]),:]
    end
    return bin2dec(m);
end

oxygenrule(x) = x .== (sum(x,dims=1) .>= size(x,1)/2);
co2rule(x)    = .!oxygenrule(x);
oxygen = applyrule(mat,oxygenrule)
co2    = applyrule(mat,co2rule)
print("Answer 2 = $(oxygen*co2)\n")
