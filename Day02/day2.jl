function day2(file)
    coordinates = [0,0,0];
    for (dir,numstr) in split.(eachline(file))
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
    return prod(coordinates[1:2]), prod(coordinates[[1,3]])
end
