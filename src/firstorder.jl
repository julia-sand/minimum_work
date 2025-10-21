using DifferentialEquations;
using CSV;
using DataFrames;

#= we start by examining the situation of equilibirum transitions between
two gaussian states in the overdamped dynamics

=#


function solve_indirect_equil(T,g,mu0,muT,filename)

    Lambda = sqrt(2)
    epsilon = 1
  
    
    #vector of parameters
    p = [g, Lambda^2]

    #first order optimality conditions
    function varevolution_harmonic!(du, u, p, t)
        x1,x4,y1,y2 = u
        g, lsq = p #parameters
        du[1] = x4 - x1  #position mean
        du[2] = ((2-g)*(x1+y2))/lsq #control as a state
        du[3] =  y1 - (2-g)*(x1+y2)/lsq #costate 1
        du[4] = -y1 #costate 2
    end

    #the boundary conditions at the start
    function varbc_start!(residual1, u1, p)
        residual1[1] = u1[1] - mu0 #position mean
        residual1[2] = u1[2] - mu0 
    end

    #boundary conditions at the end
    function varbc_end!(residual2,u2,p)
        residual2[1] = u2[1] - muT #position mean
        residual2[2] = u2[2] - muT 
    end

    tspan = (0.0,T)

    #initial guess
    u0 = [1.0,
            1.0,
            1.0,
            1.0]

    function format_sol(sol,model_type)
        df_temp = DataFrame(sol)

        ##SAVE CSV HERE
        rename!(df_temp, [:t, :x1, :kappa, :y1, :y2]) #rename 
        CSV.write(file_name,df_temp)
    end   
    
    bvp3 = TwoPointBVProblem(varevolution_harmonic!, (varbc_start!, varbc_end!), u0, tspan, p;
    bcresid_prototype = (zeros(2),zeros(2)))
    sol3 = solve(bvp3, LobattoIIIa5(),#nested_nlsolve=true), 
                            dt = 0.1, 
                            progress=true)

    format_sol(sol3,model_type) 

end

