using Test
include("day17.jl")

const TEST_STRING = "target area: x=20..30, y=-10..-5"

@test day17(IOBuffer(TEST_STRING))==(45,112)
