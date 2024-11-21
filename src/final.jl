using DifferentialEquations

function final()
    println("Final Exam")

    # Example usage
    params = (
        β_A=0.04, β_B=0.03,
        v_A=0.02, v_B=0.04,
        α_AB=0.03, α_BA=0.03,
        m_A=0.03, m_B=0.05,
        Q_A=1, Q_B=1,
        H_A_cap=600, H_B_cap=100
    )

    initial_conditions = [
        9080, 10, 5, 4, 1, 0, 0,  # Town A: S_A, I_A, I_SA, H_A, R_A, V_A, Q_A
        4990, 3, 2, 2, 1, 0, 0    # Town B: S_B, I_B, I_SB, H_B, R_B, V_B, Q_B
    ]

    tspan = (0.0, 60.0)  # Time span

    prob = def_model(params, initial_conditions, tspan)
    sol = solve(prob)

    plot_towns(sol)
end


# Define the model
function def_model(params, initial_conditions, tspan)
    # Extract parameters
    β_A, β_B = params.β_A, params.β_B          # Transmission rates
    v_A, v_B = params.v_A, params.v_B          # Vaccination rates
    α_AB, α_BA = params.α_AB, params.α_BA      # Migration rates
    m_A, m_B = params.m_A, params.m_B          # Mortality rates
    Q_A, Q_B = params.Q_A, params.Q_B          # Quarantine flags (0 or 1)

    # Excess mortality calculation
    H_A_cap, H_B_cap = params.H_A_cap, params.H_B_cap

    # Define the ODE system
    function ode!(du, u, p, t)
        # Unpack state variables
        S_A, I_A, I_SA, H_A, R_A, V_A, Q_A, S_B, I_B, I_SB, H_B, R_B, V_B, Q_B = u

        # Town A dynamics
        du[1] = 0.01 * R_A - β_A * S_A * (I_A + I_SA) - v_A * S_A - α_AB * S_A + α_BA * S_B  # dS_A/dt
        du[2] = β_A * S_A * (I_A + I_SA) - 0.05 * I_A - 0.1 * I_A - 0.05 * I_A * Q_A - α_AB * I_A + α_BA * I_B  # dI_A/dt
        du[3] = 0.05 * I_A - 0.1 * I_SA - 0.05 * I_SA - 0.05 * I_SA * Q_A - α_AB * I_SA + α_BA * I_SB  # dI_SA/dt
        du[4] = 0.1 * I_SA - 0.04 * H_A - max(0, (H_A - H_A_cap) * m_A)  # dH_A/dt
        du[5] = 0.1 * I_A + 0.05 * I_SA + 0.04 * H_A - 0.01 * R_A - α_AB * R_A + α_BA * R_B  # dR_A/dt
        du[6] = v_A * S_A - 0.01 * V_A - α_AB * V_A + α_BA * V_B  # dV_A/dt
        du[7] = 0.05 * I_A * Q_A + 0.05 * I_SA * Q_A - α_AB * Q_A + α_BA * Q_B  # dQ_A/dt

        # Town B dynamics
        du[8] = 0.01 * R_B - β_B * S_B * (I_B + I_SB) - v_B * S_B - α_BA * S_B + α_AB * S_A  # dS_B/dt
        du[9] = β_B * S_B * (I_B + I_SB) - 0.05 * I_B - 0.1 * I_B - 0.05 * I_B * Q_B - α_BA * I_B + α_AB * I_A  # dI_B/dt
        du[10] = 0.05 * I_B - 0.1 * I_SB - 0.05 * I_SB - 0.05 * I_SB * Q_B - α_BA * I_SB + α_AB * I_SA  # dI_SB/dt
        du[11] = 0.1 * I_SB - 0.04 * H_B - max(0, (H_B - H_B_cap) * m_B)  # dH_B/dt
        du[12] = 0.1 * I_B + 0.05 * I_SB + 0.04 * H_B - 0.01 * R_B - α_BA * R_B + α_AB * R_A  # dR_B/dt
        du[13] = v_B * S_B - 0.01 * V_B - α_BA * V_B + α_AB * V_A  # dV_B/dt
        du[14] = 0.05 * I_B * Q_B + 0.05 * I_SB * Q_B - α_BA * Q_B + α_AB * Q_A  # dQ_B/dt
    end

    # Initial conditions and time span
    u0 = initial_conditions
    prob = ODEProblem(ode!, u0, tspan)
    return prob
end

function plot_towns(sol)
    # Extract time and solution
    t = sol.t
    u = sol.u

    # Extract data for Town A and Town B
    S_A = [u[i][1] for i in 1:length(u)]
    I_A = [u[i][2] for i in 1:length(u)]
    I_SA = [u[i][3] for i in 1:length(u)]
    H_A = [u[i][4] for i in 1:length(u)]
    R_A = [u[i][5] for i in 1:length(u)]
    V_A = [u[i][6] for i in 1:length(u)]
    Q_A = [u[i][7] for i in 1:length(u)]

    S_B = [u[i][8] for i in 1:length(u)]
    I_B = [u[i][9] for i in 1:length(u)]
    I_SB = [u[i][10] for i in 1:length(u)]
    H_B = [u[i][11] for i in 1:length(u)]
    R_B = [u[i][12] for i in 1:length(u)]
    V_B = [u[i][13] for i in 1:length(u)]
    Q_B = [u[i][14] for i in 1:length(u)]

    # Create the plot
    plot(
        layout=(2, 1),  # Two rows, one column layout
        size=(800, 800) # Adjust the size of the plot
    )

    # Plot for Town A (top)
    plot!(
        t, [S_A, I_A, I_SA, H_A, R_A, V_A, Q_A],
        label=["Susceptible" "Mildly Infected" "Severely Infected" "Hospitalized" "Recovered" "Vaccinated" "Quarantined"],
        xlabel="Time (days)", ylabel="Population",
        title="Epidemic Dynamics in Town A",
        subplot=1
    )

    # Plot for Town B (bottom)
    plot!(
        t, [S_B, I_B, I_SB, H_B, R_B, V_B, Q_B],
        label=["Susceptible" "Mildly Infected" "Severely Infected" "Hospitalized" "Recovered" "Vaccinated" "Quarantined"],
        xlabel="Time (days)", ylabel="Population",
        title="Epidemic Dynamics in Town B",
        subplot=2
    )

    # Display the combined plot
    display(current())
end
