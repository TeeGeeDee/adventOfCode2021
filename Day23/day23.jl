const Position = CartesianIndex{2};
@enum AmphipodType A=Int('A') B=Int('B') C=Int('C') D=Int('D')
const AMPHIPOD_COSTS = Dict(A=>1,B=>10,C=>100,D=>1000);
const SIDE_ROOMS = begin
    rooms = Dict{AmphipodType,Vector{Position}}(A=>[Position((4,4))],B=>[Position((6,4))],C=>[Position((8,4))],D=>[Position((10,4))]);
    for k in keys(rooms) rooms[k] = [rooms[k][1]; rooms[k][1]+Position((0,-1))]; end
    rooms;
end;
const HALLWAY = [Position((x,2)) for x in [2; 3:2:11; 12]];
struct Amphipod
    type::AmphipodType
    index::Int # determined based on starting position, ordering by counting along the first row and then the second
end
const GameState = Dict{Amphipod,Position};
const Path = NamedTuple{(:via,:finish,:cost),Tuple{Vector{Position},Vector{Position},Int}};

function makemove(gamestate::GameState,amphipod::Amphipod,destination::Position)::GameState
    outstate = copy(gamestate);
    outstate[amphipod] = destination;
    return outstate
end

function parseburrow(file)::GameState
    data = readlines(file);
    seen = Dict{AmphipodType,Int}(type=>0 for type in instances(AmphipodType));
    positions = Dict{Amphipod,Position}();
    for row in 3:4, col in 4:2:10
        type = AmphipodType(Int(data[row][col]));
        seen[type] += 1;
        amphipod = Amphipod(type,seen[type]);
        positions[amphipod] = Position((col,row));
    end
    return positions
end

function calccost(startpositions::Vector{Position},via::Vector{Position},endpositions::Vector{Position})::Int
    return sum((sum(abs.((via[i]-startpositions[i]).I))+sum(abs.((endpositions[i]-via[i]).I))) * 10^Int(ceil(i/2)-1) for i in 1:8);
end

function nextmoves(gamestate::GameState,path::Path)::Dict{Amphipod,Position}
    moves = Dict{Amphipod,Position}();
    i = 0;
    for type in instances(AmphipodType),id in 1:2
        i += 1;
        amphipod = Amphipod(type,id);
        currentposition = gamestate[amphipod];
        if     currentposition==path.finish[i] continue
        elseif currentposition==path.via[i]    moves[amphipod] = path.finish[i];
        else                                   moves[amphipod] = path.via[i];
        end
    end
    return moves
end

function isvalidmove(gamestate::GameState,amphipod::Amphipod,move::Position)::Bool
    start = gamestate[amphipod];
    opening = start[2]==2 ? Position((move[1],2)) : Position((start[1],2));
    return isempty(intersect(values(gamestate),
    setdiff(union(start:opening,opening:start,opening:move,move:opening),(start,))))
end

function day23(file)
    startgamestate = parseburrow(file);
    startpositions = [startgamestate[Amphipod(type,id)] for type in instances(AmphipodType) for id in 1:2];

    function endpairs(type::AmphipodType)
        if     startgamestate[Amphipod(type,1)]==SIDE_ROOMS[type][1] return (SIDE_ROOMS[type],)
        elseif startgamestate[Amphipod(type,2)]==SIDE_ROOMS[type][1] return (SIDE_ROOMS[type][[2,1]],)
        else return (SIDE_ROOMS[type],SIDE_ROOMS[type][[2,1]])
        end
    end
    paths = Vector{Path}();
    combs = [[p] for p in HALLWAY];
    for _ in 2:8 combs = [[prev; x] for x in HALLWAY for prev in combs]; end
    for a in endpairs(A),b in endpairs(B),c in endpairs(C),d in endpairs(D)
        endpositions = [a;b;c;d];
        isdone = (startpositions .== endpositions) .& ([p[2] for p in startpositions].==4);
        # assume an entire letter isn't done
        for via in combs
            via[isdone] .= startpositions[isdone];
            cost = calccost(startpositions,via,endpositions);
            push!(paths,(via=via,finish=endpositions,cost=cost));
        end
    end
    paths = unique(paths);
    paths = sort(paths,by=x->x.cost);
    cost = 0;
    for path in paths
        if isvalidpath(path,startgamestate)
            cost = path.cost;
            break
        end
    end
    return cost
end

function isvalidpath(path::Path,startgamestate::GameState)::Bool
    stack = [deepcopy(startgamestate)];
    found = false;
    while !isempty(stack) && !found
        gamestate = pop!(stack);
        nextmovesdict = nextmoves(gamestate,path);
        found = isempty(nextmovesdict);
        for (amphipod,move) in nextmovesdict
            if isvalidmove(gamestate,amphipod,move) push!(stack,makemove(gamestate,amphipod,move)); end
        end
    end
    return found
end
