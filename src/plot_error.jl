using Plots

"""
plot_error_vs_beta(S0, I0, Is0, R0, gamma, gamma_s, delta, ps, tspan, actual_times, actual_I, actual_Is, beta_range)

Calculates the error for each value of β in the given range by simulating the SIRS model and comparing it with the actual data for both the infected (I) and severely ill (Is) populations. Then, plots the errors against β and highlights the value of β that minimizes the error.

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
- `c::Float64`: Average number of contacts for each individual.
- `gamma::Float64`: Recovery rate for the infected population.
- `gamma_s::Float64`: Recovery rate for the severely ill population.
- `delta::Float64`: Re-susceptibility rate for the recovered population.
- `ps::Float64`: Proportion of infected individuals who develop severe illness.
- `tspan::Tuple{Float64, Float64}`: The time span over which the model will be solved.
- `actual_times::Vector`: A vector containing the time points at which the actual data was observed.
- `actual_I::Vector`: A vector of the observed data for the infected population (I) at the given time points.
- `actual_Is::Vector`: A vector of the observed data for the severely ill population (Is) at the given time points.
- `beta_range::AbstractRange`: The range of β values to test in order to minimize the error.

# Returns:
- `best_beta::Float64`: The value of β that produces the lowest total error.
- `min_error::Float64`: The minimum error corresponding to the best value of β.

# Plot:
- A plot of the errors (Mean Squared Error) against the corresponding β values. The best β value with the minimum error is highlighted on the plot.
"""
function plot_error(S0, I0, Is0, R0, c, gamma, gamma_s, delta, ps, tspan, actual_times, actual_I, actual_Is, beta_range)
    beta_range = beta_range / c
    # Call the find_best_beta function to calculate the errors for each beta
    best_beta, min_error, errors = optimise_beta(S0, I0, Is0, R0, gamma, gamma_s, delta, ps, tspan, actual_times, actual_I, actual_Is, beta_range .* c)
    # Plot the errors against the corresponding beta values
    plt = plot(beta_range, errors, xlabel="Beta", ylabel="Error (MSE)", 
         title="Error vs Beta", label="MSE", linewidth=1, ms=2, legend=:topright, tickfontsize=6, guidefontsize=8, titlefontsize=10)
    
    # Highlight the best beta with the minimum error
    offset = 20
    scatter!([best_beta / c], [min_error], color=:red, label="Best Beta", markersize=2)
    annotate!(best_beta / c, min_error + offset, text("Beta = $(best_beta/c)", :red, 8))
    
    # Return the best beta and the minimum error
    return plt, best_beta / c, min_error
end


"""
plot_error_intervention(S0, I0, Is0, R0, gamma, gamma_s, delta, ps, tspan, actual_times, actual_I, actual_Is, beta_range)

Calculates the error for each value of β in the given range by simulating the SIRS model and comparing it with the actual data for both the infected (I) and severely ill (Is) populations. Then, plots the errors against β and highlights the value of β that minimizes the error.

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
- `c::Float64`: Average number of contacts for each individual.
- `gamma::Float64`: Recovery rate for the infected population.
- `gamma_s::Float64`: Recovery rate for the severely ill population.
- `delta::Float64`: Re-susceptibility rate for the recovered population.
- `ps::Float64`: Proportion of infected individuals who develop severe illness.
- `tspan::Tuple{Float64, Float64}`: The time span over which the model will be solved.
- `actual_times::Vector`: A vector containing the time points at which the actual data was observed.
- `actual_I::Vector`: A vector of the observed data for the infected population (I) at the given time points.
- `actual_Is::Vector`: A vector of the observed data for the severely ill population (Is) at the given time points.
- `beta_range::AbstractRange`: The range of β values to test in order to minimize the error.

# Returns:
- `best_beta::Float64`: The value of β that produces the lowest total error.
- `min_error::Float64`: The minimum error corresponding to the best value of β.

# Plot:
- A plot of the errors (Mean Squared Error) against the corresponding β values. The best β value with the minimum error is highlighted on the plot.
"""
function plot_error_intervention(S0, I0, Is0, R0, c, gamma, gamma_s, delta, ps, epsilon_i, p_i, tspan, actual_times, actual_I, actual_Is, beta_range, intervention_day)
    beta_range = beta_range / c
    # Call the find_best_beta function to calculate the errors for each beta
    best_beta, min_error, errors = optimise_beta_intervention(S0, I0, Is0, R0, gamma, gamma_s, delta, ps, epsilon_i, p_i, tspan, actual_times, actual_I, actual_Is, beta_range .* c, intervention_day)
    
    # Plot the errors against the corresponding beta values
    plt = plot(beta_range, errors, xlabel="Beta", ylabel="Error (MSE)", 
         title="Error vs Beta", label="MSE", linewidth=1, ms=2, legend=:topright, tickfontsize=6, guidefontsize=8, titlefontsize=10)
    
    # Highlight the best beta with the minimum error
    offset = 20
    scatter!([best_beta / c], [min_error], color=:red, label="Best Beta", markersize=2)
    annotate!(best_beta / c, min_error + offset, text("Beta = $(best_beta/c)", :red, 4))
    
    # Return the best beta and the minimum error
    return plt, best_beta / c, min_error
end
