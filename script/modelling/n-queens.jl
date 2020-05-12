#' ---
#' title: N-Queens
#' ---

#' **Originally Contributed by**: Matthew Helm

#' The N-Queens problem involves placing N queens on an N x N chessboard such that none of the queens attacks another. In chess, a 
#' queen can move vertically, horizontally, and diagonally so there cannot be more than one queen on any given row, column, or 
#' diagonal.

#' <img src="img/n_queens4.png" style="width: auto; height: auto" alt="4 Queens">

#' *Note that none of the queens above are able to attack any other as a result of their careful placement.*

using GLPK
using JuMP
using LinearAlgebra

# N-Queens
N = 8

model = Model(GLPK.Optimizer);

#' Next, let's create an N x N chessboard of binary values. 0 will represent an empty space on the board and 1 will represent a 
#' space occupied by one of our queens:

@variable(model, x[i=1:N, j=1:N], Bin)

#' Now we can add our constraints:

# There must be exactly one queen in a given row/column
for i=1:N
    @constraint(model, sum(x[i, :]) == 1)
    @constraint(model, sum(x[:, i]) == 1)
end

#' That's it! We are ready to put our model to work and see if it is able to find a feasible solution:

optimize!(model)

#' We can now review the solution that our model found:

solution = value.(x)

#' <img src="img/n_queens.png" style="width: auto; height: auto" alt="4 Queens">

#' ** Bonus content:**

#' Here is the code to plot your solutions with Makie.jl:

using Base.Iterators: repeated
using Makie

r = 1:N
board = isodd.(r .+ r')
scene = Scene(resolution = (250, 250))
heatmap!(scene, board, scale_plot = false, show_axis = false, colormap=:Paired)
queens = [repeated('♕', N)...]
x_positions = [findall(isequal(1.0), value.(x)[i,:])[1] for i = N:-1:1]
y_positions = 1:N
w_positions = Point2.(x_positions, y_positions)
game = scatter!(
    scene, w_positions, marker = queens,
    scale_plot = false, show_axis = false,
    markersize = 0.5, marker_offset = Vec2f0(-0.7)
)[end]