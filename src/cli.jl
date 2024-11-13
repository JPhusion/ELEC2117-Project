function get_float_input(prompt::String, min_value::Union{Nothing, Float64}=nothing, max_value::Union{Nothing, Float64}=nothing)
    while true
        print(prompt)
        input = readline()
        try
            value = parse(Float64, input)
            if min_value !== nothing && value < min_value
                println("Value must be greater than or equal to $min_value.")
                continue
            end
            if max_value !== nothing && value > max_value
                println("Value must be less than or equal to $max_value.")
                continue
            end
            return value
        catch
            println("Invalid input. Please enter a number.")
        end
    end
end

function get_time_span_input()
    println("Enter the time span for the model (start and end time):")
    start_time = get_float_input("Start time: ", 0.0)
    end_time = get_float_input("End time (must be greater than start time): ")
    while end_time <= start_time
        println("End time must be greater than start time.")
        start_time = get_float_input("Start time: ")
        end_time = get_float_input("End time: ")
    end
    return (start_time, end_time)
end

function confirm_inputs(params::Dict{String,Any})
    println("\n--- Confirm Inputs ---")
    for (key, value) in params
        println("$key: $value")
    end
    while true
        print("Are these values correct? (yes/no): ")
        confirmation = lowercase(readline())
        if confirmation in ["yes", "y"]
            return true
        elseif confirmation in ["no", "n"]
            return false
        else
            println("Please enter 'yes' or 'no'.")
        end
    end
end

function cli()
    println("Welcome to the SIR Model CLI")

    # Collect user inputs
    params = Dict(
        "Initial number of susceptible individuals (S0)" => get_float_input("Enter initial susceptible population (S0 > 0): ", 0.0),
        "Initial number of infected individuals (I0)" => get_float_input("Enter initial infected population (I0 ≥ 0): ", 0.0),
        "Initial number of recovered individuals (R0)" => get_float_input("Enter initial recovered population (R0 ≥ 0): ", 0.0),
        "Infection rate (beta)" => get_float_input("Enter infection rate (beta > 0, e.g., 0.3): ", 0.0),
        "Recovery rate (gamma)" => get_float_input("Enter recovery rate (gamma > 0, e.g., 0.1): ", 0.0),
        "Contact rate (c)" => get_float_input("Enter contact rate (c > 0, e.g., 10): ", 0.0),
        "Alpha (alpha)" => get_float_input("Enter reinfection rate (0 < alpha ≤ 1, e.g., 0.5): ", 0.0, 1.0),
        "Time span (tspan)" => get_time_span_input()
    )

    # Confirm the inputs
    if !confirm_inputs(params)
        println("Exiting... Please restart and provide correct values.")
        return
    end

    # Extracting parameters to pass into the function
    S0 = params["Initial number of susceptible individuals (S0)"]
    I0 = params["Initial number of infected individuals (I0)"]
    R0 = params["Initial number of recovered individuals (R0)"]
    beta = params["Infection rate (beta)"]
    gamma = params["Recovery rate (gamma)"]
    c = params["Contact rate (c)"]
    alpha = params["Alpha (alpha)"]
    tspan = params["Time span (tspan)"]

    # Prompt the user to choose a function to run
    println("\nChoose a simulation mode:")
    println("1. Simulate SIR model")
    println("2. Simulate SIR model against data")
    print("Enter choice (1 or 2): ")
    choice = readline()

    if choice == "1"
        println("Simulating SIR model...")
        simulate_model(S0, I0, R0, beta, gamma, c, alpha, tspan)
    elseif choice == "2"
        println("Simulating SIR model against data...")
        simulate_model_against_data(S0, I0, R0, beta, gamma, c, alpha, tspan)
    else
        println("Invalid choice. Exiting...")
        return
    end

    println("Simulation completed. Check the generated plots for results.")
end
