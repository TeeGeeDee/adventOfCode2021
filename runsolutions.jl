include("Day1/day1.jl");
include("Day2/day2.jl");
include("Day3/day3.jl");
include("Day4/day4.jl");
include("Day5/day5.jl");
include("Day6/day6.jl");

println("Day 1:");
@time part1,part2 = day1("Day1/data.txt");
# 0.000410 seconds (4.03 k allocations: 242.875 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 2:");
@time part1,part2 = day2("Day2/data.txt");
# 0.005155 seconds (4.12 k allocations: 349.141 KiB, 91.74% compilation time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 3:");
@time part1,part2 = day3("Day3/data.txt");
# 0.000425 seconds (5.30 k allocations: 359.203 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 4:");
@time part1,part2 = day4("Day4/data.txt");
# 0.012079 seconds (91.38 k allocations: 4.077 MiB, 64.46% compilation time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 5:");
@time part1,part2 = day5("Day5/data.txt");
# 0.053422 seconds (7.54 k allocations: 23.244 MiB, 78.65% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 6:");
@time part1,part2 = day6("Day6/data.txt");
# 0.000146 seconds (359 allocations: 68.852 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
