using Memoization

function day11(file)
    mat = reduce(vcat,[[parse(Int,c) for c in l]' for l in eachline(file)]);
    matsize = size(mat);
    @memoize function neighbourindices(ind)
        ind = Tuple(ind);
        neighbours = [];
        for i in [-1,0,1], j in [-1,0,1]
            if i == j == 0 continue end
            ix = ind .+ [i,j];
            if all(ix.>0) && all(ix.<=matsize)
                push!(neighbours,ix);
            end
        end
        return neighbours
    end

    flashcount,step,whenallflashed = 0,0,NaN;
    while isnan(whenallflashed) || step<100
        step += 1;
        mat .+= 1;
        hasflashed = justflashed = mat.>9;
        while any(justflashed)
            for flashpoint in findall(justflashed), ind in neighbourindices(flashpoint)
                mat[ind...] += 1;
            end
            justflashed = (mat.>9) .& .!hasflashed;
            hasflashed .|= justflashed;
        end
        if step<=100 flashcount += sum(hasflashed); end
        if all(hasflashed) && isnan(whenallflashed)
            whenallflashed = step;
        end
        mat[hasflashed] .= 0;
    end
    return flashcount,whenallflashed
end
