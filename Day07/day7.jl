using Statistics

function day7(file)
    y = parse.(Int,split(readline(file),","));
    med = Int(round(median(y))); # minimizes sum abs distance
    loss2(x,y) = sum((y.-x).^2+abs.(y.-x))/2;
    candidate1 = Int(round(mean(y)));
    candidate2 = candidate1 + sign(mean(y.>mean(y)));
    return sum(abs.(y.-med)), Int(minimum((loss2(candidate1,y),loss2(candidate2,y))))
end

#= Workings:
loss function (cost of fuel)
  think of triangle within discrete square which includes diagonal
  e.g. 0 0 1 = 0 0 0 + 0 0 1
       0 1 1   0 0 1   0 1 0
       1 1 1   0 1 1   1 0 0
   = 1/2*(square area - diagonal) + diagonal
   = (d^2 + d)/2
So for single crab position y and target position x the cost is
= ((y-x)^2+abs(y-x))/2
and the cost is additive. So we want:
min_x sum((y-x)^2 +abs(y-x))
= min_x sum(y^2-2xy+x^2+abs(y-x))
Take derivative and set to zero:
d/dx = sum(2x-2y + 1{y>x}-1{y<x})
= 0 if 
2*n*x - 2*sum(y) - sum(y>x) + sum(y<x) = 0
x = mean(y) + (mean(y>x)- mean(y<x))/2
Note that the final term is abs <1/2
So we deduce that the x that minimizes is within 1 of the mean, 
above iff most y are above.
Since we minimize over Ints only, there are two candidates:
mean(y) and mean(y)+sign(mean(y.>mean(y))
=#
