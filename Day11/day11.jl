using Memoization

function day11(file)
    mat = reduce(vcat,[[parse(Int,c) for c in l]' for l in eachline(file)]);
    @memoize function neighbourindices(ind)
        neighbours = [];
        for i in [-1,0,1], j in [-1,0,1]
            if i == j == 0 continue end
            ix = CartesianIndex(ind.I .+ (i,j));
            if checkbounds(Bool,mat,ix) push!(neighbours,ix); end
        end
        return neighbours
    end

    flashcount,step,whenallflashed = 0,0,0;
    while whenallflashed==0 || step<100
        step += 1;
        mat .+= 1;
        hasflashed = justflashed = mat.>9;
        while any(justflashed)
            for flashpoint in findall(justflashed), ind in neighbourindices(flashpoint)
                mat[ind] += 1;
            end
            justflashed = (mat.>9) .& .!hasflashed;
            hasflashed .|= justflashed;
        end
        if step<=100 flashcount += sum(hasflashed); end
        if whenallflashed==0 && all(hasflashed)
            whenallflashed = step;
        end
        mat[hasflashed] .= 0;
    end
    return flashcount,whenallflashed
end
