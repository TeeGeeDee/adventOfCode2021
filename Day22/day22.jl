function day22(file)
    data = readlines(file);
    onoff = [startswith(s,"on") for s in data];
    cubeedges = [parse.(Int,split(replace(s,"on "=>"","off "=>"",r"(x|y|z)="=>"",".."=>","),",")) for s in data];
    cubes = [CartesianIndices(Tuple(max(c[2*(i-1)+1],-50):min(c[2*i],50) for i in 1:3)) for c in cubeedges];
    oncubes = Set{CartesianIndex{3}}();
    popsafe!(s,v) = v in s ? pop!(s,v) : nothing;
    for (on,cubeinds) in zip(onoff,cubes)
        f = on ? push! : popsafe!;
        for c in cubeinds f(oncubes,c); end
    end
    return length(oncubes)
end
