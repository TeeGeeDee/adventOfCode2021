data = readlines("data.txt");
mat = reduce(vcat,permutedims.(collect.(data))).=='1';
mostpop(x) = sum(x) .>= length(x)/2;
bin2dec(binarray) = parse(Int,reduce(*,string.(Int.(binarray))),base=2);
gammabin = mostpop.(eachcol(mat));
gamma    = bin2dec(gammabin);
epsilon  = bin2dec(.!gammabin);
print("Answer 1 = $(gamma*epsilon)\n")

function applyrule(m,inrule)
    j = 0;
    while size(m,1)>1
        j += 1;
        m = m[inrule(m[:,j]),:]
    end
    return bin2dec(m);
end

oxygen = applyrule(mat,x-> x .== mostpop(x));
co2    = applyrule(mat,x-> x .!== mostpop(x));
print("Answer 2 = $(oxygen*co2)\n")
