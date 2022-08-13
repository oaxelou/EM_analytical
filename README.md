# EM_analytical
A matlab tool that analytically calculates the transient Electromigration (EM) stress at discrete spatial points in multi-segment lines of power grids. This method exploits the specific form of the discrete stress coefficient matrix and constructs a closed-form with almost linear complexity without the need of time discretization. Then, this closed-form equation can be used at any given time in transient stress analysis by executing the `EM_analytical_stress_calculation.m` script.

If you use any part of this project, please cite:

Olympia Axelou, Nestor Evmorfopoulos, George Floros, George Stamoulis, Sachin Sapatnekar. 2022. A Novel Semi-Analytical Approach for Fast Electromigration Stress Analysis in Multi-Segment Interconnects. In *Proceedings of 2022 IEEE/ACM International Conference On Computer Aided Design (ICCAD).* ACM, San Diego, CA, USA.

## Guideline to use EM_analytical

### Matlab files hierarchy

- Matlab script files:
  - **EM_analytical_wrapper.m** - The wrapper of our tool. It includes the input parsing, the EM analytical functions calling and plotting of the results.
  - **EM_analytical_formulation.m** - This function corresponds to the one-time-cost Algorithm 1 of our paper. It forms the time-invariant matrices of our closed-form solution.
  - **EM_analytical_stress_calculation.m** - This function corresponds to Algorithm 2 of our paper. It is called for each different time where we want to calculate the transient stress, σ(t) and provides the final solution. 
  - (auxiliary) **read_inputs.m** - Auxiliary function that parses the input files (line geometry and current density files) and returns the lengths and the current densities of each segment of the line. 
  - (auxiliary) **matrix_formulation.m** - Auxiliary function that forms the system matrices A and B.
- Folder ``dct/`` includes third-party software containing the Discrete Cosine Transform Type II (DCT-II) and the Inverse Discrete Cosine Transform Type II (IDCT-II).
- Folder ``benchmarks/`` contains the input files for our tool.

## Inputs

The input files in order to execute the tool as standalone are:
- The segment lengths. An indicative line of this file would be:
  ```
  <segment name> <node1> <node2> <length (m)>
  ```
- The current densities. For example:
  ```
  <segment name>, curden = <current density (A/m^2)>
  ```

## How to run

This tool was developed using MATLAB R2021a. 

### Tool as standalone

In order to use the tool as standalone, and calculate the EM stress at a specific time, one has to: 
- Set the time ``t = 6.38e8; (20y)`` and the discretization point ``dx = 1e-6; (m)``
- Define the line and current densities input files
  ```
  benchmark = '5-segment';
  tree_file = strcat('benchmarks/', benchmark, '/tree_line.txt');
  current_densities_file = strcat('benchmarks/', benchmark, '/tree_curden.txt');
  ```
- Set the physical parameters of the line (in our example we have used Cu DD)

### Integration into other projects

Inputs:
  - System matrix **B**
  - Current densities ``u``
  - Total discretization points ``nx_total``

Steps:
1. Execute function ``EM_analytical_formulation.m`` in order to find the time-invariant parts of the closed-form equation:
   - The eigenvalues of matrix **A** (``lambdas``) 
   - A temporary matrix ``right_side_matrix``
2. Execute function ``EM_analytical_stress_calculation.m`` at each t to find stress across the line at the corresponding time.

In case of transient analysis, one can execute Step 2 for multiple points in time. Our tool supports parallel execution.

## Example (5-segment-line) 

In this repository, we provide an example of 5-segment line as shown here:

![5-segmet-line](https://user-images.githubusercontent.com/33567827/180488332-1daded0f-e0aa-482c-96ab-c6d653d99a42.png)


Performing stress analysis with our tool at ``t=6.38e8``, i.e. 20years, and with discretization step ``dx=1e-6`` gives as the following results:

![5-segment-example](https://user-images.githubusercontent.com/33567827/180483074-c9c4df4f-f890-437c-94a5-1bb40af0a296.png)




