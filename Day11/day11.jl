function day11(file)
    mat = reduce(vcat,[[parse(Int,c) for c in l]' for l in eachline(file)]);
    flashcount = 0;
    stepwhenallflashed = NaN;
    step = 0;
    while isnan(stepwhenallflashed) || step<100
        step += 1;
        flashedthisstep = falses(size(mat)...);
        mat .+= 1;
        flash = mat.>9;
        while any(flash)
            flashedthisstep[flash] .= true;
            for ind in Tuple.(findall(flash))
                for i in [-1,0,1], j in [-1,0,1]
                    ix = ind .+ [i,j];
                    if all(ix.>0) && all(ix.<=size(mat))
                        mat[ix...] += 1;
                    end
                end
            end
            flash = (mat.>9) .& .!flashedthisstep;
        end
        if step<=100 flashcount += sum(flashedthisstep); end
        if isnan(stepwhenallflashed) && all(flashedthisstep)
            stepwhenallflashed = step;
        end
        mat[flashedthisstep] .= 0;
    end
    return flashcount,stepwhenallflashed
end
