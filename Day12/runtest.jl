using Test
include("day12.jl")

const TEST_STRING1 = """start-A
start-b
A-c
A-b
b-d
A-end
b-end"""

const TEST_STRING2 = """dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc"""

const TEST_STRING3 = """fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW"""

@test day12(IOBuffer(TEST_STRING1))==(10,36)
@test day12(IOBuffer(TEST_STRING2))==(19,103)
@test day12(IOBuffer(TEST_STRING3))==(226,3509)
