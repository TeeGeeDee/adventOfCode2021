using Test
include("day23.jl")

const TEST_STRING = """#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########"""

startsummary = parseburrow(IOBuffer(TEST_STRING))[1];
@test calcisdone(startsummary.gamestate)==Bool.([1,0,0,0,0,1,0,0]);

@test day23(IOBuffer(TEST_STRING))==(12521,44169);
