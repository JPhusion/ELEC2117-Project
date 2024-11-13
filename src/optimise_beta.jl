
"""
find_best_beta(S0, I0, Is0, R0, gamma, gamma_s, delta, ps, tspan, actual_times, actual_I, actual_Is, beta_range)

Finds the best value of β (transmission rate) that minimizes the total error (MSE) between the simulated SIRS model results and actual observed data for both the infected population (I) and the severely ill population (Is).

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
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
- `errors::Vector{Float64}`: A vector of the total errors for each value of β in the tested range.
"""
function optimise_beta(S0, I0, Is0, R0, gamma, gamma_s, delta, ps, tspan, actual_times, actual_I, actual_Is, beta_range)
    best_beta = nothing
    min_error = Inf  # Set the initial minimum error to infinity
    errors = []  # To store the errors for each beta
    
    # Loop through each value of beta in the range
    for beta in beta_range
        # Define and solve the model for the current beta
        problem = define_model(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan)
        solution = solve(problem, Tsit5())
        
        # Calculate the error for the current solution
        error = calculate_error(solution, actual_times, actual_I, actual_Is)
        push!(errors, error)
        
        # Check if this is the smallest error so far
        if error < min_error
            min_error = error
            best_beta = beta
        end
    end
    
    return best_beta, min_error, errors
end



"""
optimise_beta_intervention(S0, I0, Is0, R0, gamma, gamma_s, delta, ps, tspan, actual_times, actual_I, actual_Is, beta_range)

Finds the best value of β (transmission rate) that minimizes the total error (MSE) between the simulated SIRS model results and actual observed data for both the infected population (I) and the severely ill population (Is).

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
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
- `errors::Vector{Float64}`: A vector of the total errors for each value of β in the tested range.
"""
function optimise_beta_intervention(S0, I0, Is0, R0, gamma, gamma_s, delta, ps, epsilon_i, p_i, tspan, actual_times, actual_I, actual_Is, beta_range, intervention_day)
    best_beta = nothing
    min_error = Inf  # Set the initial minimum error to infinity
    errors = []  # To store the errors for each beta
    
    # Loop through each value of beta in the range
    for beta in beta_range
        # Define and solve the model for the current beta
        problem = define_model_with_intervention(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, epsilon_i, p_i, tspan, intervention_day)
        solution = solve(problem, Tsit5())
        
        # Calculate the error for the current solution
        error = calculate_error(solution, actual_times, actual_I, actual_Is)
        push!(errors, error)
        
        # Check if this is the smallest error so far
        if error < min_error
            min_error = error
            best_beta = beta
        end
    end
    
    return best_beta, min_error, errors
end

