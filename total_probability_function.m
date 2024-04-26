function probability = total_probability_function (tau_exp)

    number = tau_exp;
    probability = 0;

    for i = 1:25
        temp = 1/((number^i) * factorial (i));
        if rem(i,2) == 0
            probability = probability - temp;
        else
            probability = probability + temp;
        end
    end