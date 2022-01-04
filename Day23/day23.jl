using DataStructures

#= Ideas:
    Ultimately (unless already in finished position) each amphipod moves to a space in the hallway and then into the final room
    Each potential solution can be summarised by the position that each amphipod visits
    The costs for each amphipod leaving the initial room is constant regarless of route
    The cost of moving into the final room is constant, and just depends on the number of amphipods in the room already in position
    The cost of the route can be easily calculated in terms of the direct hallway route, plus however longer is travelled
    As soon as an amphipod can move into the final position, it should.
    Only other moves to consider are the amphipods on the edge of each room (implement with a stack)
    Use a priority queue to try solutions in increasing order of cost, stopping as soon as a solution is found
=#

@enum AmphipodType A=Int('A') B=Int('B') C=Int('C') D=Int('D') # Int values chosen to make conversion from chars easy
const PositionA      = CartesianIndex{2};
const Cost           = Int;
const AMPHIPOD_COSTS = OrderedDict{AmphipodType,Cost}(A=>1,B=>10,C=>100,D=>1000);
const SIDE_ROOM_X    = OrderedDict{AmphipodType,Int}( A=>4,B=>6, C=>8,  D=>10);
const COL_TO_ROOM    = OrderedDict{Int,AmphipodType}( 4=>A,6=>B, 8=>C,  10=>D);
const HALLWAY_X      = [2; 3:2:11; 12];
struct Amphipod
    type::AmphipodType
    index::Int # determined based on starting position, ordering by counting along each row in turn
end
const GameState      = OrderedDict{Amphipod,PositionA};
mutable struct GameStateFull
    positions::GameState
    rooms::Dict{AmphipodType,Vector{Amphipod}} # key labels the room act as a stack
    hallwayoccupancy::Vector{Bool} # is each position in the hallway occupied
    hallwayoccupants::Vector{Union{Amphipod,Missing}}
    function GameStateFull(positions::GameState)
        rooms = Dict{AmphipodType,Vector{Amphipod}}(t=>Vector{Amphipod}() for t in instances(AmphipodType));
        roomsize = length(positions)÷length(instances(AmphipodType));
        for type = instances(AmphipodType)
            for i = 1:roomsize
                push!(rooms[type],[k for (k,v) in positions if v==PositionA((SIDE_ROOM_X[type],3+roomsize-i))][1]);
            end
        end
        return new(positions,rooms,fill(false,maximum(HALLWAY_X)),repeat(Vector{Union{Amphipod,Missing}}([missing]),maximum(HALLWAY_X)))
    end
end

const StartSummary = NamedTuple{(:gamestate,:gamestatefull,:amphipods,:positions,:isdone,:baselinecost,:roomsize,:allmoves),
                                Tuple{
                                    GameState,
                                    GameStateFull,
                                    Vector{Amphipod},
                                    Vector{PositionA},
                                    Vector{Bool},
                                    Cost,
                                    Int,
                                    OrderedDict{Amphipod,Vector{Pair{PositionA,Cost}}}}};

function day23(file)
    startsummary1,startsummary2 = parseburrow(file);
    return getmincost(startsummary1),getmincost(startsummary2)
end

function getmincost(startsummary::StartSummary)::Cost
    gamestatesconsidered = Set{GameState}();
    cost = 0;
    queue = PriorityQueue{GameStateFull,Cost}();
    enqueue!(queue,GameStateFull(startsummary.gamestate)=>startsummary.baselinecost);
    while cost==0
        game,thiscost = dequeue_pair!(queue);
        if isdonegame(game)
            cost = thiscost;
        else
            for (amphipod,move,extracost) in validmoves(game,startsummary)
                newgame = makemove(game,amphipod,move);
                if !(newgame.positions in gamestatesconsidered)
                    push!(gamestatesconsidered,newgame.positions);
                    enqueue!(queue,newgame=>thiscost+extracost);
                end
            end
        end
    end
    return cost
end

function parseburrow(file)::Tuple{StartSummary,StartSummary}
    data1 = readlines(file);
    data2 = [data1[1:3]; ["  #D#C#B#A#";"  #D#B#A#C#"]; data1[4:end]];
    return readpositions(data1),readpositions(data2)
end

function readpositions(data::Vector{String})::StartSummary
    seen = Dict{AmphipodType,Int}(type=>0 for type in instances(AmphipodType));
    positions = Dict{Amphipod,PositionA}();
    roomsize = length(data)-3;
    for row in 3:(2+roomsize), col in 4:2:10
        type = AmphipodType(Int(data[row][col]));
        seen[type] += 1;
        amphipod = Amphipod(type,seen[type]);
        positions[amphipod] = PositionA((col,row));
    end
    out = OrderedDict{Amphipod,PositionA}();
    for type in instances(AmphipodType), id in 1:roomsize
        out[Amphipod(type,id)] = positions[Amphipod(type,id)];
    end
    return calcstartsummary(out)
end

function calcstartsummary(startgamestate::GameState)::StartSummary
    roomsize = length(startgamestate)÷length(instances(AmphipodType));
    isdone   = calcisdone(startgamestate);
    return (gamestate      = startgamestate,
            gamestatefull  = GameStateFull(startgamestate),
            amphipods      = collect(keys(startgamestate)),
            positions      = collect(values(startgamestate)),
            isdone         = isdone,
            baselinecost   = calcbaselinecost(startgamestate,isdone,roomsize),
            roomsize       = roomsize,
            allmoves       = getallmoves(startgamestate))
end

function getallmoves(positions::GameState)::OrderedDict{Amphipod,Vector{Pair{PositionA,Cost}}}
    return OrderedDict{Amphipod,Vector{Pair{PositionA,Cost}}}(a=>[Pair(PositionA((hallposx,2)),begin
                                                                tofromx = sort([pos[1],SIDE_ROOM_X[a.type]]);
                                                                if     all(hallposx.<tofromx) cost = 2*(tofromx[1]-hallposx);
                                                                elseif all(hallposx.>tofromx) cost = 2*(hallposx-tofromx[2]);
                                                                else                          cost = 0;
                                                                end
                                                                cost * AMPHIPOD_COSTS[a.type];
                                                                end) for hallposx in HALLWAY_X] for (a,pos) in positions);
end

function calcisdone(gamestate::GameState)::Vector{Bool}
    roomsize = length(gamestate)÷length(instances(AmphipodType));
    doneamphipods = Set{Amphipod}();
    for type in instances(AmphipodType)
        for i = 1:roomsize
            filling = [k for (k,v) in gamestate if (k.type == type) && (v == PositionA((SIDE_ROOM_X[type],3+roomsize-i)))];
            if isempty(filling) break
            else                push!(doneamphipods,filling[1]);
            end
        end
    end
    return [a in doneamphipods for a in keys(gamestate)];
end

function calcbaselinecost(startpositions::GameState,isdone::Vector{Bool},roomsize::Int)::Cost
    # sum of cost of the lowest possible moves (no accounting for validity/ordering of moves)
    amphipods = collect(keys(startpositions));
    ntomove = Dict(type=>roomsize-sum(isdone[[a.type==type for a in amphipods]]) for type in instances(AmphipodType));
    minmove(from::PositionA,xto::Int)::Int = from[2]-2 + abs(from[1]-xto);
    return sum(minmove(startpositions[amphipod],SIDE_ROOM_X[amphipod.type]) * AMPHIPOD_COSTS[amphipod.type]
                for amphipod in amphipods[.!isdone]) +
            sum(AMPHIPOD_COSTS[type] * Int(ntomove[type] * (ntomove[type]+1)/2) for type in instances(AmphipodType))
end

function isdonegame(gamestatefull::GameStateFull)::Bool
    return !any(gamestatefull.hallwayoccupancy) && all(all(a.type==type for a in gamestatefull.rooms[type]) for type in instances(AmphipodType))
end

function makemove(gamestatefull::GameStateFull,amphipod::Amphipod,newposition::PositionA)::GameStateFull
    out = deepcopy(gamestatefull);
    out.positions[amphipod] = newposition;
    if newposition[2]==2 # to hallway
        pop!(out.rooms[COL_TO_ROOM[gamestatefull.positions[amphipod][1]]]);
        out.hallwayoccupancy[newposition[1]] = true;
        out.hallwayoccupants[newposition[1]] = amphipod;
    else # from hallway
        oldposition = gamestatefull.positions[amphipod];
        push!(out.rooms[amphipod.type],amphipod);
        out.hallwayoccupancy[oldposition[1]] = false;
        out.hallwayoccupants[oldposition[1]] = missing;
    end
    return out
end

between(i::Int,j::Int)::UnitRange{Int} = i<j ? ((i+1):j) : (j:(i-1));

function validmoves(gamestatefull::GameStateFull,startsummary::StartSummary)::Vector{Tuple{Amphipod,PositionA,Cost}}
    # as soon as you see a path to your final room, take it
    for (i,amphipod) in enumerate(gamestatefull.hallwayoccupants)
        if !ismissing(amphipod) && all(a.type == amphipod.type for a in gamestatefull.rooms[amphipod.type]) && 
            !any(gamestatefull.hallwayoccupancy[between(i,SIDE_ROOM_X[amphipod.type])])
            return [(amphipod,PositionA((SIDE_ROOM_X[amphipod.type],2+startsummary.roomsize-length(gamestatefull.rooms[amphipod.type]))),0)]
        end
    end
    # otherwise consider the (up to) 4 amphipods that can leave the side-rooms (and are not done)
    out = Vector{Tuple{Amphipod,PositionA,Cost}}();
    for type in instances(AmphipodType)
        if length(gamestatefull.rooms[type])>0 && !all(a.type == type for a in gamestatefull.rooms[type])
            amphipod = gamestatefull.rooms[type][end];
            fromx    = gamestatefull.positions[amphipod][1];
            for (move,cost) in startsummary.allmoves[amphipod]
                if !any(gamestatefull.hallwayoccupancy[between(fromx,move[1])])
                    push!(out,(amphipod,move,cost));
                end
            end
        end
    end
    return out
end
