using Test
include("day21.jl")

const TEST_STRING = """Player 1 starting position: 4
Player 2 starting position: 8"""

@test day21(IOBuffer(TEST_STRING))==(739785,444356092776315)
