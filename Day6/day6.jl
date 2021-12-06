function day6(file)
    starttimes = parse.(Int,split(readline(file),","));
    timecounts = zeros(Int,9,1); # num of fish with times 0,...,8
    for i in starttimes timecounts[i+1] += 1 end # 0->1 indexing
    return countafterndays(timecounts,80),countafterndays(timecounts,256)
end

function countafterndays(counts,ndays)
    for i = 1:ndays
        counts = circshift(counts,-1);
        counts[7] += counts[end]; # circshift sent 0->8, also need to add to 6
    end
    return sum(counts)
end
