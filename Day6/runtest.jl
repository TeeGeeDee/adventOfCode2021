using Test
include("day6.jl")

const TEST_STRING = """3,4,3,1,2"""

@test day6(IOBuffer(TEST_STRING))==(5934,26984457539)