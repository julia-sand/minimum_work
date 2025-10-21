using Plots,CSV,DataFrames


function make_plot(filename_direct,filename_indirect)
    
    df_direct = DataFrame(CSV.File(filename_direct))
    df_indirect = DataFrame(CSV.File(filename_indirect))

    
    p_mean = plot([df_direct.t,df_indirect.t], [df_direct.x1,df_indirect.x1])
    p_kappa = plot([df_direct.t,df_indirect.t], [df_direct.kappa,df_indirect.kappa])

    # Create subplots
    plot_out = plot(p1,p2,
            layout = (1, 2),  # 1 row, 2 columns
            size = (800, 400)
            )

    savefig(plot_out,"test.png")
end