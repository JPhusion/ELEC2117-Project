"""
simulate_model(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan)

Simulates the SIRS model, solves the system, and plots the result.

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
- `beta::Float64`: Infection rate of the disease.
- `gamma::Float64`: Recovery rate from the infectious population.
- `gamma_s::Float64`: Recovery rate from severe illness.
- `delta::Float64`: Re-susceptibility rate for the recovered population.
- `ps::Float64`: Proportion of infected individuals who develop severe illness.
- `tspan::Tuple{Float64, Float64}`: Time span for which the model will be solved.

# Description:
This function sets up, solves, and visualizes the SIRS model. It:
1. Defines the ODE model using `define_model`.
2. Solves the ODE model using `solve_model`.
3. Plots the results using `plot_model`, showing the dynamics of susceptible, infected, severely ill, and recovered individuals over time.

# Output:
- The resulting plot is saved as a PNG file (`output.png`), showing the evolution of the SIRS model over time.
"""
function simulate_model(
    S0::Float64,
    I0::Float64,
    Is0::Float64,
    R0::Float64,
    beta::Float64,
    gamma::Float64,
    gamma_s::Float64,
    delta::Float64,
    ps::Float64,
    tspan::Tuple{Float64,Float64}
)
    model = define_model(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan)
    solution = solve_model(model)
    return plot_model(solution)
end

"""
simulate_model_against_data(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan, data)

Simulates the SIRS model and plots the result against real data.

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
- `beta::Float64`: Infection rate of the disease.
- `gamma::Float64`: Recovery rate from the infectious population.
- `gamma_s::Float64`: Recovery rate from severe illness.
- `delta::Float64`: Re-susceptibility rate for the recovered population.
- `ps::Float64`: Proportion of infected individuals who develop severe illness.
- `tspan::Tuple{Float64, Float64}`: Time span for which the model will be solved.
- `dataI::Vector{Float64}`: Real-world data to compare against the model (infected).
- `dataI::Vector{Float64}`: Real-world data to compare against the model (severely infected).

# Description:
This function sets up, solves, and visualizes the SIRS model, then overlays real-world data for comparison.

# Output:
- A plot of the SIRS model overlaid with real data points.
"""
function simulate_model_against_data(
    S0::Float64,
    I0::Float64,
    Is0::Float64,
    R0::Float64,
    beta::Float64,
    gamma::Float64,
    gamma_s::Float64,
    delta::Float64,
    ps::Float64,
    tspan::Tuple{Float64,Float64},
    dataI::Vector{Float64},
    dataIs::Vector{Float64}
)
    model = define_model(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan)
    solution = solve_model(model)
    return plot_model_against_data(solution, dataI, dataIs)
end


"""
simulate_model_against_data(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan, data)

Simulates the SIRS model and plots the result against real data.

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
- `beta::Float64`: Infection rate of the disease.
- `gamma::Float64`: Recovery rate from the infectious population.
- `gamma_s::Float64`: Recovery rate from severe illness.
- `delta::Float64`: Re-susceptibility rate for the recovered population.
- `ps::Float64`: Proportion of infected individuals who develop severe illness.
- `tspan::Tuple{Float64, Float64}`: Time span for which the model will be solved.
- `dataI::Vector{Float64}`: Real-world data to compare against the model (infected).
- `dataI::Vector{Float64}`: Real-world data to compare against the model (severely infected).

# Description:
This function sets up, solves, and visualizes the SIRS model, then overlays real-world data for comparison.

# Output:
- A plot of the SIRS model overlaid with real data points.
"""
function simulate_model_against_data_intervention(
    S0::Float64,
    I0::Float64,
    Is0::Float64,
    R0::Float64,
    beta::Float64,
    gamma::Float64,
    gamma_s::Float64,
    delta::Float64,
    ps::Float64,
    epsilon_i::Float64,
    p_i::Float64,
    tspan::Tuple{Float64,Float64},
    dataI::Vector{Float64},
    dataIs::Vector{Float64},
    intervention_day::Integer
)
    model = define_model_with_intervention(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, epsilon_i, p_i, tspan, intervention_day)
    solution = solve_model(model)
    return plot_model_against_data(solution, dataI, dataIs)
end


"""
simulate_model_with_intervention(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan)

Simulates the SIRS model with intervention, solves the system, and plots the result.

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
- `beta::Float64`: Infection rate of the disease.
- `gamma::Float64`: Recovery rate from the infectious population.
- `gamma_s::Float64`: Recovery rate from severe illness.
- `delta::Float64`: Re-susceptibility rate for the recovered population.
- `ps::Float64`: Proportion of infected individuals who develop severe illness.
- `epsilon_i::Float64`: Efficacy of the intervention in reducing the infection rate.
- `p_i::Float64`: Proportion of the population complying with the intervention.
- `tspan::Tuple{Float64, Float64}`: Time span for which the model will be solved.

# Description:
This function sets up, solves, and visualizes the SIRS model. It:
1. Defines the ODE model using `define_model`.
2. Solves the ODE model using `solve_model`.
3. Plots the results using `plot_model`, showing the dynamics of susceptible, infected, severely ill, and recovered individuals over time.

# Output:
- The resulting plot is saved as a PNG file (`output.png`), showing the evolution of the SIRS model over time.
"""
function simulate_model_with_intervention(
    S0::Float64,
    I0::Float64,
    Is0::Float64,
    R0::Float64,
    beta::Float64,
    gamma::Float64,
    gamma_s::Float64,
    delta::Float64,
    ps::Float64,
    epsilon_i::Float64,
    p_i::Float64,
    tspan::Tuple{Float64,Float64},
    intervention_day::Integer
)
    model = define_model_with_intervention(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, epsilon_i, p_i, tspan, intervention_day)
    solution = solve_model(model)
    return plot_model(solution, "Model with Intervention Simulation")
end

"""
simulate_model_against_data(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan, data)

Simulates the SIRS model and plots the result against real data.

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
- `beta::Float64`: Infection rate of the disease.
- `gamma::Float64`: Recovery rate from the infectious population.
- `gamma_s::Float64`: Recovery rate from severe illness.
- `delta::Float64`: Re-susceptibility rate for the recovered population.
- `ps::Float64`: Proportion of infected individuals who develop severe illness.
- `tspan::Tuple{Float64, Float64}`: Time span for which the model will be solved.
- `dataI::Vector{Float64}`: Real-world data to compare against the model (infected).
- `dataI::Vector{Float64}`: Real-world data to compare against the model (severely infected).

# Description:
This function sets up, solves, and visualizes the SIRS model, then overlays real-world data for comparison.

# Output:
- A plot of the SIRS model overlaid with real data points.
"""
function simulate_model_against_data(
    S0::Float64,
    I0::Float64,
    Is0::Float64,
    R0::Float64,
    beta::Float64,
    gamma::Float64,
    gamma_s::Float64,
    delta::Float64,
    ps::Float64,
    tspan::Tuple{Float64,Float64},
    dataI::Vector{Float64},
    dataIs::Vector{Float64}
)
    model = define_model(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan)
    solution = solve_model(model)
    return plot_model_against_data(solution, dataI, dataIs)
end
