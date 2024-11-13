using DifferentialEquations

"""
define_model(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan)

Creates an ODE problem for an SIRS (Susceptible-Infected-Severely Ill-Recovered) model, which describes the spread of an infectious disease in a population with a severe illness compartment and re-infection.

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
- `beta::Float64`: Infection rate of the disease.
- `gamma::Float64`: Recovery rate for the infectious population.
- `gamma_s::Float64`: Recovery rate for the severely ill population.
- `delta::Float64`: Re-susceptibility rate for the recovered population.
- `ps::Float64`: Proportion of infected individuals who develop severe illness.
- `tspan::Tuple{Float64, Float64}`: Time span for which the model will be solved.

# Returns:
- `ODEProblem`: An instance of the `ODEProblem` representing the SIRS model, which can be solved using an ODE solver.

# Model Description:
The SIRS model tracks four compartments:
- `S`: Susceptible population that can be infected.
- `I`: Infected population that can transmit the disease.
- `Is`: Severely ill population that requires hospitalization before recovering.
- `R`: Recovered population that may become susceptible again after a period of time.
The model assumes constant population size and uses the parameters `beta`, `gamma`, `gamma_s`, and `delta` to define the infection, recovery, and re-susceptibility dynamics over time.
"""
function define_model(
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

    pop = [S0, I0, Is0, R0]
    params = [beta, gamma, gamma_s, delta, ps]

    function sir_model!(dpop, pop, params, _)
        S, I, Is, R = pop
        N = S + I + Is + R
        beta, gamma, gamma_s, delta, ps = params

        dpop[1] = -beta * S * I / N + delta * R
        dpop[2] = beta * S * I / N - gamma * I
        dpop[3] = ps * gamma * I - gamma_s * Is
        dpop[4] = (1 - ps) * gamma * I + gamma_s * Is - delta * R
    end

    return ODEProblem(sir_model!, pop, tspan, params)
end


"""
define_model_with_intervention(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, epsilon_i, p_i, tspan)

Creates an ODE problem for an SIRS (Susceptible-Infected-Severely Ill-Recovered) model with a public health intervention.
This model describes the spread of an infectious disease in a population with a severe illness compartment and re-infection,
while accounting for an intervention that reduces the infection rate after day 30.

# Arguments:
- `S0::Float64`: Initial number of susceptible individuals.
- `I0::Float64`: Initial number of infected individuals.
- `Is0::Float64`: Initial number of severely ill individuals.
- `R0::Float64`: Initial number of recovered individuals.
- `beta::Float64`: Infection rate of the disease.
- `gamma::Float64`: Recovery rate for the infectious population.
- `gamma_s::Float64`: Recovery rate for the severely ill population.
- `delta::Float64`: Re-susceptibility rate for the recovered population.
- `ps::Float64`: Proportion of infected individuals who develop severe illness.
- `epsilon_i::Float64`: Efficacy of the intervention in reducing the infection rate.
- `p_i::Float64`: Proportion of the population complying with the intervention.
- `tspan::Tuple{Float64, Float64}`: Time span for which the model will be solved.
- intervention_day::Integer: The day at which intervention is introduced.

# Returns:
- `ODEProblem`: An instance of the `ODEProblem` representing the SIRS model with intervention.

# Model Description:
The SIRS model tracks four compartments:
- `S`: Susceptible population that can be infected.
- `I`: Infected population that can transmit the disease.
- `Is`: Severely ill population that requires hospitalization before recovering.
- `R`: Recovered population that may become susceptible again after a period of time.
The model assumes constant population size and uses the parameters `beta`, `gamma`, `gamma_s`, `delta`, and `ps` to define the infection, recovery, and re-susceptibility dynamics over time.

After day 30, the infection rate `beta` is adjusted based on the efficacy `epsilon_i` and the proportion of population `p_i` complying with the intervention.
"""
function define_model_with_intervention(
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

    pop = [S0, I0, Is0, R0]
    params = [beta, gamma, gamma_s, delta, ps, epsilon_i, p_i, intervention_day]

    function sir_model_with_intervention!(dpop, pop, params, t)

        S, I, Is, R = pop
        N = S + I + Is + R
        beta, gamma, gamma_s, delta, ps, epsilon_i, p_i, intervention_day = params

        # Adjust beta based on the intervention after day 30
        effective_beta = t > intervention_day ? beta * (1 - p_i * epsilon_i) : beta

        dpop[1] = -effective_beta * S * I / N + delta * R   # dS/dt
        dpop[2] = effective_beta * S * I / N - gamma * I    # dI/dt
        dpop[3] = ps * gamma * I - gamma_s * Is             # dIs/dt
        dpop[4] = (1 - ps) * gamma * I + gamma_s * Is - delta * R   # dR/dt
    end

    return ODEProblem(sir_model_with_intervention!, pop, tspan, params)
end

