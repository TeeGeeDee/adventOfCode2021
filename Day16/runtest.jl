using Test
include("day16.jl")

const TEST_STRING_A1 = "8A004A801A8002F478"
const TEST_STRING_A2 = "620080001611562C8802118E34"
const TEST_STRING_A3 = "C0015000016115A2E0802F182340"
const TEST_STRING_A4 = "A0016C880162017C3686B18A3D4780"

const TEST_STRING_B1 = "C200B40A82"
const TEST_STRING_B2 = "04005AC33890"
const TEST_STRING_B3 = "880086C3E88112"
const TEST_STRING_B4 = "CE00C43D881120"
const TEST_STRING_B5 = "D8005AC2A8F0"
const TEST_STRING_B6 = "F600BC2D8F"
const TEST_STRING_B7 = "9C005AC2F8F0"
const TEST_STRING_B8 = "9C0141080250320F1802104A08"

const TEST_STRING_C1 = "D2FE28"

@test day16(IOBuffer(TEST_STRING_A1))[1]==16
@test day16(IOBuffer(TEST_STRING_A2))[1]==12
@test day16(IOBuffer(TEST_STRING_A3))[1]==23
@test day16(IOBuffer(TEST_STRING_A4))[1]==31

@test day16(IOBuffer(TEST_STRING_B1))[2]==3
@test day16(IOBuffer(TEST_STRING_B2))[2]==54
@test day16(IOBuffer(TEST_STRING_B3))[2]==7
@test day16(IOBuffer(TEST_STRING_B4))[2]==9
@test day16(IOBuffer(TEST_STRING_B5))[2]==1
@test day16(IOBuffer(TEST_STRING_B6))[2]==0
@test day16(IOBuffer(TEST_STRING_B7))[2]==0
@test day16(IOBuffer(TEST_STRING_B8))[2]==1

@test day16(IOBuffer(TEST_STRING_C1))==(6,2021)
