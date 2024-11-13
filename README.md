# ELEC2117 Project

This repository contains a Julia program that provides an interactive menu for running various analytical and plotting functions. Each function is executed based on the user’s input and displayed on the console.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Usage](#usage)
- [Functions](#functions)
- [License](#license)

## Overview

The program features an interactive command-line interface that allows users to select and execute a variety of functions related to `TLT` analyses and plots. Each function produces plots or calculations based on the selected input and displays the results.

## Features

- Interactive CLI for selecting and running analysis functions.
- Organized function menu across various `TLT` categories.
- Automatic display of output results for each selected function.

## Requirements

- Julia 1.x or newer
- Any additional Julia packages required by the individual functions (e.g., `Plots.jl` for plotting). Install any packages by running:
  ```julia
  using Pkg
  Pkg.add("PackageName")
  ```

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/username/repo_name.git
   cd repo_name
   ```

2. Run the main program:
   ```julia
   julia main.jl
   ```

3. Follow the prompts in the console to select a function to run by entering the corresponding number.

## Functions

Each function in this program performs a specific calculation or produces a plot based on data. Below is a description of each available function:

### TLT 2
1. **best_estimate_beta_plot()** - Plots the best estimate of beta values.

### TLT 3
2. **lower_estimate_beta_plot()** - Plots the lower estimate of beta.
3. **upper_estimate_beta_plot()** - Plots the upper estimate of beta.
4. **town1_plot_error()** - Displays error analysis for town1 data.
5. **town1_plot_optimal_beta_ps()** - Plots optimal beta parameters for town1.
6. **town1_plot_optimal_against_data()** - Compares optimal values to town1 data.

### TLT 4
7. **town1_intervention_plot()** - Plots intervention scenarios for town1.
8. **town1_intervention_plot_error()** - Shows error for intervention analysis in town1.
9. **town1_intervention_plot_optimal()** - Displays optimal interventions for town1.
10. **town1_intervention_plot_optimal_against_data()** - Compares optimal interventions to town1 data.

### TLT 5
11. **town2_intervention_plot_optimised()** - Optimised intervention plot for town2.
12. **town2_intervention_immediately()** - Immediate intervention scenario for town2.

## License
