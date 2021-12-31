using Test
include("day23.jl")

const TEST_STRING = """#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########"""

@test calcisdone(parseburrow(IOBuffer(TEST_STRING))[1].gamestate)==Bool.([1,0,0,0,0,1,0,0])
@test calccost(ExtraTravel(Amphipod(A,1)=>0,
                           Amphipod(A,2)=>1,
                           Amphipod(B,1)=>0,
                           Amphipod(B,2)=>1,
                           Amphipod(C,1)=>0,
                           Amphipod(C,2)=>0,
                           Amphipod(D,1)=>0,
                           Amphipod(D,2)=>0,),parseburrow(IOBuffer(TEST_STRING))[1])==12521
# Then test getpaths - check that the actual taken path is in the vector output by getpaths when you pass the above extratravel

@test day23(IOBuffer(TEST_STRING))==(12521,44169)
#=
b2 -> Position((5,2))
c1 -> Position((7,2))
c1 -> Position((8,3))
d1 -> Position((9,2))
b2 -> Position((6,4))
b1 -> Position((5,2))
b1 -> Position((6,3))
b2 -> Position((6,3))
d2 -> Position((9,2))
a2 -> Position((11,2))
d2 -> Position((10,4))
d1 -> Position((10,3))
a2 -> Position((4,3))
thepath = (via=[Position((4,4)),Position((11,2)),
                Position((5,2)),Position((5,2)),
                Position((7,2)),Position((8,4)),
                Position((9,2)),Position((9,2))],
finish=[Position((4,4)),Position((4,3)),
        Position((6,3)),Position((6,4)),
        Position((8,3)),Position((8,4)),
        Position((10,3)),Position((10,4))],
cost=12521)
=#