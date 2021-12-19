function day16(file)
    hex = readline(file);
    bin = foldl(*,[string(parse(Int,h,base=16),base=2,pad=4) for h in hex]);
    return parsepacket(bin)[1:2]
end

function parsepacket(packet)
    version = parse(Int,packet[1:3],base=2);
    typeid = parse(Int,packet[4:6],base=2);
    if typeid!=4
        lengthtypeid = parse(Int,packet[7],base=2);
        if lengthtypeid==0
            nbits = parse(Int,packet[8:22],base=2);
            remainder = packet[23+nbits:end]
            packet = packet[23:22+nbits];
            values = [];
            while !isempty(packet)
                ver,val,packet = parsepacket(packet);
                version += ver;
                push!(values,val);
            end
            return version,compileoperation(typeid,values),remainder
        else
            numpackets = parse(Int,packet[8:18],base=2);
            remainder = packet[19:end];
            values = [];
            for _ in 1:numpackets
                ver,val,remainder = parsepacket(remainder);
                version += ver;
                push!(values,val);
            end
            return version,compileoperation(typeid,values),remainder
        end
    else
        gn,values = 1,[];
        while true
            group = packet[7+(gn-1)*5:7+gn*5-1];
            append!(values,group[2:end]);
            if group[1]=='0' break end
            gn += 1;
        end
        return version,parse(Int,foldl(*,values),base=2),packet[7+gn*5:end]
    end
end

function compileoperation(id,values)
    if     id==0 return sum(values)
    elseif id==1 return prod(values)
    elseif id==2 return minimum(values)
    elseif id==3 return maximum(values)
    elseif id==5 return 1*(values[1]>values[2])
    elseif id==6 return 1*(values[1]<values[2])
    elseif id==7 return 1*(values[1]==values[2])
    else error("unexpected typeid for operation")
    end
end
