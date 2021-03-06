function [a, b] = centering(a, b)
if length(a) > length(b)
    lenDiff = length(a) - length(b);
    if rem(lenDiff, 2)
        b = [zeros(fix(lenDiff/2), 1);b;zeros(fix(lenDiff/2)+1, 1)];
    else
        b = [zeros(lenDiff/2, 1);b;zeros(lenDiff/2, 1)];
    end
else
    lenDiff = length(b) - length(a);
    if rem(lenDiff, 2)
        a = [zeros(fix(lenDiff/2), 1);a;zeros(fix(lenDiff/2)+1, 1)];
    else
        a = [zeros(lenDiff/2, 1);a;zeros(lenDiff/2, 1)];
    end
end
end