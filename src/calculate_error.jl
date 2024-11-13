using Interpolations
using Statistics

"""
calculate_error(solution::ODESolution, actual_times::Vector, actual_I::Vector, actual_Is::Vector)

Calculates the total error (Mean Squared Error, MSE) between the simulated results from an ODE solution for both the infected population (I) and the severely ill population (Is) against the actual observed data.

# Arguments:
- `solution::ODESolution`: The solution object returned from solving the SIRS model.
- `actual_times::Vector`: A vector containing the time points at which the actual data was observed.
- `actual_I::Vector`: A vector of the observed data for the infected population (I) at the given time points.
- `actual_Is::Vector`: A vector of the observed data for the severely ill population (Is) at the given time points.

# Returns:
- `total_error::Float64`: The total error (sum of MSEs) between the simulated and observed data for both the infected and severely ill populations.
"""
function calculate_error(solution::ODESolution, actual_times::Vector, actual_I::Vector, actual_Is::Vector)
 # Filter data points where both actual_I and actual_Is are non-negative
    filtered_data_I = [(t, I) for (t, I) in zip(actual_times, actual_I) if I ≥ 0]
    filtered_data_Is = [(t, Is) for (t, Is) in zip(actual_times, actual_Is) if Is ≥ 0]
    
    # Separate filtered times and actual data into separate vectors
    filtered_times_I = [data[1] for data in filtered_data_I]
    filtered_times_Is = [data[1] for data in filtered_data_Is]
    filtered_actual_I = [data[2] for data in filtered_data_I]
    filtered_actual_Is = [data[2] for data in filtered_data_Is]
    
    # Extract simulated results at the filtered time points
    simulated_I = [solution(t)[2] for t in filtered_times_I]
    simulated_Is = [solution(t)[3] for t in filtered_times_Is]
    
    # Calculate Mean Squared Error (MSE) for each population
    mse_I = mean((simulated_I .- filtered_actual_I).^2)
    mse_Is = mean((simulated_Is .- filtered_actual_Is).^2)
    
    # Total error is the sum of both MSE
    total_error = mse_I * 1 + mse_Is * 1
    return total_error
end
