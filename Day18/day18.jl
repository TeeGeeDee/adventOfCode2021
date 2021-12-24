function day18(file)
    lines = readlines(file);
    return magnitude(addlines(lines)), maxpair(lines)
end

function maxpair(lines)
    maxsofar = 0;
    for i = 1:length(lines), j = 1:length(lines)
        if i==j continue end
        m = magnitude(add(lines[i],lines[j]));
        if m>maxsofar maxsofar = m; end
    end
    return maxsofar
end

function addlines(lines)
    return foldl(add,lines)
end

function add(s1,s2)
    return reducestr("["*s1*","*s2*"]")
end

function magnitude(str)
    level = cumsum([(c=='[' ? 1 : 0) - (c==']' ? 1 : 0) for c in str]);
    middlecomma = findfirst((level.==1) .& (collect(str).==','));
    if isnothing(middlecomma) # scalar
        return parse(Int,str)
    else
        return 3*magnitude(str[2:(middlecomma-1)])+2*magnitude(str[(middlecomma+1):end-1])
    end
end

function reducestr(str)
    while true
        s = explode(str);
        if !isnothing(s)
            str = s;
            continue
        end
        s = splitstep(str);
        if !isnothing(s)
            str = s;
        else
            break
        end
    end
    return str
end

function explode(str)
    level = cumsum([(c=='[' ? 1 : 0) - (c==']' ? 1 : 0) for c in str]);
    pairs = collect(eachmatch(r"\[[0-9]+,[0-9]+\]",str));
    pairishigh = [level[p.offset]>=5 for p in pairs];
    if !any(pairishigh) return nothing end
    pair = pairs[findfirst(pairishigh)];
    numsinpair = parse.(Int,split(strip(pair.match,['[',']']),','));
    prevnums = eachmatch(r"[0-9]+",str[1:(pair.offset-1)]);
    firstbit = str[1:(pair.offset-1)];
    if !isempty(prevnums)
        prev = last(collect(prevnums));
        firstbit = firstbit[1:(prev.offset-1)]*string(parse(Int,prev.match)+numsinpair[1])*firstbit[(prev.offset+length(prev.match)):end];
    end
    lastbit = str[pair.offset+length(pair.match):end];
    nextnums = eachmatch(r"[0-9]+",lastbit);
    if !isempty(nextnums)
        nextnum = first(nextnums);
        lastbit = lastbit[1:(nextnum.offset-1)]*string(parse(Int,nextnum.match)+numsinpair[2])*lastbit[(nextnum.offset+length(nextnum.match)):end];
    end
    return firstbit*"0"*lastbit
end

function splitstep(str)
    nums = parse.(Int,split(strip(str,['[',']']),r"[^0-9]+"));
    indbig = findfirst(nums.>=10);
    if isnothing(indbig) return nothing end
    bignum = nums[indbig];
    indinstr = findfirst(string(bignum),str);
    newpair = "[$(Int(floor(bignum/2))),$(Int(ceil(bignum/2)))]"
    return str[1:(first(indinstr)-1)] * newpair * str[(last(indinstr)+1):end]
end
