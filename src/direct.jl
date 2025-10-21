using OptimalControl, Ipopt;
using DataFrames;
using CSV;
#=We minimize entropy production between EQUILIBRIUM states for a gaussian particle in a moving trap
=#

############################

function solve_direct_equil_old(T,g,mu0,muT,filename)
    
    Lambda = sqrt(2)

    @def begin
        t ∈ [0, T], time
        x ∈ R, state
        u ∈ R, control
        x(0) == mu0
        x(T) == muT
        ẋ(t) == x(t)-u(t)
        ∫( (x(t)-u(t))^2 ) → min
    end

    sol = solve(ocp)

    ########################

    df = DataFrame(sol)

    CSV.write(file_name, df)
    
end
