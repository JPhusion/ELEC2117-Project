
"""
optimise_beta_ps(S0, I0, Is0, R0, gamma, gamma_s, delta, tspan, actual_times, actual_I, actual_Is, beta_range, ps_range)

Finds the combination of beta and ps that minimizes the total error between the simulated and actual data.

# Arguments:
- `S0`, `I0`, `Is0`, `R0`: Initial conditions for the SIRS model.
- `gamma`, `gamma_s`, `delta`: Model parameters.
- `tspan`: Time span over which to solve the model.
- `actual_times`: The time points for the actual data.
- `actual_I`, `actual_Is`: The actual observed data for the infected and severely ill populations.
- `beta_range`: Range of beta values to test.
- `ps_range`: Range of ps values to test (proportion of severe illness).

# Returns:
- `best_beta`, `best_ps`: The optimal values of beta and ps that minimize the error.
- `min_error`: The minimum error value.
"""
function optimise_beta_ps(S0, I0, Is0, R0, gamma, gamma_s, delta, tspan, actual_times, actual_I, actual_Is, beta_range, ps_range)
    best_beta = 0.0
    best_ps = 0.0
    min_error = Inf

    for ps in ps_range
        for beta in beta_range
            # Create the ODE problem with the current beta and ps values
            problem = define_model(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, tspan)

            # Solve the ODE problem
            solution = solve_model(problem)

            # Calculate the error using the calculate_error function
            error = calculate_error(solution, actual_times, actual_I, actual_Is)

            # Check if the current combination of beta and ps gives a lower error
            if error < min_error
                min_error = error
                best_beta = beta
                best_ps = ps
            end
        end
    end

    return best_beta, best_ps, min_error
end

function optimise_beta_ps(S0, I0, Is0, R0, gamma, gamma_s, delta, tspan, actual_times, actual_I, actual_Is, beta_range, ps_range, intervention_day, epsilon_i, p_i)
    best_beta = 0.0
    best_ps = 0.0
    min_error = Inf

    for ps in ps_range
        for beta in beta_range
            # Create the ODE problem with the current beta and ps values
            problem = define_model_with_intervention(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, epsilon_i, p_i, tspan, intervention_day)

            # Solve the ODE problem
            solution = solve(problem, saveat=1)

            # Calculate the error using the calculate_error function
            error = calculate_error(solution, actual_times, actual_I, actual_Is)

            # Check if the current combination of beta and ps gives a lower error
            if error < min_error
                min_error = error
                best_beta = beta
                best_ps = ps
            end
        end
    end

    return best_beta, best_ps, min_error
end

"""
optimise_beta_ps(S0, I0, Is0, R0, gamma, gamma_s, delta, tspan, actual_times, actual_I, actual_Is, beta_range, ps_range)

Finds the combination of beta and ps that minimizes the total error between the simulated and actual data.

# Arguments:
- `S0`, `I0`, `Is0`, `R0`: Initial conditions for the SIRS model.
- `gamma`, `gamma_s`, `delta`: Model parameters.
- `tspan`: Time span over which to solve the model.
- `actual_times`: The time points for the actual data.
- `actual_I`, `actual_Is`: The actual observed data for the infected and severely ill populations.
- `beta_range`: Range of beta values to test.
- `ps_range`: Range of ps values to test (proportion of severe illness).

# Returns:
- `best_beta`, `best_ps`: The optimal values of beta and ps that minimize the error.
- `min_error`: The minimum error value.
"""
function optimise_beta_pi(S0, I0, Is0, R0, gamma, gamma_s, delta, epsilon_i, ps, tspan, actual_times, actual_I, actual_Is, beta_range, pi_range, intervention_day)
    best_beta = 0.0
    best_pi = 0.0
    min_error = Inf

    for beta in beta_range
        for p_i in pi_range            # Create the ODE problem with the current beta and ps values
            prob = define_model_with_intervention(S0, I0, Is0, R0, beta, gamma, gamma_s, delta, ps, epsilon_i, p_i, tspan, intervention_day)

            # Solve the ODE problem
            solut = solve(prob, saveat=1)
            # println("")
            # println(solut)

            # Calculate the error using the calculate_error function
            error = calculate_error(solut, actual_times, actual_I, actual_Is)

            # Check if the current combination of beta and ps gives a lower error
            if error < min_error
                min_error = error
                best_beta = beta
                best_pi = p_i
            end
        end
    end

    return best_beta, best_pi, min_error
end

