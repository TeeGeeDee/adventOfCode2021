using DataStructures

function day14(file)
    data = readlines(file);
    template = data[1];
    rules = Dict(a=>b for (a,b) in [split(line," -> ") for line in data[3:end]]);

    paircounts = Accumulator{String, Int}();
    for i = 1:(length(template)-1)
        inc!(paircounts,template[i:(i+1)],1);
    end

    function applyrules(paircounts,rules)
        out = Accumulator{String, Int}();
        for k in keys(paircounts)
            if haskey(rules,k)
                inc!(out,k[1]*rules[k],paircounts[k]);
                inc!(out,rules[k]*k[2],paircounts[k]);
            else
                inc!(out,k,paircounts[k]);
            end
        end
        return out
    end

    function maxminusminlettercount(acc,template)
        lettercounter = Accumulator{Char, Int}();
        for k in keys(acc)
            inc!(lettercounter,k[1],acc[k]); # first from each pair...
        end
        inc!(lettercounter,template[end],1); # plus the last letter (remains last)
        return maximum(values(lettercounter))-minimum(values(lettercounter))
    end

    for i = 1:10 paircounts = applyrules(paircounts,rules); end
    part1 = maxminusminlettercount(paircounts,template);
    for i = 1:30 paircounts = applyrules(paircounts,rules); end
    part2 = maxminusminlettercount(paircounts,template);
    return part1,part2
end
