using Test
include("day7.jl")

const TEST_STRING = """16,1,2,0,4,2,7,1,2,14"""

@test day7(IOBuffer(TEST_STRING))==(37,168)