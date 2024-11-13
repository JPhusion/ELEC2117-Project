################################################################################
################################### GET DATA ###################################
################################################################################
function get_town1_data()
    dataI = Float64.(vcat(
        repeat([-1], 14),
        [11, 7, 20, 3, 29, 14, 11, 12, 16, 10, 58]
    ))

    dataIs = Float64.(vcat(
        repeat([-1], 20),
        [0, 0, 1, 2, 5]
    ))

    return dataI, dataIs
end

function get_town1_data_intervention()
    dataI = Float64.(vcat(
        repeat([-1], 14),
        [
            11, 7, 20, 3, 29, 14, 11, 12, 16, 10, 58, 34, 26, 29, 51, 55, 155, 53, 67, 98,
            130, 189, 92, 192, 145, 128, 68, 74, 126, 265, 154, 207, 299, 273, 190, 152,
            276, 408, 267, 462, 352, 385, 221, 420, 544, 329, 440, 427, 369, 606, 416, 546,
            475, 617, 593, 352, 337, 473, 673, 653, 523, 602, 551, 686, 556, 600
        ]
    ))

    dataIs = Float64.(vcat(
        repeat([-1], 20),
        [
            0, 0, 1, 2, 5, 5, 5, 2, 9, 4, 22, 0, 15, 48, 38, 57, 9, 18, 20, 0,
            41, 15, 35, 36, 27, 38, 24, 40, 34, 57, 18, 29, 63, 66, 119, 76,
            95, 28, 109, 136, 119, 104, 121, 93, 147, 129, 130, 161, 133, 136,
            138, 139, 181, 181, 218, 183, 167, 164, 219, 220
        ]
    ))

    return dataI, dataIs
end

function get_town2_data()
    # TODO
end

################################################################################
#################################### TLT 2 #####################################
################################################################################
function best_estimate_beta_plot()
    println("===== Plotting Town 1 With beta = 0.35 ======\n")
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    beta, c, gamma, gamma_s, delta, ps = 0.0348, 8.0, 1 / 7, 1 / 14, 1 / 30, 0.1
    tspan = (0.0, 30.0)
    dataI, dataIs = get_town1_data()
    return simulate_model_against_data(S0, I0, Is0, R0, beta * c, gamma, gamma_s, delta, ps, tspan, dataI, dataIs)
end

################################################################################
#################################### TLT 3 #####################################
################################################################################
function lower_estimate_beta_plot()
    println("===== Plotting Town 1 With beta = 0.2 ======")
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    beta, c, gamma, gamma_s, delta, ps = 0.02, 8.0, 1 / 7, 1 / 14, 1 / 30, 0.1
    tspan = (0.0, 30.0)
    dataI, dataIs = get_town1_data()
    println("")
    return simulate_model_against_data(S0, I0, Is0, R0, beta * c, gamma, gamma_s, delta, ps, tspan, dataI, dataIs)
end

function upper_estimate_beta_plot()
    println("===== Plotting Town 1 With beta = 0.45 ======")
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    beta, c, gamma, gamma_s, delta, ps = 0.045, 8.0, 1 / 7, 1 / 14, 1 / 30, 0.1
    tspan = (0.0, 30.0)
    dataI, dataIs = get_town1_data()
    println("")
    return simulate_model_against_data(S0, I0, Is0, R0, beta * c, gamma, gamma_s, delta, ps, tspan, dataI, dataIs)
end

function town1_plot_error()
    println("===== Plotting Town 1 Error ======")
    dataI, dataIs = get_town1_data()
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    c, gamma, gamma_s, delta = 8.0, 1 / 7, 1 / 14, 1 / 30
    tspan = (0.0, 30.0)
    beta_range = 0.02:0.001:0.04*c
    actual_times = collect(1:length(dataI))
    ps_range = 0.15:0.01:0.25

    best_beta, best_ps, min_error = optimise_beta_ps(
        S0, I0, Is0, R0, gamma, gamma_s, delta, tspan, actual_times, dataI, dataIs, beta_range, ps_range
    )

    plt, best_beta, min_error = plot_error(
        S0, I0, Is0, R0, c, gamma, gamma_s, delta, best_ps, tspan, actual_times, dataI, dataIs, beta_range
    )

    println("===== RESULTS =====")
    println("Optimal beta: ", best_beta)
    println("Optimal ps:   ", best_ps)
    println("")
    return plt
end

function town1_plot_optimal_beta_ps()
    println("===== Plotting Town 1 Simulation with Optimised Beta and Ps =====")
    dataI, dataIs = get_town1_data()
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    c, gamma, gamma_s, delta = 8.0, 1 / 7, 1 / 14, 1 / 30
    tspan = (0.0, 300.0)
    beta_range = 0.02:0.001:0.04*c
    actual_times = collect(1:length(dataI))
    ps_range = 0.15:0.01:0.25

    best_beta, best_ps, min_error = optimise_beta_ps(
        S0, I0, Is0, R0, gamma, gamma_s, delta, tspan, actual_times, dataI, dataIs, beta_range, ps_range
    )

    plt = simulate_model(S0, I0, Is0, R0, best_beta, gamma, gamma_s, delta, best_ps, tspan)

    println("===== RESULTS =====")
    println("Optimal beta: ", best_beta / c)
    println("Optimal ps:   ", best_ps)
    println("")
    return plt
end

function town1_plot_optimal_against_data()
    println("===== Plotting Town 1 Optimised Against Data =====")
    dataI, dataIs = get_town1_data()
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    c, gamma, gamma_s, delta = 8.0, 1 / 7, 1 / 14, 1 / 30
    tspan = (0.0, 30.0)
    beta_range = 0.02:0.001:0.04*c
    actual_times = collect(1:length(dataI))
    ps_range = 0.15:0.01:0.25

    best_beta, best_ps, min_error = optimise_beta_ps(
        S0, I0, Is0, R0, gamma, gamma_s, delta, tspan, actual_times, dataI, dataIs, beta_range, ps_range
    )

    plt = simulate_model_against_data(
        S0, I0, Is0, R0, best_beta, gamma, gamma_s, delta, best_ps, tspan, dataI, dataIs
    )

    println("===== RESULTS =====")
    println("Optimal beta: ", best_beta / c)
    println("Optimal ps:   ", best_ps)
    println("")
    return plt
end

################################################################################
#################################### TLT 4 #####################################
################################################################################
function town1_intervention_plot()
    println("===== Plotting Town 1 with Intervention (Not Optimised) =====")
    dataI, dataIs = get_town1_data_intervention()
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    c, gamma, gamma_s, delta = 8.0, 1 / 7, 1 / 14, 1 / 30
    tspan = (0.0, 30.0)
    beta_range = 0.02:0.001:0.04*c
    actual_times = collect(1:length(dataI))
    ps_range = 0.15:0.01:0.25
    epsilon_i, p_i, intervention_day = 0.3, 0.82, 30

    best_beta, best_ps, _ = optimise_beta_ps(
        S0, I0, Is0, R0, gamma, gamma_s, delta, tspan, actual_times, dataI, dataIs, beta_range, ps_range
    )

    plt = simulate_model_with_intervention(
        S0, I0, Is0, R0, best_beta, gamma, gamma_s, delta, best_ps, epsilon_i, p_i, tspan .* 10, intervention_day
    )

    println("===== RESULTS =====")
    println("Optimal beta: ", best_beta / c)
    println("Optimal ps:   ", best_ps)
    println("")
    return plt
end

function town1_intervention_plot_error()
    println("===== Plotting Town 1 with Intervention Error =====")
    dataI, dataIs = get_town1_data_intervention()
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    c, gamma, gamma_s, delta = 8.0, 1 / 7, 1 / 14, 1 / 30
    tspan = (0.0, 30.0)
    beta_range, pi_range = 0.03:0.001:0.04*c, 0.0:0.01:1.0
    actual_times_intervention = collect(1:length(dataI))
    ps, epsilon_i = 0.15, 0.3
    tspan_intervention, intervention_day = (0.0, 100.0), 30

    best_beta_i, best_pi, min_error = optimise_beta_pi(
        S0, I0, Is0, R0, gamma, gamma_s, delta, epsilon_i, ps, tspan_intervention,
        actual_times_intervention, dataI, dataIs, beta_range, pi_range, intervention_day
    )

    plt, best_beta_i, min_error = plot_error_intervention(
        S0, I0, Is0, R0, c, gamma, gamma_s, delta, ps, epsilon_i, best_pi, tspan,
        actual_times_intervention, dataI, dataIs, beta_range, intervention_day
    )

    println("===== RESULTS =====")
    println("Optimal beta: ", best_beta_i / c)
    println("Optimal Pi:   ", best_pi)
    println("Used ps:      ", ps)
    println("")
    return plt
end

function town1_intervention_plot_optimal()
    println("===== Plotting Town 1 Intervention Optimised =====")
    dataI, dataIs = get_town1_data_intervention()
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    c, gamma, gamma_s, delta = 8.0, 1 / 7, 1 / 14, 1 / 30
    tspan = (0.0, 300.0)
    beta_range, pi_range = 0.03:0.001:0.04 * c, 0.0:0.01:1.0
    actual_times_intervention = collect(1:length(dataI))
    ps, epsilon_i = 0.15, 0.3
    tspan_intervention, intervention_day = (0.0, 100.0), 30

    best_beta_i, best_pi, min_error = optimise_beta_pi(
        S0, I0, Is0, R0, gamma, gamma_s, delta, epsilon_i, ps, tspan_intervention,
        actual_times_intervention, dataI, dataIs, beta_range, pi_range, intervention_day
    )

    plt = simulate_model_with_intervention(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            best_beta_i,
            gamma,
            gamma_s,
            delta,
            ps,
            epsilon_i,
            best_pi,
            tspan,
            intervention_day
        )

    println("===== RESULTS =====")
    println("Optimal beta: ", best_beta_i / c)
    println("Optimal Pi:   ", best_pi)
    println("Used ps:      ", ps)
    println("")
    return plt
end
function town1_intervention_plot_optimal_against_data()
    println("===== Plotting Town 1 Intervention Optimised Against Data =====")
    dataI, dataIs = get_town1_data_intervention()
    S0, I0, Is0, R0 = 5999.0, 1.0, 0.0, 0.0
    c, gamma, gamma_s, delta = 8.0, 1 / 7, 1 / 14, 1 / 30
    tspan = (0.0, 30.0)
    beta_range, pi_range = 0.03:0.001:0.04 * c, 0.0:0.01:1.0
    actual_times_intervention = collect(1:length(dataI))
    ps, epsilon_i = 0.15, 0.3
    tspan_intervention, intervention_day = (0.0, 100.0), 30

    best_beta_i, best_pi, min_error = optimise_beta_pi(
        S0, I0, Is0, R0, gamma, gamma_s, delta, epsilon_i, ps, tspan_intervention,
        actual_times_intervention, dataI, dataIs, beta_range, pi_range, intervention_day
    )

    plt = simulate_model_against_data_intervention(
        S0, I0, Is0, R0, best_beta_i, gamma, gamma_s, delta, ps,
        epsilon_i, best_pi, tspan_intervention, dataI, dataIs, intervention_day
    )

    println("===== RESULTS =====")
    println("Optimal beta: ", best_beta_i / c)
    println("Optimal Pi:   ", best_pi)
    println("Used ps:      ", ps)
    println("")
    return plt
end

################################################################################
#################################### TLT 5 #####################################
################################################################################
function town2_intervention_plot_optimised()
    println("===== Plotting Town 2 with Optimised Intervention Against Data =====")
    S0, I0, Is0, R0 = 9999.0, 1.0, 0.0, 0.0
    beta, c, gamma, gamma_s, delta, ps = 0.0348, 8.0, 1 / 7, 1 / 14, 1 / 30, 0.1
    tspan, tspan_intervention = (0.0, 30.0), (0.0, 100.0)
    p_i, epsilon_i = 0.82, 0.3
    min_error, best_beta_i, best_ps, best_intervention_day, first_case = Inf, 0, 0, 0, 0
    town2_data_I, town2_data_Is = [], []
    beta_range, ps_range = 0.03:0.001:0.05 * c, 0.0:0.01:0.2

    for intervention_day in 23:1:32
        start_day = 28 - (intervention_day - 10)
        town2_I = Float64.(vcat(repeat([-1], 27 - start_day), [
            21, 29, 25, 30, 28, 34, 28, 54, 57, 92, 73, 80, 109, 102, 128, 135, 163, 150,
            211, 196, 233, 247, 283, 286, 332, 371, 390, 404, 467, 529, 598, 641, 704,
            702, 788, 856, 854, 955, 995, 1065, 1106, 1159, 1217, 1269, 1298, 1328, 1339,
            1383, 1431, 1422, 1414, 1485, 1464, 1480
        ]))
        town2_Is = Float64.(vcat(repeat([-1], 27 - start_day), [
            3, 3, 4, 7, 3, 8, 7, 5, 9, 13, 15, 3, 20, 13, 11, 20, 16, 11, 15, 18, 27, 24,
            28, 36, 41, 35, 41, 55, 63, 66, 72, 80, 90, 104, 109, 115, 127, 135, 147, 162,
            163, 186, 194, 200, 216, 223, 241, 249, 258, 275, 277, 299, 302, 300
        ]))
        actual_times = collect(1:length(town2_I))

        beta, p_s, error = optimise_beta_ps(
            S0, I0, Is0, R0, gamma, gamma_s, delta, tspan_intervention, actual_times,
            town2_I, town2_Is, beta_range, ps_range, intervention_day, epsilon_i, p_i
        )

        if error < min_error
            min_error = error
            best_beta_i = beta
            best_ps = p_s
            best_intervention_day = intervention_day
            first_case = start_day
            town2_data_I = town2_I
            town2_data_Is = town2_Is
        end
    end

    plt = simulate_model_against_data_intervention(
        S0, I0, Is0, R0, best_beta_i, gamma, gamma_s, delta, best_ps, epsilon_i, p_i,
        tspan_intervention, town2_data_I, town2_data_Is, best_intervention_day
    )

    println("===== RESULTS =====")
    println("Optimal beta: ", best_beta_i / c)
    println("Optimal ps:   ", best_ps)
    println("Intervention day: ", best_intervention_day)
    println("First case day:   ", first_case)
    println("")
    
    return plt
end

function town2_intervention_immediately()
    println("===== Plotting Town 2 with Immediate Intervention =====")
    S0, I0, Is0, R0 = 9999.0, 1.0, 0.0, 0.0
    beta, c, gamma, gamma_s, delta, ps = 0.0348, 8.0, 1 / 7, 1 / 14, 1 / 30, 0.1
    tspan, tspan_intervention = (0.0, 30.0), (0.0, 500.0)
    p_i, epsilon_i = 0.82, 0.3
    min_error, best_beta_i, best_ps, best_intervention_day, first_case = Inf, 0, 0, 0, 0
    town2_data_I, town2_data_Is = [], []
    beta_range, ps_range = 0.03:0.001:0.05 * c, 0.0:0.01:0.2

    for intervention_day in 23:1:32
        start_day = 28 - (intervention_day - 10)
        town2_I = Float64.(vcat(repeat([-1], 27 - start_day), [
            21, 29, 25, 30, 28, 34, 28, 54, 57, 92, 73, 80, 109, 102, 128, 135, 163, 150,
            211, 196, 233, 247, 283, 286, 332, 371, 390, 404, 467, 529, 598, 641, 704,
            702, 788, 856, 854, 955, 995, 1065, 1106, 1159, 1217, 1269, 1298, 1328, 1339,
            1383, 1431, 1422, 1414, 1485, 1464, 1480
        ]))
        town2_Is = Float64.(vcat(repeat([-1], 27 - start_day), [
            3, 3, 4, 7, 3, 8, 7, 5, 9, 13, 15, 3, 20, 13, 11, 20, 16, 11, 15, 18, 27, 24,
            28, 36, 41, 35, 41, 55, 63, 66, 72, 80, 90, 104, 109, 115, 127, 135, 147, 162,
            163, 186, 194, 200, 216, 223, 241, 249, 258, 275, 277, 299, 302, 300
        ]))
        actual_times = collect(1:length(town2_I))

        beta, p_s, error = optimise_beta_ps(
            S0, I0, Is0, R0, gamma, gamma_s, delta, tspan_intervention, actual_times,
            town2_I, town2_Is, beta_range, ps_range, intervention_day, epsilon_i, p_i
        )

        if error < min_error
            min_error = error
            best_beta_i = beta
            best_ps = p_s
            best_intervention_day = intervention_day
            first_case = start_day
            town2_data_I = town2_I
            town2_data_Is = town2_Is
        end
    end

    plt = simulate_model_with_intervention(
        S0, I0, Is0, R0, best_beta_i, gamma, gamma_s, delta, best_ps, epsilon_i, p_i,
        tspan_intervention, 0
    )

    println("===== RESULTS =====")
    println("Optimal beta: ", best_beta_i / c)
    println("Optimal ps:   ", best_ps)
    println("Intervention day: ", 0)
    println("First case day:   ", first_case)
    println("")
    
    return plt
end
