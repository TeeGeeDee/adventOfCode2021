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
    i,mapped = 1,Set(1);
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
        i = first(setdiff(mapped,checkedpairs));
    end
    readings = standardisescanners(scanners,overlappingscanners);
    return length(unique(readings)),largestmanhattendist(length(scanners),overlappingscanners)
end

function parsescanners(file)::Vector{Vector{Position}}
    data = readlines(file);
    breaks = [findall(startswith.(data,"--- scanner")); length(data)+2];
    scanners = [[Position(parse.(Int,x)...) for x in split.(data[(breaks[i]+1):(breaks[i+1]-2)],",")] 
                                            for i in 1:(length(breaks)-1)];
    return scanners
end

function matchscanners(scanner1::Vector{Position},scanner2::Vector{Position},orientation::Orientation)::Union{Nothing,Position}
    s1 = Set(scanner1);
    scanner2 = [rotate(p,orientation) for p in scanner2];
    out::Union{Nothing,Position} = nothing;
    for i1 = 1:(length(scanner1)-10), i2 = 1:(length(scanner2)-10) # with 11 left we know we won't match
        offset = scanner2[i2].I .- scanner1[i1].I;
        centred2 = Set(Position(p.I.-offset) for p in scanner2);
        if length(intersect(s1,centred2))>=12
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

function centre(p::Position,pair::ScannerPair)
    p = rotate(p,pair.relativeorientation2);
    p = Position(p.I .- pair.offset2.I);
    return p
end

function largestmanhattendist(numscanners::Int,overlappingscanners::Vector{ScannerPair})
    scannerpositions = standardisescanners(repeat([[Position((0,0,0))]],numscanners),overlappingscanners);
    maxdist = 0;
    for i in 1:(numscanners-1), j in (i+1):numscanners
        dist = sum(abs.(scannerpositions[i].I .- scannerpositions[j].I));
        if dist>maxdist maxdist = dist; end
    end
    return maxdist
end

function standardisescanners(scanners::Vector{Vector{Position}},overlappingscanners::Vector{ScannerPair})::Vector{Position}
    out = Vector{Position}();
    for i in 1:length(scanners)
        myview = i;
        report = scanners[i];
        while myview != 1
            pair = overlappingscanners[findfirst(p.scanner2==myview for p in overlappingscanners)];
            report = [centre(l,pair) for l in report];
            myview = pair.scanner1;
        end
        append!(out,report);
    end
    return out
end
