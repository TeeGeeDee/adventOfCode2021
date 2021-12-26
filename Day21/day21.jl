
mutable struct Dice
    value::Int
    rollcount::Int
    Dice() = new(1,0);
end
function roll!(dice::Dice)
    out = dice.value;
    dice.value = dice.value==100 ? 1 : dice.value+1;
    dice.rollcount += 1;
    return out
end

function day21(file)
    startpositions = [parse(Int,s[findfirst(":",s)[1]+2:end]) for s in eachline(file)];
    scores = zeros(Int,2);
    move(position::Int,moves::Int) = mod(position-1+moves,10)+1;

    activeplayer,dice,positions = 1,Dice(),copy(startpositions);
    while all(scores.<1000)
        positions[activeplayer] = move(positions[activeplayer],sum(roll!(dice) for _ in 1:3));
        scores[activeplayer] += positions[activeplayer];
        activeplayer = activeplayer==1 ? 2 : 1;
    end
    return minimum(scores)*dice.rollcount
end
