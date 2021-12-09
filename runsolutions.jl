include("Day1/day1.jl");
include("Day2/day2.jl");
include("Day3/day3.jl");
include("Day4/day4.jl");
include("Day5/day5.jl");
include("Day6/day6.jl");
include("Day7/day7.jl");
include("Day8/day8.jl");
include("Day9/day9.jl");

# get compilation done (is this fair?)
# what it says to do here: https://docs.julialang.org/en/v1/manual/performance-tips/#Measure-performance-with-[@time](@ref)-and-pay-attention-to-memory-allocation
day1("Day1/data.txt");
day2("Day2/data.txt");
day3("Day3/data.txt");
day4("Day4/data.txt");
day5("Day5/data.txt");
day6("Day6/data.txt");
day7("Day7/data.txt");
day8("Day8/data.txt");
day9("Day9/data.txt");

println("Day 1:");
@time part1,part2 = day1("Day1/data.txt");
# 0.000376 seconds (4.03 k allocations: 242.875 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 2:");
@time part1,part2 = day2("Day2/data.txt");
# 0.000414 seconds (4.03 k allocations: 343.469 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 3:");
@time part1,part2 = day3("Day3/data.txt");
# 0.000650 seconds (5.30 k allocations: 359.203 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 4:");
@time part1,part2 = day4("Day4/data.txt");
# 0.014216 seconds (91.38 k allocations: 4.077 MiB, 63.73% compilation time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 5:");
@time part1,part2 = day5("Day5/data.txt");
# 0.019932 seconds (7.54 k allocations: 23.244 MiB, 35.21% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 6:");
@time part1,part2 = day6("Day6/data.txt");
# 0.000226 seconds (359 allocations: 68.852 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 7:");
@time part1,part2 = day7("Day7/data.txt");
# 0.000191 seconds (34 allocations: 149.385 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 8:");
@time part1,part2 = day8("Day8/data.txt");
# 0.004315 seconds (43.99 k allocations: 2.289 MiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 9:");
@time part1,part2 = day9("Day9/data.txt");
# 0.013390 seconds (106.64 k allocations: 5.641 MiB)
println("Solution 1 = $part1. Solution 2 = $part2.");