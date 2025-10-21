using InfiniteOpt, Ipopt;
using DataFrames;
using CSV;

#=We minimize entropy production between EQUILIBRIUM states
where the boundary conditions are given by GAUSSIANs
Example 4.1: 
-we keep the means constant, and look only at the change of variance problem
-minimization of dissipation between equilibrium states at fixed time horizon.
-stiffness (kappa) is a state 
=#

############################

function solve_direct_equil(T,g,mu0,muT,filename)
    
    Lambda = sqrt(2)

       
    #define the model
    model = InfiniteModel(Ipopt.Optimizer);

    #time
    @infinite_parameter(model, 
                            t in [0, T], 
                            num_supports = 9001, 
                            derivative_method=FiniteDifference(Forward(), true))

    #position mean
    @variable(model, x1, Infinite(t), start=mu0)

    #kappa, the trap center
    @variable(model, kappa, Infinite(t), start=1)

    #define the objective, see Eq. (20)
    #minimise the ENTROPY PRODUCTION
    @objective(model, Min, 
                integral(x1-kappa, t)) 
    
    #boundary conditions
    #initial
    @constraint(model, x1(0) == mu0)
    
    #final
    @constraint(model, x1(T) == muT)
    
    #for model between equilibrium systems, we need the following constraint (7)&(8)
    @constraint(model, kappa(0) == mu0)
    @constraint(model, kappa(T) == muT)
    
    #constraint on kappa
    @constraint(model, -Lambda <= deriv(kappa,t) <= Lambda)

    #enforce the dynamics
    @constraint(model, deriv(x1,t) == kappa(t)-x1(t))
    
    # SOLVE THE MODEL
    optimize!(model)

    ########################

    #save the results of the optimisation to CSV
    coords = hcat(collect.(supports(x1))...)'
    
    data_rows = [coords[:,1],value(x1),value(kappa)]
        
    df = DataFrame(data_rows,
                        ["t", "x1", "kappa"])

    CSV.write(file_name, df)
    
end
