data = readlines("data.txt");
coordinates = [0,0,0];
for command in data
    dir,numstr = split(command);
    num = parse(Int,numstr);
    coordinates[1+(dir!="forward")] += num * (1-2*(dir=="up"));
    if dir=="forward"
        coordinates[3] += num * coordinates[2]
    end
end
print("answer 1 = $(prod(coordinates[1:2]))\n")
print("answer 2 = $(prod(coordinates[[1,3]]))\n")
