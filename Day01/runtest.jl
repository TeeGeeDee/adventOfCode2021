using Test
include("day1.jl")

const TEST_STRING = """199
200
208
210
200
207
240
269
260
263"""

@test day1(IOBuffer(TEST_STRING))==(7,5)