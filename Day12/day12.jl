function day12(file)
    moves = Dict{String,Set{String}}();
    addpath!(a,b,d::Dict) = haskey(d,a) ? push!(d[a],b) :
                                          d[a] = Set{String}((b,));
    for (a,b) in split.(eachline(file),"-")
        addpath!(a,b,moves);
        addpath!(b,a,moves);
    end
    for k in keys(moves) setdiff!(moves[k],("start",)); end # don't go back to start

    function numpathsfrom(cave,visitedsmallcaves,isonevisitonly)
        if cave=="end" return 1 end
        if all(islowercase.(collect(cave)))
            beenbefore = cave in visitedsmallcaves;
            if isonevisitonly && beenbefore  return 0
            elseif beenbefore                isonevisitonly = true; # from now on one visit only
            else                             push!(visitedsmallcaves,cave);
            end
        end
        next = moves[cave];
        if isonevisitonly next = setdiff(next,visitedsmallcaves); end
        if isempty(next)  return 0 end
        return sum(numpathsfrom(c,copy(visitedsmallcaves),isonevisitonly) for c in next)
    end
    return numpathsfrom("start",Set{String}(),true),numpathsfrom("start",Set{String}(),false)
end
