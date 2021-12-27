struct Cube  # under the hood 6 Ints
    lims::Tuple{UnitRange{Int64}, UnitRange{Int64}, UnitRange{Int64}}
end

struct Step
    area::Cube
    on::Bool # if not on, turning off
end

mutable struct State
    oncubes::Vector{Cube}
    State() = new(Vector{Cube}[]) # initialise as all cubes off
end

Base.isempty(cube::Cube) = isempty(CartesianIndices(cube.lims));
numcubeson(cube::Cube)   = length(CartesianIndices(cube.lims)); # length of CartesianIndices actually returns the area, which we want
numcubeson(state::State) = sum(numcubeson(cube) for cube in state.oncubes);

function Base.intersect(cube1::Cube,cube2::Cube)
    return Cube(Tuple(max(l1.start,l2.start):min(l1.stop,l2.stop) for (l1,l2) in zip(cube1.lims,cube2.lims)))
end

function subtract(cube1::Cube,cube2::Cube)::Vector{Cube}
    overlap = intersect(cube1,cube2);
    if isempty(overlap)
        return [cube1]
    else
        edgesouter = cube1.lims;
        edgesin    = overlap.lims;
        out = [Cube(Tuple(((edgesin[1].stop+1):edgesouter[1].stop,edgesouter[2:3]...)));
               Cube(Tuple((edgesouter[1].start:(edgesin[1].start-1),edgesouter[2:3]...)));
               Cube(Tuple((edgesin[1],(edgesin[2].stop+1):edgesouter[2].stop,edgesouter[3])));
               Cube(Tuple((edgesin[1],edgesouter[2].start:(edgesin[2].start-1),edgesouter[3])));
               Cube(Tuple((edgesin[1:2]...,(edgesin[3].stop+1):edgesouter[3].stop)));
               Cube(Tuple((edgesin[1:2]...,edgesouter[3].start:(edgesin[3].start-1))))];
        out = out[.!isempty.(out)];
        return out
    end
end

function updatestate!(state::State,step::Step)::Nothing
    cubesout = Vector{Cube}();
    if step.on push!(cubesout,step.area); end
    # either way now have to remove step.area from existing cubes
    for cube in state.oncubes
        for c in subtract(cube,step.area)
            push!(cubesout,c);
        end
    end
    state.oncubes = cubesout;
    return nothing
end

function day22(file)
    steps = parseday22(file);
    # part 1 do simple way storing all points
    oncubes1 = Set{CartesianIndex{3}}();
    popsafe!(s,v) = v in s ? pop!(s,v) : nothing;
    for step in steps
        f = step.on ? push! : popsafe!;
        for c in CartesianIndices(intersect(step.area,Cube(Tuple((-50:50,-50:50,-50:50)))).lims) f(oncubes1,c); end
    end
    # part 2 take a more complex approach of storing the state as the union of non-overlapping cubes
    state = State();
    for step in steps
        updatestate!(state,step);
    end
    return length(oncubes1),numcubeson(state)
end

function parseday22(file)
    data      = readlines(file);
    onoff     = [startswith(s,"on") for s in data];
    cubeedges = [parse.(Int,split(replace(s,"on "=>"","off "=>"",r"(x|y|z)="=>"",".."=>","),",")) for s in data];
    cubes     = [Cube(Tuple(c[2*(i-1)+1]:c[2*i] for i in 1:3)) for c in cubeedges];
    return Tuple(Step(cube,on) for (cube,on) in zip(cubes,onoff))
end
