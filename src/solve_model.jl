
"""
solve_model(problem)

Solves an ODE problem and returns the solution.

# Arguments:
- `problem::ODEProblem`: An instance of an `ODEProblem`, typically created using a function like `define_model`, which describes a system of differential equations.

# Returns:
- `ODESolution`: The solution to the ODE problem, which contains the time points and the values of the system's variables at those points.

# Description:
This function takes an ODE problem as input and solves it using Julia's ODE solvers. The solution contains detailed information about the system's state over time, which can be used for further analysis or visualization.
"""
function solve_model(problem::ODEProblem)
    return solve(problem, saveat=1)
end
