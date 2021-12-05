include("Day1/day1.jl");
include("Day2/day2.jl");
include("Day3/day3.jl");
include("Day4/day4.jl");
include("Day5/day5.jl");

println("Day 1:");
@time part1,part2 = day1("Day1/data.txt");
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 2:");
@time part1,part2 = day2("Day2/data.txt");
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 3:");
@time part1,part2 = day3("Day3/data.txt");
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 4:");
@time part1,part2 = day4("Day4/data.txt");
println("Solution 1 = $part1. Solution 2 = $part2.");
println("Day 5:");
@time part1,part2 = day5("Day5/data.txt");
println("Solution 1 = $part1. Solution 2 = $part2.");

