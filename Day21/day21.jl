using Memoization

mutable struct Dice
    value::Int
    rollcount::Int
    Dice() = new(1,0);
end
function roll!(dice::Dice)
    out            = dice.value;
    dice.value     = dice.value==100 ? 1 : dice.value+1;
    dice.rollcount += 1;
    return out
end

move(position::Int,moves::Int) = mod(position-1+moves,10)+1;
nextplayer(player::Int)        = player==1 ? 2 : 1;

function day21(file)
    startpositions = Tuple(parse(Int,s[findfirst(":",s)[1]+2:end]) for s in eachline(file));
    scores = zeros(Int,2);
    activeplayer,dice,positions = 1,Dice(),startpositions;
    while all(scores.<1000)
        diceroll = sum(roll!(dice) for _ in 1:3);
        (scores,positions,activeplayer) = makemove(diceroll,Tuple(scores),positions,activeplayer);
    end
    freq = zeros(Int,9);
    for i=1:3,j=1:3,k=1:3
        freq[i+j+k] += 1;
    end

    @memoize function numwinsfrom(scores::Tuple{Int,Int},positions::Tuple{Int,Int},activeplayer::Int,freq)
        haswon = scores.>=21;
        if any(haswon)
            return Int.(haswon)
        else
            wins = (0,0);
            for diceroll = 1:9
                (nextscores,nextpositions,nextplayer) = makemove(diceroll,scores,positions,activeplayer);
                wins = wins .+ freq[diceroll] .* numwinsfrom(nextscores,nextpositions,nextplayer,freq);
            end
            return wins
        end
    end

    return minimum(scores)*dice.rollcount,maximum(numwinsfrom((0,0),startpositions,1,freq))
end

function makemove(diceroll::Int,scores::Tuple{Int,Int},positions::Tuple{Int,Int},activeplayer::Int)
    positions,scores = collect(positions),collect(scores);
    positions[activeplayer] = move(positions[activeplayer],diceroll);
    scores[activeplayer]    += positions[activeplayer];
    return Tuple(scores),Tuple(positions),nextplayer(activeplayer)
end
