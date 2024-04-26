function [x, y] = solve_single_p (total_probability, P_ij)

    y = (total_probability /(1 + P_ij));
    x = P_ij * y;
end