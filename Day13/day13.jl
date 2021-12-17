function day13(file)
    data = readlines(file);
    splitline = findfirst(data.=="");
    coordinates = [(parse.(Int,a).+1) for a in split.(data[1:(splitline-1)],",")];
    instructionsstr = split.(replace.(data[(splitline+1):end],"fold along "=>""),"=");
    instructions = [(a,parse(Int,b)+1) for (a,b) in instructionsstr];

    foldedindsafter1 = [CartesianIndex(foldup(c,instructions[1][1],instructions[1][2])...) for c in coordinates];
    for (axis,foldval) in instructions
        coordinates = [foldup(c,axis,foldval) for c in coordinates];
    end
    cartescoords = unique([CartesianIndex(c...) for c in coordinates]);
    out = zeros(Int,maximum(reduce(hcat,coordinates),dims=2)...);
    out[cartescoords] .= 1;
    return length(unique(foldedindsafter1)), out'
end

function foldup(index,axis,value)
    ix = axis=="x" ? 1 : 2;
    if index[ix]>value
        index[ix] += 2*(value-index[ix]);
    end
    return index
end
