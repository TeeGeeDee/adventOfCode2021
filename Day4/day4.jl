data     = readlines("data.txt");
callouts = parse.(Int,split(data[1],","));
boards = [parse.(Float64,reduce(hcat,split.(data[i:i+4]))) for i in 3:6:length(data)-4];

finished = falses(length(boards));
for callednum in callouts, i in 1:length(boards)
    if finished[i] continue end
    boards[i][boards[i].==callednum] .= NaN;
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
