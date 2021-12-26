using DataStructures

function day20(file)
    data = readlines(file);
    algo = [p=='#' for p in foldl(*,data[1:findfirst(data.=="")])];
    imageinput = data[(findfirst(data.=="")+1):end];
    inputmatrix = reduce(vcat,[[p=='#' for p in row]' for row in imageinput]);

    pixelstate = DefaultDict{CartesianIndex{2},Bool}(false);
    for pixel in findall(inputmatrix) pixelstate[pixel] = true; end
    kernel = permutedims(CartesianIndices((-1:1,-1:1)))[:];

    enhance(pixelstates,algo) = algo[parse(Int,reduce(*,string.(Int.(pixelstates))),base=2)+1];
    updatedefault(d,algo)     = enhance(fill(d,9),algo);
    numpixelson(state)        = state.d.default ? Inf : sum(values(state));

    for i in 1:50
        newstate = DefaultDict{CartesianIndex{2},Bool}(updatedefault(pixelstate.d.default,algo));
        mins,maxes = minimum(keys(pixelstate)),maximum(keys(pixelstate));
        for pixel in CartesianIndices(((mins[1]-1):(maxes[1]+1),(mins[2]-1):(maxes[2]+1)))
            newstate[pixel] = enhance([pixelstate[pixel+k] for k in kernel],algo);
        end
        pixelstate = newstate;
        if i==2 global part1 = numpixelson(pixelstate); end
    end
    return part1,numpixelson(pixelstate)
end
