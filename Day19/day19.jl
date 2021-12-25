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
    # Set up loop so that we always compare something we can map to scanner 1, so that unifying is easy
    done,todo = Set{Int}(),Set{Int}(1);
    overlappingscanners = Vector{ScannerPair}();
    while !isempty(todo)
        i = pop!(todo);
        push!(done,i);
        for j = setdiff(1:length(scanners),done)
            orientation2,offset2 = matchscanners(scanners[i],scanners[j]);
            if !isnothing(orientation2)
                push!(overlappingscanners,ScannerPair((i,j,orientation2,offset2)));
                push!(todo,j);
            end
        end
    end
    readings = standardisescanners([collect(r) for r in scanners],overlappingscanners);
    return length(unique(readings)),largestmanhattendist(length(scanners),overlappingscanners)
end

function parsescanners(file)::Vector{Set{Position}}
    data     = readlines(file);
    breaks   = [findall(startswith.(data,"--- scanner")); length(data)+2];
    scanners = [Set([Position(parse.(Int,x)...) for x in split.(data[(breaks[i]+1):(breaks[i+1]-2)],",")]) 
                                            for i in 1:(length(breaks)-1)];
    return scanners
end

function matchscanners(scanner1::Set{Position},scanner2::Set{Position})
    for orientation in allorientations
        s2 = [rotate(p,orientation) for p in scanner2];
        vec1,vec2 = collect(scanner1),collect(s2)
        for i1 = 1:(length(vec1)-10), i2 = 1:(length(vec2)-10) # with 11 left we know we won't match
            offset = vec2[i2].I .- vec1[i1].I;
            if !any(offset.>2000)
                centred2 = Set(Position(p.I.-offset) for p in s2);
                if length(intersect(scanner1,centred2))>=12
                    return (orientation,Position(offset));
                end
            end
        end
    end
    return (nothing,nothing)
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
        report = collect(scanners[i]);
        while myview != 1
            pair = overlappingscanners[findfirst(p.scanner2==myview for p in overlappingscanners)];
            report = [centre(l,pair) for l in report];
            myview = pair.scanner1;
        end
        append!(out,report);
    end
    return out
end
