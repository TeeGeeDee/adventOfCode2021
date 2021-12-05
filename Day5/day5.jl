data = split.(replace.(readlines("data.txt")," -> " => ","),",");
data = parse.(Int,reduce(hcat,data))' .+ 1; # 0 indexing -> 1 indexing

function countoverlaps(linedata,includediagonal)
    grid = zeros(maximum(linedata),maximum(linedata));
    for (x1,y1,x2,y2) in eachrow(linedata)
        if x1==x2
            grid[x1,range(sort([y1,y2])...)] .+= 1
        elseif y1==y2
            grid[range(sort([x1,x2])...),y1] .+= 1
        elseif includediagonal
            xinc = x1<x2 ? 1 : -1
            yinc = y1<y2 ? 1 : -1
            grid[[CartesianIndex(x1+i*xinc,y1+i*yinc) for i = 0:abs(x1-x2)]] .+= 1
        end
    end
    return sum(grid.>1)
end

println("Answer 1 = $(countoverlaps(data,false))")
println("Answer 2 = $(countoverlaps(data,true))")