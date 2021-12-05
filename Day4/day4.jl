function day4(file)
    data     = readlines(file);
    callouts = parse.(Int,split(data[1],","));
    boards = [parse.(Float64,reduce(hcat,split.(data[i:i+4]))) for i in 3:6:length(data)-4];

    done = falses(length(boards));
    answers = Vector{Int}();
    for callednum in callouts, i in 1:length(boards)
        if done[i] continue end
        boards[i][boards[i].==callednum] .= NaN;
        hits = isnan.(boards[i]);
        done[i] |= any(all(hits,dims=1)) || any(all(hits,dims=2));
        if done[i]
            score = callednum * sum(Int.(boards[i][.!hits]));
            if     sum(done)==1  push!(answers,score);
            elseif all(done)     push!(answers,score);
                break
            end
        end
    end
    return reduce(tuple,answers)
end
