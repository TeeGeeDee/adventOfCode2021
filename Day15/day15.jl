using DataStructures

function day15(file)
    mat = reduce(vcat,[[parse(Int,c) for c in l]' for l in eachline(file)]);
    bigmat = zeros((size(mat).*5)...);
    h,w = size(mat);
    for i = 0:4, j = 0:4
        bigmat[(i*h+1):((i+1)*h),(j*w+1):((j+1)*w)] = mod.(mat.+i.+j.-1,9).+1;
    end
    return shortestpath(mat),shortestpath(bigmat)
end

function shortestpath(mat)
    biggestdist = sum(mat);
    unvisited = PriorityQueue{CartesianIndex{2},Int}();
    for ind in CartesianIndices(mat)
        startdist = ind == CartesianIndex(1,1) ? 0 : biggestdist;
        enqueue!(unvisited,ind,startdist);
    end
    currentdist = 0; # so the variable is global
    while CartesianIndex(size(mat)...) ∈ keys(unvisited)
        current,currentdist = dequeue_pair!(unvisited);
        for i in intersect(neighbours(current,mat),keys(unvisited))
            thiswaydist = currentdist+mat[i];
            if thiswaydist<unvisited[i]
                unvisited[i] = thiswaydist;
            end
        end
    end
    return currentdist
end

function neighbours(ind,mat)
    out = Vector{CartesianIndex{2}}();
    for mv in ((1,0),(-1,0),(0,1),(0,-1))
        i = CartesianIndex(ind.I .+ mv);
        if checkbounds(Bool,mat,i)
            push!(out,i);
        end
    end
    return out
end
