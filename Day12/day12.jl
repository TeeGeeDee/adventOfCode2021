function day12(file)
    moves = Dict{String,Set{String}}();
    addpath!(a,b,d::Dict) = haskey(d,a) ? push!(d[a],b) :
                                          d[a] = Set{String}((b,));
    for  (a,b) in split.(eachline(file),"-")
        addpath!(a,b,moves);
        addpath!(b,a,moves);
    end
    for k in keys(moves) moves[k] = setdiff(moves[k],("start",)) end # don't go back to start

    function numpathsfrom(position,visitedsmallcaves,isonevisitonly)
        if position=="end" return 1 end
        if all(islowercase.(collect(position)))
            beenbefore = position in visitedsmallcaves;
            if isonevisitonly && beenbefore
                return 0
            elseif beenbefore
                isonevisitonly = true; # from now on one visit only
            else
                push!(visitedsmallcaves,position);
            end
        end
        next = moves[position];
        if isonevisitonly
            next = setdiff(next,visitedsmallcaves);
        end
        if isempty(next) return 0 end
        return sum(numpathsfrom(p,copy(visitedsmallcaves),isonevisitonly) for p in next)
    end
    return numpathsfrom("start",Set{String}(),true),numpathsfrom("start",Set{String}(),false)
end
