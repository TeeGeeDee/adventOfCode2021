using DataFrames

function day17(file)
    data = readline(file);
    getmaxheight(y) = Int(y*(y+1)/2); # moves y,y-1,y-2...,1 up before going down
    boxbottom = parse(Int,data[(collect(findlast("=",data))[1]+1):(collect(findlast("..",data))[1]-1)]);
    boxtop = parse(Int,data[(collect(findlast(".",data))[1]+1):end]);
    boxleft = parse(Int,data[(collect(findfirst("=",data))[1]+1):(collect(findfirst("..",data))[1]-1)]);
    boxright = parse(Int,data[(collect(findfirst(".",data))[1]+2):(collect(findfirst(",",data))[1]-1)]);

    @assert boxbottom<0 # question only makes sense this way
    part1 = getmaxheight(-1*boxbottom-1);

    # Part 2 idea: consider x and y seperately - when each velocity is in area, and then join on times
    depth(y,t) = Int(t*y-(t-1)*t/2); # count movement from initial velocity, plus that from gravity
    #= solve quadratic -t^2/2+t(y+1/2)-d=0 to find first time probe reaches area
    Take + solution, since - corresponds to negative time solution
    =#
    firstpasty(y,d) = ceil(y+1/2 + sqrt((y+0.5)^2-2*d));
    # use this to search for where y coordinate is in area (first time in plus check after)
    ybounds = boxbottom:(-1*boxbottom-1);
    yarrivalpairs = [];
    for y in ybounds
        t = firstpasty(y,boxtop);
        while boxtop>=depth(y,t)>=boxbottom
            push!(yarrivalpairs,(y=y,t=t));
            t += 1;
        end
    end

    # when considering x, x position remains static, so we need a limit
    longestwait = maximum([a[2] for a in yarrivalpairs]);
    # Now consider x position after time t
    width(x,t) = t>x ? Int(x*(x+1)/2) : Int(t*(2*x+1)/2-t^2/2);
    # similarly solve quadratic (- solution this time, for first) to find first entrance into area
    firstpastx(x,w) = Int(ceil((2*x+1-sqrt((2x+1)^2-8*w))/2));

    # solve n^2+n-2*boxleft = 0 for lowest velocity that will reach
    xbounds = Int(ceil((sqrt(1+8*boxleft)-1)/2)):boxright;
    xarrivalpairs = [];
    for x in xbounds
        t = firstpastx(x,boxleft);
        while boxleft<=width(x,t)<=boxright
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
