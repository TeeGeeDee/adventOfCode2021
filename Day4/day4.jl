data = readlines(if isempty(ARGS) "data.txt" else ARGS[1] end);
callouts = map(x->parse(Int,x),split(data[1],","));
nboards  = Int((length(data)-1)/6);
boards = [parse.(Float64,reduce(hcat,split.(data[3+(i-1)*6:i*6+1]))) for i in 1:nboards];
finished = falses(nboards);
for callednum in callouts, i in 1:length(boards)
    if finished[i] continue end
    boards[i][boards[i].==callednum] .= NaN; # mark the board
    hits = isnan.(boards[i]);
    if any(all(hits,dims=1)) | any(all(hits,dims=2))
        score = callednum * sum(Int.(boards[i][.!hits]));
        if !any(finished)
            print("Part 1 score = $score\n");
        end
        finished[i] = true;
        if all(finished)
            print("Part 2 score = $score\n");
            break
        end
    end
end
