using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

srand(0)

name = "multiplication_dense_sparse"

samples = 5
evals = 100
cutoffs = [50:50:1001;]

s = 0.01

function f(op1, op2, result)
    operators.gemm!(Complex128(1., 0.), op1, op2, Complex128(0., 0.), result)
end

println("Benchmarking: ", name)
print("Cutoff: ")
results = []
for N in cutoffs
    print(N, " ")
    b = GenericBasis(N)
    op1 = randoperator(b)
    op2 = SparseOperator(b, sprand(Complex128, N, N, s))
    result = DenseOperator(b)
    t = @belapsed f($op1, $op2, $result) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)