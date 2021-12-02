coordinates = [0,0,0];
for command in eachline("data.txt")
    dir,numstr = split(command);
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
print("answer 1 = $(prod(coordinates[1:2]))\n")
print("answer 2 = $(prod(coordinates[[1,3]]))\n")
