
#declare variables
const T = 3
const g = 0.01
const mu0 = 0
const muT = 2

#filename_indirect = "results/indirect.csv"
filename_direct = "results/direct.csv"

#import scripts
include("direct.jl")
#include("firstorder.jl")
include("viz/plotall.jl")

#integrate both models
solve_direct_equil(T,g,mu0,muT,filename_direct)
#solve_indirect_equil(T,g,mu0,muT,filename_indirect)

#make plots
make_plot(filename_direct)
