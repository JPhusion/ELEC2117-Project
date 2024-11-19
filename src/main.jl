function main()
    
    redirect_stderr(devnull) do
        while true
            println("Select a function to run by entering the corresponding number:\n")
            
            println("===== TLT 2 =====")
            println("1. best_estimate_beta_plot()")
            
            println("\n===== TLT 3 =====")
            println("2. lower_estimate_beta_plot()")
            println("3. upper_estimate_beta_plot()")
            println("4. town1_plot_error()")
            println("5. town1_plot_optimal_beta_ps()")
            println("6. town1_plot_optimal_against_data()")
            
            println("\n===== TLT 4 =====")
            println("7. town1_intervention_plot()")
            println("8. town1_intervention_plot_error()")
            println("9. town1_intervention_plot_optimal()")
            println("10. town1_intervention_plot_optimal_against_data()")
            
            println("\n===== TLT 5 =====")
            println("11. town2_intervention_plot_optimised()")
            println("12. town2_intervention_immediately()")
            
            println("\nEnter the function number to execute (or 0 to exit): ")
            input = chomp(readline())
            choice = tryparse(Int, input)     
            println("")
            
            # Execute the selected function or exit if choice is 0
            if choice == 0
                println("Exiting program.")
                break
            elseif choice == 1
                display(best_estimate_beta_plot())
            elseif choice == 2
                display(lower_estimate_beta_plot())
            elseif choice == 3
                display(upper_estimate_beta_plot())
            elseif choice == 4
                display(town1_plot_error())
            elseif choice == 5
                display(town1_plot_optimal_beta_ps())
            elseif choice == 6
                display(town1_plot_optimal_against_data())
            elseif choice == 7
                display(town1_intervention_plot())
            elseif choice == 8
                display(town1_intervention_plot_error())
            elseif choice == 9
                display(town1_intervention_plot_optimal())
            elseif choice == 10
                display(town1_intervention_plot_optimal_against_data())
            elseif choice == 11
                display(town2_intervention_plot_optimised())
            elseif choice == 12
                display(town2_intervention_immediately())
            else
                println("Invalid choice. Please enter a number from the list.")
                continue
            end

            println("\nPress Enter to continue...")
            readline()
        end
    end
end
