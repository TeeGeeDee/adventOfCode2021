function day9(file)
    mat = reduce(vcat,[[parse(Int,c) for c in l]' for l in eachline(file)]);
    isabovelower = reduce(hcat,[[i==1 ? false : mat[i-1,j]<mat[i,j] for i in 1:size(mat,1)]'' for j in 1:size(mat,2)]);
    isbelowlower = circshift(.!isabovelower,(-1,0));
    isbelowlower[end,:] .= false;
    isleftlower  = reduce(hcat,[[j==1 ? false : mat[i,j-1]<mat[i,j] for i in 1:size(mat,1)]'' for j in 1:size(mat,2)]);
    isrightlower = circshift(.!isleftlower,(0,-1));
    isrightlower[:,end] .= false;
    numlowerneighbours = isabovelower + isbelowlower + isleftlower + isrightlower;
    islowpoint = numlowerneighbours.==0;
    # part 2:
    basinsize = zeros(Int,size(mat)...);
    for ind in findall(mat.!=9)
        p = [Tuple(ind)...];
        while true # take any route downhill - they all end in the same place
            if     isabovelower[ind] p .+= [-1,0]
            elseif isbelowlower[ind] p .+= [1,0]
            elseif isleftlower[ind]  p .+= [0,-1]
            elseif isrightlower[ind] p .+= [0,1]
            end
            ind = CartesianIndex((p...));
            if islowpoint[ind] basinsize[ind] +=1; break end
        end
    end
    largestbasinsizes = basinsize[islowpoint][partialsortperm(basinsize[islowpoint], 1:3,rev=true)]
    return sum(mat[islowpoint].+1),prod(largestbasinsizes)
end
