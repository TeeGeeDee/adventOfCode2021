using DataStructures

const Position = CartesianIndex{2};
@enum AmphipodType A=Int('A') B=Int('B') C=Int('C') D=Int('D') # Int values chosen to make conversion from chars easy
const AMPHIPOD_COSTS = OrderedDict{AmphipodType,Int}(A=>1,B=>10,C=>100,D=>1000);
const SIDE_ROOM_X    = OrderedDict{AmphipodType,Int}(A=>4,B=>6, C=>8,  D=>10);
const HALLWAY = [Position((x,2)) for x in [2; 3:2:11; 12]];
struct Amphipod
    type::AmphipodType
    index::Int # determined based on starting position, ordering by counting along each row in turn
end
const GameState    = OrderedDict{Amphipod,Position};
const ExtraTravel  = OrderedDict{Amphipod,Int};
const StartSummary = NamedTuple{(:gamestate,:amphipods,:positions,:isdone,:types,:baselinecost,:maxextratravel,:roomsize),
                                Tuple{
                                    GameState,
                                    Vector{Amphipod},
                                    Vector{Position},
                                    Vector{Bool},
                                    Vector{AmphipodType},
                                    Int,
                                    ExtraTravel,
                                    Int}};

function day23(file)
    startsummary1,startsummary2 = parseburrow(file);
    return getmincost(startsummary1),getmincost(startsummary2)
end

function parseburrow(file)::Tuple{StartSummary,StartSummary}
    data1 = readlines(file);
    data2 = [data1[1:3]; ["  #D#C#B#A#";"  #D#B#A#C#"]; data1[4:end]];
    return readpositions(data1),readpositions(data2)
end

function readpositions(data::Vector{String})::StartSummary
    seen = Dict{AmphipodType,Int}(type=>0 for type in instances(AmphipodType));
    positions = Dict{Amphipod,Position}();
    roomsize = length(data)-3;
    for row in 3:(2+roomsize), col in 4:2:10
        type = AmphipodType(Int(data[row][col]));
        seen[type] += 1;
        amphipod = Amphipod(type,seen[type]);
        positions[amphipod] = Position((col,row));
    end
    out = OrderedDict{Amphipod,Position}();
    for type in instances(AmphipodType), id in 1:roomsize
        out[Amphipod(type,id)] = positions[Amphipod(type,id)];
    end
    return calcstartsummary(out)
end

function calcstartsummary(startgamestate::GameState)::StartSummary
    roomsize = length(startgamestate)÷length(instances(AmphipodType));
    isdone   = calcisdone(startgamestate);
    return (gamestate      = startgamestate,
            amphipods      = collect(keys(startgamestate)),
            positions      = collect(values(startgamestate)),
            isdone         = isdone,
            types          = [a.type for a in keys(startgamestate)],
            baselinecost   = calcbaselinecost(startgamestate,isdone,roomsize),
            maxextratravel = calcmaxextratraval(startgamestate,isdone),
            roomsize       = roomsize)
end

function calcisdone(gamestate::GameState)::Vector{Bool}
    roomsize = length(gamestate)÷length(instances(AmphipodType));
    doneamphipods = Set{Amphipod}();
    for type in instances(AmphipodType)
        for i = 1:roomsize
            filling = [k for (k,v) in gamestate if k.type == type && v == Position((SIDE_ROOM_X[type],3+roomsize-i))];
            if isempty(filling) break
            else                push!(doneamphipods,filling[1]);
            end
        end
    end
    return [a in doneamphipods for a in keys(gamestate)];
end

function calcbaselinecost(startpositions::GameState,isdone::Vector{Bool},roomsize::Int)::Int
    # sum of cost of the lowest possible moves (no accounting for validity/ordering of moves)
    # TODO: INCORPORATE CASE OF NOT BEING DONE BUT STARTING IN THE CORRECT COLUMN - NEED TO MOVE ONE LEFT/RIGHT AND THEN BACK
    amphipods = collect(keys(startpositions));
    ntomove = Dict(type=>roomsize-sum(isdone[[a.type==type for a in amphipods]]) for type in instances(AmphipodType));
    return sum(sum(abs.(startpositions[amphipod].I.-(SIDE_ROOM_X[amphipod.type][1][1],2))) * AMPHIPOD_COSTS[amphipod.type] 
                for amphipod in amphipods[.!isdone]) + 
            sum(AMPHIPOD_COSTS[type] * Int(ntomove[type]*(ntomove[type]+1)/2) for type in instances(AmphipodType))
end

function calcmaxextratraval(startpositions::GameState,isdone::Vector{Bool})::ExtraTravel
    maxextra = ExtraTravel();
    for (amphipod,isdone) in zip(keys(startpositions),isdone)
        doors = (startpositions[amphipod][1],SIDE_ROOM_X[amphipod.type]);
        maxextra[amphipod] = isdone ? 0 : maximum(door-hallend[1] for door in doors for hallend in HALLWAY[[1,end]]);
    end
    return maxextra
end

function getmincost(startsummary::StartSummary)::Int
    cost = 0;
    queue = Queue{ExtraTravel}();
    enqueue!(queue,OrderedDict(amphipod=>0 for amphipod in startsummary.amphipods));
    triedextras = Set{ExtraTravel}();
    while true
        extratravel = dequeue!(queue);
        for path in getpaths(extratravel,startsummary)
            if isvalidpath(path,startsummary.gamestate)
                cost = calccost(extratravel,startsummary);
                break
            end
        end
        for x in nextleastextratravel!(triedextras,extratravel,startsummary) enqueue!(queue,x); end
    end
    return cost
end

function isvalidpath(path::Vector{Position},startgamestate::GameState)::Bool
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

function makemove(gamestate::GameState,amphipod::Amphipod,destination::Position)::GameState
    outstate = copy(gamestate);
    outstate[amphipod] = destination;
    return outstate
end

function nextmoves(gamestate::GameState,path::Vector{Position})::Dict{Amphipod,Position}
    moves = Dict{Amphipod,Position}();
    isdone = calcisdone(gamestate);
    roomsize = length(gamestate)÷length(instances(AmphipodType));
    for (i,amphipod) in enumerate(keys(gamestate))
        currentposition = gamestate[amphipod];
        if isdone[i] 
            # in final position, do nothing
        elseif currentposition[2]==2 # in HALLWAY
            moves[amphipod] = Position((SIDE_ROOM_X[amphipod.type],2+roomsize-sum(isdone[[a.type==amphipod.type for a in keys(gamestate)]])));
        else # in starting position
            moves[amphipod] = path[i];
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

function calccost(extratravel::ExtraTravel,startsummary::StartSummary)::Int
    return startsummary.baselinecost+sum(AMPHIPOD_COSTS[k.type] * 2*v for (k,v) in extratravel) # there and back
end

function getpaths(extratravel::ExtraTravel,start::StartSummary)::Vector{Vector{Position}}
    # TODO: INCORPORATE CASE OF NOT BEING DONE BUT STARTING IN THE CORRECT COLUMN - NEED TO MOVE ONE LEFT/RIGHT AND THEN BACK
    paths = [[]];
    for (amphipod,isdone) in zip(start.amphipods,start.isdone)
        extra = extratravel[amphipod];
        startx,endx = start.gamestate[amphipod][1],SIDE_ROOM_X[amphipod.type];
        if isdone
            mymoves = [start.gamestate[amphipod]];
        else
            mymoves = startx<endx ? ((startx-extra,2),(endx+extra,2)) : ((endx-extra,2),(startx+extra,2));
            mymoves = intersect(HALLWAY,Position.(mymoves));
        end
        paths = [[prev; x] for x in mymoves for prev in paths];
    end
    return paths
end

function nextleastextratravel!(triedextras::Set{ExtraTravel},extratravel::ExtraTravel,start::StartSummary)::Vector{ExtraTravel}
    out = Vector{ExtraTravel}();
    baseline = copy(extratravel);
    for type in instances(AmphipodType)
        ismaxed = Dict(Amphipod(type,id)=>(start.maxextratravel[Amphipod(type,id)]==baseline[Amphipod(type,id)]) for id in 1:start.roomsize);
        if all(values(ismaxed))
            for i in 1:start.roomsize baseline[Amphipod(type,i)] = 0; end
        else
            for (amphipod,ismax) in ismaxed
                if !ismax
                    x = copy(baseline);
                    x[amphipod] += 1;
                    if !(x in triedextras)
                        if calccost(x,start) == 12521 println(x); end
                        push!(out,x);
                        push!(triedextras,x);
                    end
                end
            end
            break
        end
    end
    return out
end
