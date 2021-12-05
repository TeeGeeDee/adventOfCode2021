function day3(file)
    mat = reduce(vcat,permutedims.(collect.(readlines(file)))).=='1';
    mostpop(x) = sum(x) .>= length(x)/2;
    bin2int(bin) = parse(Int,reduce(*,string.(Int.(bin))),base=2);
    gammabin = mostpop.(eachcol(mat));
    gamma    = bin2int(gammabin);
    epsilon  = bin2int(.!gammabin);

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
    return gamma*epsilon,oxygen*co2
end
