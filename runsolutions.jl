include("Day01/day1.jl");
include("Day02/day2.jl");
include("Day03/day3.jl");
include("Day04/day4.jl");
include("Day05/day5.jl");
include("Day06/day6.jl");
include("Day07/day7.jl");
include("Day08/day8.jl");
include("Day09/day9.jl");
include("Day10/day10.jl");
include("Day11/day11.jl");
include("Day12/day12.jl");
include("Day13/day13.jl");
include("Day14/day14.jl");
include("Day15/day15.jl");
include("Day16/day16.jl");
include("Day17/day17.jl");
include("Day18/day18.jl");
include("Day19/day19.jl");
include("Day20/day20.jl");
include("Day21/day21.jl");
include("Day22/day22.jl");
include("Day23/day23.jl");


# get compilation done (is this fair?)
# what it says to do here: https://docs.julialang.org/en/v1/manual/performance-tips/#Measure-performance-with-[@time](@ref)-and-pay-attention-to-memory-allocation
day1("Day01/data.txt");
day2("Day02/data.txt");
day3("Day03/data.txt");
day4("Day04/data.txt");
day5("Day05/data.txt");
day6("Day06/data.txt");
day7("Day07/data.txt");
day8("Day08/data.txt");
day9("Day09/data.txt");
day10("Day10/data.txt");
day11("Day11/data.txt");
day12("Day12/data.txt");
day13("Day13/data.txt");
day14("Day14/data.txt");
day15("Day15/data.txt");
day16("Day16/data.txt");
day17("Day17/data.txt");
day18("Day18/data.txt");
day19("Day19/data.txt");
day20("Day20/data.txt");
day21("Day21/data.txt");
day22("Day22/data.txt");
day23("Day23/data.txt");


println("Day 1:");
@time part1,part2 = day1("Day01/data.txt");
# 0.000376 seconds (4.03 k allocations: 242.875 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 2:");
@time part1,part2 = day2("Day02/data.txt");
# 0.000414 seconds (4.03 k allocations: 343.469 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 3:");
@time part1,part2 = day3("Day03/data.txt");
# 0.000650 seconds (5.30 k allocations: 359.203 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 4:");
@time part1,part2 = day4("Day04/data.txt");
# 0.014216 seconds (91.38 k allocations: 4.077 MiB, 63.73% compilation time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 5:");
@time part1,part2 = day5("Day05/data.txt");
# 0.019932 seconds (7.54 k allocations: 23.244 MiB, 35.21% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 6:");
@time part1,part2 = day6("Day06/data.txt");
# 0.000226 seconds (359 allocations: 68.852 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 7:");
@time part1,part2 = day7("Day07/data.txt");
# 0.000191 seconds (34 allocations: 149.385 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 8:");
@time part1,part2 = day8("Day08/data.txt");
# 0.004315 seconds (43.99 k allocations: 2.289 MiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 9:");
@time part1,part2 = day9("Day09/data.txt");
# 0.001580 seconds (19.29 k allocations: 2.547 MiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 10:");
@time part1,part2 = day10("Day10/data.txt");
# 0.000341 seconds (640 allocations: 475.325 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 11:");
@time part1,part2 = day11("Day11/data.txt");
# 0.012160 seconds (137.77 k allocations: 4.760 MiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 12:");
@time part1,part2 = day12("Day12/data.txt");
# 0.321472 seconds (6.99 M allocations: 488.144 MiB, 12.29% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 13:");
@time part1,part2 = day13("Day13/data.txt");
# 0.007556 seconds (8.30 k allocations: 723.387 KiB, 84.07% compilation time)
println("Solution 1 = $part1. Solution 2 =");
display(part2);
println("");
println("Day 14:");
@time part1,part2 = day14("Day14/data.txt");
# 0.001807 seconds (26.26 k allocations: 1.252 MiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 15:");
@time part1,part2 = day15("Day15/data.txt");
# 0.544399 seconds (1.82 M allocations: 251.915 MiB, 7.12% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 16:");
@time part1,part2 = day16("Day16/data.txt");
# 0.001322 seconds (12.74 k allocations: 4.466 MiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 17:");
@time part1,part2 = day17("Day17/data.txt");
# 0.000837 seconds (6.40 k allocations: 596.000 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 18:");
@time part1,part2 = day18("Day18/data.txt");
# 1.631210 seconds (17.09 M allocations: 1.599 GiB, 9.50% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 19:");
@time part1,part2 = day19("Day19/data.txt");
# 6.131743 seconds (28.99 M allocations: 8.473 GiB, 17.15% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 20:");
@time part1,part2 = day20("Day20/data.txt");
# 2.271468 seconds (53.19 M allocations: 2.152 GiB, 13.18% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 21:");
@time part1,part2 = day21("Day21/data.txt");
# 0.000374 seconds (3.67 k allocations: 141.781 KiB)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 22:");
@time part1,part2 = day22("Day22/data.txt");
# 0.466528 seconds (4.06 M allocations: 366.843 MiB, 5.76% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 23:");
@time part1,part2 = day23("Day23/data.txt");
# 2.880616 seconds (8.78 M allocations: 901.155 MiB, 10.98% gc time)
println("Solution 1 = $part1. Solution 2 = $part2.");
