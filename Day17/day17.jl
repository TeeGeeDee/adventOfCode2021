using DataFrames

function day17(file)
    data = readline(file);
    getmaxheight(y) = Int(y*(y+1)/2); # moves y,y-1,y-2...,1 up before going down
    arealeft,arearight,areabottom,areatop = parse.(Int,split(replace(replace(data,"target area: x="=>""),", y="=>".."),".."));
    @assert areabottom<0 # question only makes sense this way, else unbounded
    part1 = getmaxheight(-1*areabottom-1);

    # Part 2 idea: consider x and y seperately - times when each velocity is in area, and then join on times
    depth(yvelocity,t) = Int(t*yvelocity-(t-1)*t/2); # count movement from initial velocity, plus that from gravity
    #= solve quadratic -t^2/2+t(y+1/2)-d=0 to find first time probe reaches area
    Take + solution, since - corresponds to negative time solution
    =#
    firsttimeinarea_y(y) = ceil(y+1/2 + sqrt((y+0.5)^2-2*areatop));
    # use this to search for where y coordinate is in area (first time in plus check after)
    yarrivalpairs = [];
    for y in areabottom:(-1*areabottom-1)
        t = firsttimeinarea_y(y);
        while areatop>=depth(y,t)>=areabottom
            push!(yarrivalpairs,(y=y,t=t));
            t += 1;
        end
    end

    # when considering x, x position remains static, so we need a limit relevant for the eventual join
    longestwait = maximum([a[2] for a in yarrivalpairs]);
    # Now consider x position after time t
    width(x,t) = t>x ? Int(x*(x+1)/2) : Int(t*(2*x+1)/2-t^2/2);
    # similarly solve quadratic (- solution this time, for first) to find first entrance into area
    firsttimeinarea_x(x) = Int(ceil((2*x+1-sqrt((2x+1)^2-8*arealeft))/2));

    xarrivalpairs = [];
    for x in Int(ceil((sqrt(1+8*arealeft)-1)/2)):arearight # solve n^2+n-2*arealeft = 0 for lowest velocity that will reach
        t = firsttimeinarea_x(x);
        while arealeft<=width(x,t)<=arearight
            push!(xarrivalpairs,(x=x,t=t));
            if t==x
                for a = x+1:longestwait
                    push!(xarrivalpairs,(x=x,t=a));
                end
                break;
            end
            t += 1;
        end
    end
    # join times when x and y coordinates are both in the area at the same time
    hits = innerjoin(DataFrame(xarrivalpairs),DataFrame(yarrivalpairs),on = :t);
    part2 = size(unique(hits[:,[:x,:y]]))[1];
    return part1,part2
end
