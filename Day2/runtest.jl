using Test
include("day2.jl")

const TEST_STRING = """forward 5
down 5
forward 8
up 3
down 8
forward 2"""

@test day2(IOBuffer(TEST_STRING))==(150,900)