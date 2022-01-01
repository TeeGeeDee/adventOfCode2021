using DataStructures
using Memoization

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
const AllExtra = OrderedDict{Amphipod,Vector{Tuple{Int,Vector{Position}}}};
const StartSummary = NamedTuple{(:gamestate,:amphipods,:positions,:isdone,:types,:baselinecost,:allextratravel,:roomsize),
                                Tuple{
                                    GameState,
                                    Vector{Amphipod},
                                    Vector{Position},
                                    Vector{Bool},
                                    Vector{AmphipodType},
                                    Int,
                                    AllExtra,
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
            allextratravel = calcallextratraval(startgamestate,isdone),
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
    amphipods = collect(keys(startpositions));
    ntomove = Dict(type=>roomsize-sum(isdone[[a.type==type for a in amphipods]]) for type in instances(AmphipodType));
    minmove(from::Position,xto::Int)::Int = from[2]-2 + max(abs(from[1]-xto),2); # max takes care of when you're in the right room, but not done
    return sum(minmove(startpositions[amphipod],SIDE_ROOM_X[amphipod.type]) * AMPHIPOD_COSTS[amphipod.type]
                for amphipod in amphipods[.!isdone]) +
            sum(AMPHIPOD_COSTS[type] * Int(ntomove[type] * (ntomove[type]+1)/2) for type in instances(AmphipodType))
end

function calcallextratraval(startpositions::GameState,isdone::Vector{Bool})::AllExtra
    allextra = AllExtra(a=>Vector{Tuple{Int64, Vector{CartesianIndex{2}}}}() for a in keys(startpositions));
    for (amphipod,isdone) in zip(keys(startpositions),isdone)
        if isdone
            allextra[amphipod] = [(0,[startpositions[amphipod]])];
        else
            startx,endx = startpositions[amphipod][1], SIDE_ROOM_X[amphipod.type];
            bounds = startx == endx ? [startx-1,startx+1] : [startx,endx];
            left,right = Tuple(sort(bounds));
            for i = 0:maximum(p[1] for p in HALLWAY)
                if i == 0 possiblepositions = Position((left,2)):Position((right,2));
                else      possiblepositions = Tuple((Position((left-i,2)),Position((right+i,2))));
                end
                possiblepositions = intersect(HALLWAY,possiblepositions);
                if !isempty(possiblepositions)
                    push!(allextra[amphipod],(i,possiblepositions));
                end
            end
        end
    end
    return allextra
end

function getmincost(startsummary::StartSummary)::Int
    cost = 0;
    queue = Queue{ExtraTravel}();
    enqueue!(queue,OrderedDict(amphipod=>0 for amphipod in startsummary.amphipods));
    triedextras = Set{ExtraTravel}();
    while cost==0
        extratravel = dequeue!(queue);
        println(collect(values(extratravel)));
        println(calccost(extratravel,startsummary));
        @time paths = getpaths(extratravel,startsummary);
        println("Number of paths = $(length(paths))")
        if calccost(extratravel,startsummary) == 40083 break; end # just for profiling
        for path in paths
            isok = isvalidpath(path,startsummary.gamestate);
            if isok
                cost = calccost(extratravel,startsummary);
                break
            end
        end
        @time next = nextleastextratravel!(triedextras,extratravel,startsummary);
        for x in next enqueue!(queue,x); end
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

struct GameStateFull
    positions::GameState
    rooms::Dict{AmphipodType,Vector{Amphipod}} # key labels the room act as a stack
    hallwayoccupancy::Vector{Bool} # is each position in the hallway occupied
end

function nextmoves(gamestate::GameState,path::Vector{Position})::Dict{Amphipod,Position}
    # can be smarter - only consider top in each room, and only consider hallway when a room is free to move into
    # when a room is free to move into (and the path is open), force the move (return only that key,value)
    # probably just a good idea to combine with <isvalidmove>
    # Make another data-structure for gamestate, storing the occupants of the rooms and the hallway
    # Update this upon moving in makemove
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

@memoize function isvalidmove(gamestate::GameState,amphipod::Amphipod,move::Position)::Bool
    start = gamestate[amphipod];
    opening = start[2]==2 ? Position((move[1],2)) : Position((start[1],2));
    return isempty(intersect(values(gamestate),
    setdiff(union(start:opening,opening:start,opening:move,move:opening),(start,))))
end

function calccost(extratravel::ExtraTravel,startsummary::StartSummary)::Int
    return startsummary.baselinecost+sum(AMPHIPOD_COSTS[k.type] * 2*v for (k,v) in extratravel) # there and back
end

function getpaths(extratravel::ExtraTravel,start::StartSummary)::Vector{Vector{Position}}
    paths = [Vector{Position}()];
    for amphipod in start.amphipods
        mymoves = [m[2] for m in start.allextratravel[amphipod] if m[1]==extratravel[amphipod]][1];
        paths = [[prev; x] for x in mymoves for prev in paths];
    end
    return paths
end

function nextleastextratravel!(triedextras::Set{ExtraTravel},extratravel::ExtraTravel,start::StartSummary)::Vector{ExtraTravel}
    out = Vector{ExtraTravel}();
    baseline = copy(extratravel);
    for type in instances(AmphipodType)
        minincs = Dict{Amphipod,Int}();
        theseamphipods = [a for a in start.amphipods if a.type==type];
        for amphipod in theseamphipods
            ix = findfirst(x[1]==baseline[amphipod] for x in start.allextratravel[amphipod]);
            if ix < length(start.allextratravel[amphipod])
                minincs[amphipod] = start.allextratravel[amphipod][ix+1][1]-baseline[amphipod]
            end
        end
        if isempty(minincs)
            for amphipod in theseamphipods
                baseline[amphipod] = 0;#start.allextratravel[amphipod][1][1]; # reset this type to lowest values, increment more expensive types
            end
        else
            for amphipod in keys(minincs)
                x = copy(baseline);
                x[amphipod] += minincs[amphipod];
                if !(x in triedextras)
                    push!(out,x);
                    push!(triedextras,x);start.allextratravel[amphipod];
                end
            end
            break
        end
    end
    return out
end

# start with better lower bound of extratravel for part 2
# for example if there are none done, and none at the top of other rooms, all need to be in ... no, that's not true
