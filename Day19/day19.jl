function day19(file)
    @enum Rotation clockwise0 clockwise90 clockwise180 clockwise270;
    @enum Axis X Y Z;
    @enum Facing up=1 down=-1;
    const Orientation = NamedTuple{(:axis,:facing,:rotation),Tuple{Axis,Facing,Rotation}}
    const Position    = CartesianIndex{3};
    const ScannerPair = NamedTuple{(:scanner1,:scanner2,:relativeorientation2,:offset2),Tuple{Int,Int,Orientation,Position}}
    const allorientations = Tuple(Orientation((a,f,r)) for a in instances(Axis)
                                                       for f in instances(Facing)
                                                       for r in instances(Rotation));
    overlappingscanners = Vector{ScannerPair}();
    scanners = parsescanners(file);
    for i in 1:(length(scanners)-1), j in i:length(scanners)
        for orientation2 in allorientations
            offset2 = matchscanners(scanners[i],scanners[j],orientation2);
            if !isnothing(offset2)
                push!(overlappingscanners,ScannerPair((i,j,orientation2,offset2)))
            end
        end
    end
    readings = standardisescanners(scanners,overlappingscanners);
    return length(unique(readings))
end

function parsescanners(file)::Vector{Vector{Position}}
    data = readlines(file);
    breaks = [findall(startswith.(data,"--- scanner")); length(data)+2];
    scanners = [[parse.(Int,x) for x in split.(data[(breaks[i]+1):(breaks[i+1]-2)],",")] for i in 1:(length(breaks)-1)]
    return scanners
end

function matchscanners(scanner1::Vector{Position},scanner2::Vector{Position},orientation::Orientation)::Union{Nothing,Position}

end

function rotatereport(p::Position,orientation::Orientation)::Position
    if     orientation.axis == X # do nothing
    elseif orientation.axis == Y p = CartesianIndex((p.I[2],-1*p.I[1],p.I[3]));
    elseif orientation.axis == Z p = CartesianIndex((p.I[3],p.I[2],-1*p.I[1]));
    end
    if orientation.facing==down p = CartesianIndex(p.I.*(-1,1,-1)); end
    if     orientation.rotation == clockwise0 # do nothing
    elseif orientation.rotation == clockwise90 p = CartesianIndex((p.I[1],-1*p.I[3],p.I[2]));
    elseif orientation.rotation == clockwise180 p = CartesianIndex(p.I.*(1,-1,-1));
    elseif orientation.rotation == clockwise270 p = CartesianIndex((p.I[1],p.I[3],-1*p.I[2]));
    end
    return p
end

function standardisescanners(scanners::Vector{Vector{Position}},overlappingscanners::Vector{ScannerPair})::Vector{Position}
    
end

