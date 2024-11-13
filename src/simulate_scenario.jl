function simulate_scenario()
    redirect_stderr(devnull) do

        dataI = Float64.(vcat(repeat([-1], 14), [11, 7, 20, 3, 29, 14, 11, 12, 16, 10, 58]))
        dataIs = Float64.(vcat(repeat([-1], 20), [0, 0, 1, 2, 5]))
        dataI_intervention = Float64.(vcat(repeat([-1], 14), [
            11, 7, 20, 3, 29, 14, 11, 12, 16, 10, 58, 34, 26, 29, 51, 55, 155, 53, 67, 98,
            130, 189, 92, 192, 145, 128, 68, 74, 126, 265, 154, 207, 299, 273, 190, 152,
            276, 408, 267, 462, 352, 385, 221, 420, 544, 329, 440, 427, 369, 606, 416, 546,
            475, 617, 593, 352, 337, 473, 673, 653, 523, 602, 551, 686, 556, 600
        ]))
        dataIs_intervention = Float64.(vcat(repeat([-1], 20), [
            0, 0, 1, 2, 5, 5, 5, 2, 9, 4, 22, 0, 15, 48, 38, 57, 9, 18, 20, 0,
            41, 15, 35, 36, 27, 38, 24, 40, 34, 57, 18, 29, 63, 66, 119, 76,
            95, 28, 109, 136, 119, 104, 121, 93, 147, 129, 130, 161, 133, 136,
            138, 139, 181, 181, 218, 183, 167, 164, 219, 220
        ]))
        dataI_town2 = Float64.(vcat(repeat([-1], 26), [21, 29, 25, 30, 28, 34, 28, 54, 57, 92, 73, 80, 109, 102, 128, 135, 163, 150, 211, 196, 233, 247, 283, 286, 332, 371, 390, 404, 467, 529, 598, 641, 704, 702, 788, 856, 854, 955, 995, 1065, 1106, 1159, 1217, 1269, 1298, 1328, 1339, 1383, 1431, 1422, 1414, 1485, 1464, 1480]))
        dataIs_town2 = Float64.(vcat(repeat([-1], 26), [3, 3, 4, 7, 3, 8, 7, 5, 9, 13, 15, 3, 20, 13, 11, 20, 16, 11, 15, 18, 27, 24, 28, 36, 41, 35, 41, 55, 63, 66, 72, 80, 90, 104, 109, 115, 127, 135, 147, 162, 163, 186, 194, 200, 216, 223, 241, 249, 258, 275, 277, 299, 302, 300]))
        S0 = 5999.0
        I0 = 1.0
        Is0 = 0.0
        R0 = 0.0
        beta = 0.0348
        c = 8.0
        gamma = 1 / 7
        gamma_s = 1 / 14
        delta = 1 / 30
        ps = 0.1
        tspan = (0.0, 30.0)

        intervention_day = 30
        intervention_day_town2 = 36
        tspan_intervention = (0.0, 100.0)
        beta_range = 0.02:0.00005:0.045*c
        beta_range = 0.03:0.00005:0.04*c
        beta_range = 0.0365 * c
        actual_times = collect(1:length(dataI))
        actual_times_intervention = collect(1:length(dataI_intervention))
        ps_range = 0.15:0.01:0.25
        epsilon_i = 0.3
        p_i = 0.82
        pi_range = 0.0:0.01:1.0

        best_beta, best_ps, min_error = optimise_beta_ps(
            S0, I0, Is0, R0, gamma, gamma_s, delta, tspan, actual_times, dataI, dataIs, beta_range, ps_range
        )

        # plt3, best_beta, min_error = plot_error(
        #     S0,
        #     I0,
        #     Is0,
        #     R0,
        #     c,
        #     gamma,
        #     gamma_s,
        #     delta,
        #     best_ps,
        #     tspan,
        #     actual_times,
        #     dataI,
        #     dataIs,
        #     beta_range
        # )

        plt1 = simulate_model_against_data(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            # best_beta * c,
            best_beta,
            gamma,
            gamma_s,
            delta,
            best_ps,
            tspan,
            dataI,
            dataIs
        )

        plt2 = simulate_model(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            best_beta * c,
            gamma,
            gamma_s,
            delta,
            best_ps,
            tspan .* 10
        )

        plt4 = simulate_model_with_intervention(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            best_beta * c,
            gamma,
            gamma_s,
            delta,
            best_ps,
            epsilon_i,
            p_i,
            tspan .* 10,
            intervention_day
        )

        println("=== Without Intervention ===")
        println("Best Beta: ", best_beta / c)
        println("Best Ps: ", best_ps)
        println("Minimum Error: ", min_error)

        # combined_plot = plot(plt1, plt2, plt3, plt4, layout=(2, 2), legend=true, legendfontsize=4)

        best_beta_i, best_pi, min_error = optimise_beta_pi(
            S0,
            I0,
            Is0,
            R0,
            gamma,
            gamma_s,
            delta,
            epsilon_i,
            ps,
            tspan_intervention,
            actual_times_intervention,
            dataI_intervention,
            dataIs_intervention,
            beta_range,
            pi_range,
            intervention_day
        )

        # plt8, best_beta_i, min_error = plot_error_intervention(
        #     S0,
        #     I0,
        #     Is0,
        #     R0,
        #     c,
        #     gamma,
        #     gamma_s,
        #     delta,
        #     best_ps,
        #     epsilon_i,
        #     best_pi,
        #     tspan,
        #     actual_times_intervention,
        #     dataI_intervention,
        #     dataIs_intervention,
        #     beta_range,
        #     intervention_day
        # )
        #
        # best_beta, best_ps, min_error = [0.03475, 0.15, 0]

        plt5 = simulate_model_against_data_intervention(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            best_beta_i,
            # 0.0365 * c,
            gamma,
            gamma_s,
            delta,
            best_ps,
            epsilon_i,
            best_pi,
            tspan_intervention,
            dataI_intervention,
            dataIs_intervention,
            intervention_day
        )

        plt6 = simulate_model(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            best_beta * c,
            gamma,
            gamma_s,
            delta,
            best_ps,
            tspan .* 10
        )

        plt7 = simulate_model_with_intervention(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            best_beta_i,
            gamma,
            gamma_s,
            delta,
            best_ps,
            epsilon_i,
            best_pi,
            tspan .* 10,
            intervention_day
        )

        println("=== With Intervention ===")
        println("Best Beta: ", best_beta_i / c)
        println("Best Pi: ", best_pi)
        println("Minimum Error: ", min_error)

        # combined_plot_intervention = plot(plt5, plt6, plt7, plt8, layout=(2, 2), legend=true, legendfontsize=8)


        # plt9 = simulate_model_against_data_intervention(
        #     S0,
        #     I0,
        #     Is0,
        #     R0,
        #     # beta * c,
        #     best_beta * c,
        #     gamma,
        #     gamma_s,
        #     delta,
        #     best_ps,
        #     epsilon_i,
        #     p_i,
        #     tspan_intervention,
        #     dataI_town2,
        #     dataIs_town2,
        #     intervention_day_town2
        # )
        #
        # display(plt9)

        # Town 2
        S0 = 9999.0
        I0 = 1.0
        Is0 = 0.0
        R0 = 0.0
        beta = 0.0348
        c = 8.0
        gamma = 1 / 7
        gamma_s = 1 / 14
        delta = 1 / 30
        ps = 0.1
        tspan = (0.0, 30.0)

        
        p_i = 0.82 
        min_error = Inf
        best_beta_i = 0
        best_ps = 0
        best_intervention_day = 0
        first_case = 0
        town2_data_I = []
        town2_data_Is = []
        for intervention_day in 23:1:32
            start_day = 28 - (intervention_day - 10)
            println(start_day)
            town2_I = Float64.(vcat(repeat([-1], 27 - start_day), [21, 29, 25, 30, 28, 34, 28, 54, 57, 92, 73, 80, 109, 102, 128, 135, 163, 150, 211, 196, 233, 247, 283, 286, 332, 371, 390, 404, 467, 529, 598, 641, 704, 702, 788, 856, 854, 955, 995, 1065, 1106, 1159, 1217, 1269, 1298, 1328, 1339, 1383, 1431, 1422, 1414, 1485, 1464, 1480]))
            town2_Is = Float64.(vcat(repeat([-1],  27 - start_day), [3, 3, 4, 7, 3, 8, 7, 5, 9, 13, 15, 3, 20, 13, 11, 20, 16, 11, 15, 18, 27, 24, 28, 36, 41, 35, 41, 55, 63, 66, 72, 80, 90, 104, 109, 115, 127, 135, 147, 162, 163, 186, 194, 200, 216, 223, 241, 249, 258, 275, 277, 299, 302, 300]))
            tspan_intervention = (0.0, 100.0)
            beta_range = 0.03:0.001:0.05 * c
            actual_times = collect(1:length(town2_I))
            ps_range = 0.0:0.01:0.2
            epsilon_i = 0.3

            beta, p_s, error = optimise_beta_ps(
                S0,
                I0,
                Is0,
                R0,
                gamma,
                gamma_s,
                delta,
                tspan_intervention,
                actual_times,
                town2_I,
                town2_Is,
                beta_range,
                ps_range,
                intervention_day,
                epsilon_i,
                p_i
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

        plt9 = simulate_model_against_data_intervention(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            best_beta_i,
            # 0.0365 * c,
            gamma,
            gamma_s,
            delta,
            best_ps,
            epsilon_i,
            best_pi,
            tspan_intervention,
            town2_data_I,
            town2_data_Is,
            best_intervention_day 
        )

        plt10 = simulate_model_with_intervention(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            best_beta_i,
            gamma,
            gamma_s,
            delta,
            best_ps,
            epsilon_i,
            best_pi,
            tspan_intervention .* 5,
            0
        )
        plt11 = simulate_model_with_intervention(
            S0,
            I0,
            Is0,
            R0,
            # beta * c,
            best_beta_i,
            gamma,
            gamma_s,
            delta,
            best_ps,
            epsilon_i,
            best_pi,
            tspan_intervention .* 5,
            best_intervention_day
        )

        display(plt3)

        println("=== Town 2 ===")
        println("Best Beta: ", best_beta_i / c)
        println("Best Ps: ", best_ps)
        println("First case day: ", first_case)
        println("Best intervention day: ", best_intervention_day)
        println("Minimum Error: ", min_error)

    end
end
