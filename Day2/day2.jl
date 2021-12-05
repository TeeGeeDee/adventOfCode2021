coordinates = [0,0,0];
for (dir,numstr) in split.(eachline("data.txt"))
    num = parse(Int,numstr);
    if dir=="forward"
        coordinates[1] += num
        coordinates[3] += num * coordinates[2]
    elseif dir=="up"
        coordinates[2] -= num;
    elseif dir=="down"
        coordinates[2] += num;
    end
end
println("answer 1 = $(prod(coordinates[1:2]))")
println("answer 2 = $(prod(coordinates[[1,3]]))")
