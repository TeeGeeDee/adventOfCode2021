function day16(file)
    hex = readline(file);
    bin = foldl(*,[string(parse(Int,h,base=16),base=2,pad=4) for h in hex]);
    return sumpacketversions(bin)[1]
end

function sumpacketversions(packet)
    version = parse(Int,packet[1:3],base=2);
    typeid = parse(Int,packet[4:6],base=2);
    if typeid!=4
        lengthtypeid = parse(Int,packet[7],base=2);
        if lengthtypeid==0
            numbits = parse(Int,packet[8:22],base=2);
            if length(packet)==22+numbits rem = "";
            else                          rem = packet[23+numbits:end];
            end
            pac = packet[23:22+numbits];
            while !isempty(pac)
                v,pac = sumpacketversions(pac);
                version += v;
            end
            return version,packet[23+numbits:end]
        else
            numpackets = parse(Int,packet[8:18],base=2);
            rem = packet[19:end];
            for i in 1:numpackets
                v,rem = sumpacketversions(rem);
                version += v;
            end
            return version,rem
        end
    else
        gn = 1;
        while true
            group = packet[7+(gn-1)*5:7+gn*5-1];
            if group[1]=='0' break end
            gn += 1;
        end
        return version,packet[7+gn*5:end]
    end
end
println("ans 1 = $(day16("data.txt"))");

