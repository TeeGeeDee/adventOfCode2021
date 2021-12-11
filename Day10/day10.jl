using DataStructures

const POINTS1 = Dict(')'=>3,']'=>57,'}'=>1197,'>'=>25137);
const POINTS2 = Dict('('=>1,'['=>2,'{'=>3,'<'=>4);
const OPEN_OF = Dict(')'=>'(',']'=>'[','}'=>'{','>'=>'<');

function day10(file)
    points1 = 0;
    points2 = RBTree{Int}();
    for (i,line) in enumerate(eachline(file))
        stack = Stack{Char}();
        iscorrupted = false;
        for c in line
            if c in keys(OPEN_OF) # closes
                if pop!(stack) != OPEN_OF[c]
                    points1 += POINTS1[c];
                    iscorrupted = true;
                    break
                end
            else
                push!(stack,c);
            end
        end
        if !iscorrupted
            total = 0;
            while !isempty(stack)
                total *= 5;
                total += POINTS2[pop!(stack)];
            end
            push!(points2,total);
        end
    end
    return points1,points2[length(points2)÷2+1]
end
