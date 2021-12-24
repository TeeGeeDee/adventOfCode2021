@enum Rotation clockwise0 clockwise90 clockwise180 clockwise270;
@enum Axis X Y Z;
@enum Facing up=1 down=-1;
const Orientation = NamedTuple{(:axis,:facing,:rotation),Tuple{Axis,Facing,Rotation}}
const Position    = CartesianIndex{3};
const ScannerPair = NamedTuple{(:scanner1,:scanner2,:relativeorientation2,:offset2),Tuple{Int,Int,Orientation,Position}}
const allorientations = Tuple(Orientation((a,f,r)) for a in instances(Axis)
                                                   for f in instances(Facing)
                                                   for r in instances(Rotation));

function day19(file)
    scanners = parsescanners(file);
    overlappingscanners = Vector{ScannerPair}();
    for i in 1:(length(scanners)-1), j in (i+1):length(scanners)
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

i = 1;
mapped = Set(1);
checkedpairs = Set();
overlappingscanners = Vector{ScannerPair}();
while length(mapped)<length(scanners)
    for j = setdiff(1:length(scanners),union(checkedpairs,i))
        for orientation2 in allorientations
            offset2 = matchscanners(scanners[i],scanners[j],orientation2);
            if !isnothing(offset2)
                push!(overlappingscanners,ScannerPair((i,j,orientation2,offset2)))
                push!(mapped,j);
            end
        end
    end
    push!(checkedpairs,i);
    lefttodo = setdiff(mapped,checkedpairs);
    if isempty(lefttodo) break end
    i = first(lefttodo);
end



function parsescanners(file)::Vector{Vector{Position}}
    data = readlines(file);
    breaks = [findall(startswith.(data,"--- scanner")); length(data)+2];
    scanners = [[Position(parse.(Int,x)...) for x in split.(data[(breaks[i]+1):(breaks[i+1]-2)],",")] 
                                                  for i in 1:(length(breaks)-1)];
    return scanners
end

function matchscanners(scanner1::Vector{Position},scanner2::Vector{Position},orientation::Orientation)::Union{Nothing,Position}
    scanner2 = [rotate(p,orientation) for p in scanner2];
    out::Union{Nothing,Position} = nothing;
    for i1 = 1:length(scanner1), i2 = 1:length(scanner2)
        offset = scanner2[i2].I .- scanner1[i1].I;
        if any(offset.>1000) continue end
        centred2 = [Position(p.I.-offset) for p in scanner2];
        if length(intersect(scanner1,centred2))>=12
            out = Position(offset);
            break
        end
    end
    return out
end

function rotate(p::Position,orientation::Orientation)::Position
    if     orientation.axis == X # do nothing
    elseif orientation.axis == Y p = Position((p.I[2],-1*p.I[1],p.I[3]));
    elseif orientation.axis == Z p = Position((p.I[3],p.I[2],-1*p.I[1]));
    end
    if orientation.facing==down p = Position(p.I.*(-1,1,-1)); end
    if     orientation.rotation == clockwise0 # do nothing
    elseif orientation.rotation == clockwise90  p = Position((p.I[1],-1*p.I[3],p.I[2]));
    elseif orientation.rotation == clockwise180 p = Position(p.I.*(1,-1,-1));
    elseif orientation.rotation == clockwise270 p = Position((p.I[1],p.I[3],-1*p.I[2]));
    end
    return p
end

function unrotate(p::Position,orientation::Orientation)::Position
    if     orientation.rotation == clockwise0 # do nothing
    elseif orientation.rotation == clockwise270 p = Position((p.I[1],-1*p.I[3],p.I[2]));
    elseif orientation.rotation == clockwise180 p = Position(p.I.*(1,-1,-1));
    elseif orientation.rotation == clockwise90  p = Position((p.I[1],p.I[3],-1*p.I[2]));
    end
    if orientation.facing==down p = Position(p.I.*(-1,1,-1)); end
    if     orientation.axis == X # do nothing
    elseif orientation.axis == Y p = Position((-1*p.I[2],p.I[1],p.[3]))
    elseif orientation.axis == Z p = Position((-1*p.I[3],p.I[2],p.I[1]));
    end
    return p
end

function centre(p::Position,pair::ScannerPair,scannerid::Int)
    if pair.scanner1==scannerid
        p = rotate(p,pair.orientation2);
        p = Position(p.I.-pair.offset2);
    elseif pair.scanner2==scannnerid
        p = Position(p.I.+pair.offset2);
        p = unrotate(p,pair.orientation2);
    else
        error("scanner not in pair");
    end
    return p
end


function standardisescanners(scanners::Vector{Vector{Position}},overlappingscanners::Vector{ScannerPair})::Vector{Position}
done = Set{Int}(1);
usedpairs = Set{Int}();
out = scanners[1];
while length(done)<length(scanners)
    for i in setdiff(1:overlappingscanners,usedpair)
        if overlappingscanners[i].scanner1 in done
            push!(usedpairs,i);


end

