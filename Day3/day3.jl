mat = reduce(vcat,permutedims.(collect.(readlines("data.txt")))).=='1';
mostpop(x) = sum(x) .>= length(x)/2;
bin2int(bin) = parse(Int,reduce(*,string.(Int.(bin))),base=2);
gammabin = mostpop.(eachcol(mat));
gamma    = bin2int(gammabin);
epsilon  = bin2int(.!gammabin);
println("Answer 1 = $(gamma*epsilon)")

function applyrule(m,inrule)
    j = 0;
    while size(m,1)>1
        j += 1;
        m = m[inrule(m[:,j]),:]
    end
    bin2int(m);
end

oxygen = applyrule(mat,x-> x .== mostpop(x));
co2    = applyrule(mat,x-> x .!== mostpop(x));
println("Answer 2 = $(oxygen*co2)")
