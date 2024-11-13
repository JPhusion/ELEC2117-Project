using DifferentialEquations
using Plots

using SIRModel
using Test

# Define test parameters
S0 = 0.99
I0 = 0.01
R0 = 0.0
beta = 0.5
gamma = 0.5
c = 10.0
alpha = 0.0
tspan = (0.0, 100.0)

@testset "SIRModel" begin

    @testset "Define Model" begin
        model = define_model(S0, I0, R0, beta, gamma, c, alpha, tspan)
        @test model isa ODEProblem
    end

    @testset "Solve Model" begin
        model = define_model(S0, I0, R0, beta, gamma, c, alpha, tspan)
        solution = solve_model(model)
        @test solution isa ODESolution
        @test length(solution.t) > 0      # Ensure soltuon has time points
        @test length(solution.u[1]) == 3  # Check solution has S, I and R
    end

    @testset "Plot Solution" begin
        model = define_model(S0, I0, R0, beta, gamma, c, alpha, tspan)
        solution = solve_model(model)
        plt = plot_model(solution)
        @test plt isa Plots.Plot          # Ensure valid plot is generated
    end

    @testset "Simulate Model" begin
        simulate_model(S0, I0, R0, beta, gamma, c, alpha, tspan)
        @test isfile("output.png") == true
    end

end
