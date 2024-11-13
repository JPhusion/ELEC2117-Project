using Plots

"""
plot_model(solution)

Plots the result of the solved ODE model.

# Arguments:
- `solution`: The solution object from the ODE solver.

# Description:
Creates a plot displaying the dynamics of susceptible, infected, severely ill, and recovered individuals over time.
"""
function plot_model(solution, title="Model Simulation")
    plt = plot(solution, title=title, xlabel="Time (days)", ylabel="Number of People",
        label=["Susceptible" "Infectious" "Severe Illness" "Recovered"], lw=1, tickfontsize=6, guidefontsize=8, titlefontsize=10)
    savefig("output.png")  # Save plot as PNG
    return plt
end

"""
plot_model_against_data(solution, data)

Plots the result of the solved ODE model.

# Arguments:
- `solution`: The solution object from the ODE solver.
- `data::Vector{Float64}`: Real-world data to compare against the model.

# Description:
Creates a plot displaying the dynamics of susceptible, infected, severely ill, and recovered individuals over time against the inputted model data.
"""
function plot_model_against_data(
    solution::ODESolution,
    dataI::Vector{Float64},
    dataIs::Vector{Float64}
)
    t = solution.t
    I = solution[2, :]
    Is = solution[3, :]
    R = solution[4, :]

    # Filter dataI and dataIs to only plot values greater than 0
    valid_dataI_indices = findall(x -> x >= 0, dataI)
    valid_dataIs_indices = findall(x -> x >= 0, dataIs)
    
    plt = plot(t, I, title="Plot Against Data", xlabel="Time (days)", ylabel="Number of People", label = "Infected", color = :orange, tickfontsize=6, guidefontsize=8, titlefontsize=10)
    plot!(t, Is, label = "Severely Infected", color = :red)
    plot!(t, R, label = "Recovered", color = :green)

    # Plot filtered data points
    scatter!(valid_dataI_indices, dataI[valid_dataI_indices], label="Estimated Number of Infected People", color=:yellow, ms=4)
    scatter!(valid_dataIs_indices, dataIs[valid_dataIs_indices], label="Estimated Number of Severe Illness People", color=:red, ms=4)

    return plt
end

