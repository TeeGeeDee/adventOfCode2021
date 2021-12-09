# TODO - tidy, speed-up, maybe automate logic currently on lines 14-17
const DIGITS = ["abcefg","cf","acdeg","acdfg","bcdf",
                                "abdfg","abdefg","acf","abcdefg","abcdfg"];
const LETTER_COUNT_MAP = Dict(4=>'e',6=>'b',9=>'f');

function day8(file)
    dataraw = [(a,b) = split(x," | ") for x in readlines(file)];
    data = [[split(x) for x in y] for y in dataraw];
    uniquelengths = [len for (len,count) in getcounts(length.(DIGITS)) if count==1];
    nwithuniquelen = sum(sum(length.(x[2]) .∈ Ref(uniquelengths)) for x in data)
    return nwithuniquelen, sum(decode(row[1],row[2]) for row in data)
end

function getcounts(v)
    counts = Dict();
    for x in v haskey(counts,x) ? counts[x] +=1 : counts[x] = 1 end
    return counts
end

function decode(code,output)
    counts = getcounts(reduce(*,code));
    lettermap = Dict(l=>LETTER_COUNT_MAP[c] for (l,c) in counts if haskey(LETTER_COUNT_MAP,c))
    lettermap[[l for l in code[length.(code).==2][1] if l ∉ keys(lettermap)][1]] = 'c';
    lettermap[[l for (l,v) in counts if (v==8) & (!haskey(lettermap,l))][1]] = 'a';
    lettermap[[l for l in code[length.(code).==4][1] if l ∉ keys(lettermap)][1]] = 'd';
    lettermap[[l for (l,v) in counts if (v==7) & (!haskey(lettermap,l))][1]] = 'g';

    translatedoutput = [reduce(*,sort([lettermap[letter] for letter in digit])) for digit in output];
    stringtonumchar = Dict(DIGITS[i]=>string(i-1)[1] for i in 1:length(DIGITS));
    return parse(Int,reduce(*,stringtonumchar[c] for c in translatedoutput))
end
