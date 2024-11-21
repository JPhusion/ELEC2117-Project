module SIRModel
__precompile__(false)

using Plots
pyplot()

using Revise

export define_model, solve_model, plot_model, plot_model_against_data, simulate_model, simulate_model_against_data, cli, simulate_scenario, calculate_error, plot_error, optimise_beta, optimise_beta_ps, optimise_beta_ps_intervention, main, final

include("define_model.jl")
include("solve_model.jl")
include("plot_model.jl")
include("simulate_model.jl")
include("simulate_scenario.jl")
include("cli.jl")
include("optimise_beta.jl")
include("calculate_error.jl")
include("plot_error.jl")
include("optimise_beta_ps.jl")
include("tasks.jl")
include("main.jl")
include("final.jl")

end
