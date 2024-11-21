using DifferentialEquations
using Plots

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
        9080, 10, 5, 4, 1, 0, 0, 0,  # Town A: S_A, I_A, I_SA, H_A, R_A, V_A, Q_A, Q_A_release
        4990, 3, 2, 2, 1, 0, 0, 0,   # Town B: S_B, I_B, I_SB, H_B, R_B, V_B, Q_B, Q_B_release
        0.0, 0.0                     # Timers: timer_A, timer_B
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
    H_A_cap, H_B_cap = params.H_A_cap, params.H_B_cap  # Hospital capacity

    # Define the ODE system
    function ode!(du, u, p, t)
        # Unpack state variables
        S_A, I_A, I_SA, H_A, R_A, V_A, Q_A_state, Q_A_release, S_B, I_B, I_SB, H_B, R_B, V_B, Q_B_state, Q_B_release, timer_A, timer_B = u

        # Define thresholds
        quarantine_threshold_A = 100  # Trigger threshold for Town A
        quarantine_threshold_B = 50   # Trigger threshold for Town B
        quarantine_duration = 14.0    # Quarantine duration in days
        release_delay_A = 7.0         # Post-quarantine delay for Town A
        release_delay_B = 5.0         # Post-quarantine delay for Town B

        # Contact rates
        contact_rate_A = 0.04  # Contacts per person per day in Town A
        contact_rate_B = 0.03  # Contacts per person per day in Town B
        quarantine_reduction_A = 0.5  # 50% reduction in Town A during quarantine
        quarantine_reduction_B = 0.4  # 40% reduction in Town B during quarantine

        # Update quarantine flags
        if timer_A <= 0 && (I_A + I_SA > quarantine_threshold_A)
            timer_A = quarantine_duration  # Activate quarantine for 14 days
        elseif timer_A > 0
            timer_A -= 1.0  # Countdown timer
        end

        Q_A = (timer_A > 0 ? 1.0 : 0.0)  # Quarantine is active if timer is positive

        if timer_B <= 0 && (I_B + I_SB > quarantine_threshold_B)
            timer_B = quarantine_duration  # Activate quarantine for 14 days
        elseif timer_B > 0
            timer_B -= 1.0  # Countdown timer
        end

        Q_B = (timer_B > 0 ? 1.0 : 0.0)  # Quarantine is active if timer is positive

        # Adjusted transmission rates with contact rates
        β_A_eff = contact_rate_A * β_A * (1 - quarantine_reduction_A * Q_A)
        β_B_eff = contact_rate_B * β_B * (1 - quarantine_reduction_B * Q_B)

        # Town A dynamics
        du[1] = 0.01 * R_A - β_A_eff * S_A * (I_A + I_SA) - v_A * S_A - α_AB * S_A + α_BA * S_B  # dS_A/dt
        du[2] = β_A_eff * S_A * (I_A + I_SA) - 0.05 * I_A - 0.1 * I_A - 0.05 * I_A * Q_A - α_AB * I_A + α_BA * I_B  # dI_A/dt
        du[3] = 0.05 * I_A - 0.1 * I_SA - 0.05 * I_SA - 0.05 * I_SA * Q_A - α_AB * I_SA + α_BA * I_SB  # dI_SA/dt
        du[4] = 0.1 * I_SA - 0.04 * H_A - max(0, (H_A - H_A_cap) * m_A)  # dH_A/dt
        du[5] = 0.1 * I_A + 0.05 * I_SA + 0.04 * H_A - 0.01 * R_A - α_AB * R_A + α_BA * R_B + Q_A_release / release_delay_A  # dR_A/dt
        du[6] = v_A * S_A - 0.01 * V_A - α_AB * V_A + α_BA * V_B  # dV_A/dt
        du[7] = 0.05 * I_A * Q_A + 0.05 * I_SA * Q_A - Q_A_state / quarantine_duration - α_AB * Q_A_state + α_BA * Q_B_state  # dQ_A/dt
        du[8] = Q_A_state / quarantine_duration - Q_A_release / release_delay_A  # dQ_A_release/dt

        # Town B dynamics
        du[9] = 0.01 * R_B - β_B_eff * S_B * (I_B + I_SB) - v_B * S_B - α_BA * S_B + α_AB * S_A  # dS_B/dt
        du[10] = β_B_eff * S_B * (I_B + I_SB) - 0.05 * I_B - 0.1 * I_B - 0.05 * I_B * Q_B - α_BA * I_B + α_AB * I_A  # dI_B/dt
        du[11] = 0.05 * I_B - 0.1 * I_SB - 0.05 * I_SB - 0.05 * I_SB * Q_B - α_BA * I_SB + α_AB * I_SA  # dI_SB/dt
        du[12] = 0.1 * I_SB - 0.04 * H_B - max(0, (H_B - H_B_cap) * m_B)  # dH_B/dt
        du[13] = 0.1 * I_B + 0.05 * I_SB + 0.04 * H_B - 0.01 * R_B - α_BA * R_B + α_AB * R_A + Q_B_release / release_delay_B  # dR_B/dt
        du[14] = v_B * S_B - 0.01 * V_B - α_BA * V_B + α_AB * V_A  # dV_B/dt
        du[15] = 0.05 * I_B * Q_B + 0.05 * I_SB * Q_B - Q_B_state / quarantine_duration - α_BA * Q_B_state + α_AB * Q_A_state  # dQ_B/dt
        du[16] = Q_B_state / quarantine_duration - Q_B_release / release_delay_B  # dQ_B_release/dt

        # Update timers
        du[17] = timer_A  # Timer for Town A
        du[18] = timer_B  # Timer for Town B
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
