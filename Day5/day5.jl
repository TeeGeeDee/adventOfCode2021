function day5(file)
    data = split.(replace.(readlines(file)," -> " => ","),",");
    data = parse.(Int,reduce(hcat,data))' .+ 1; # 0 indexing -> 1 indexing
    atob(x,y) = x:(x<y ? 1 : -1):y;

    function countoverlaps(linedata,includediagonal)
        gridsize = maximum(linedata);
        grid = zeros(gridsize,gridsize);
        for (x1,y1,x2,y2) in eachrow(linedata)
            if x1==x2
                grid[x1,atob(y1,y2)] .+= 1
            elseif y1==y2
                grid[atob(x1,x2),y1] .+= 1
            elseif includediagonal
                grid[CartesianIndex.(zip(atob(x1,x2),atob(y1,y2)))] .+= 1
            end
        end
        return sum(grid.>1)
    end

    return countoverlaps(data,false), countoverlaps(data,true)
end
