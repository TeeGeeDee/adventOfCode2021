data = readlines(if isempty(ARGS) "data.txt" else ARGS[1] end);
callouts = map(x->parse(Int,x),split(data[1],","));
nboards  = Int((length(data)-1)/6);
boards   = Vector{Matrix}(undef,nboards);
hits     = Vector{Matrix}(undef,nboards);
for i in 1:nboards
    boards[i] = parse.(Int,reduce(hcat,split.(data[3+(i-1)*6:i*6+1])));
    hits[i]   = falses(5,5);
end
finished = falses(nboards);

for callednum in callouts, i in 1:length(boards)
    hits[i][boards[i].==callednum] .= true;
    if !finished[i] & (any(all(hits[i],dims=1)) | any(all(hits[i],dims=2)))
        bingo = callednum*sum(boards[i][.!hits[i]]);
        if !any(finished)
            print("Winning score = $bingo\n");
        end
        finished[i] = true;
        if all(finished)
            print("Losing score = $bingo\n");
            break
        end

    end
end

