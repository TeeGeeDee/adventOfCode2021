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
    basinfloor = Array{Union{Missing,CartesianIndex{2}}}(missing, size(mat)...);
    basinfloor[findall(islowpoint)] = findall(islowpoint);
    for ind in findall(mat.!=9)
        path = [ind];
        while ismissing(basinfloor[ind])
            if     isabovelower[ind] move = [-1,0]
            elseif isbelowlower[ind] move = [1,0]
            elseif isleftlower[ind]  move = [0,-1]
            elseif isrightlower[ind] move = [0,1]
            end
            ind = CartesianIndex(Tuple([Tuple(ind)...]+move));
            push!(path,ind);
        end
        for i in path[1:end-1] basinfloor[i] = basinfloor[ind] end # so we can short-cut next time
        basinsize[basinfloor[ind]] += 1;
    end
    largestbasinsizes = basinsize[islowpoint][partialsortperm(basinsize[islowpoint], 1:3,rev=true)]
    return sum(mat[islowpoint].+1),prod(largestbasinsizes)
end
