using Test
include("day14.jl")

const TEST_STRING = """NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C"""

@test day14(IOBuffer(TEST_STRING))==(1588,2188189693529)
