############################################################
# Using Julia-v0.3.2,
#   from julialang.org.
############################################################

const ADD = +

const SUB = -

const DIV = /

const MUL = *

function SUM (n::Array{Any, 1})
    s = 0.
    for item in n
        s += item
    end
    return s
end

const ast = {SUM,
        {SUB,{ADD,{DIV,{MUL,10.,20.},30.},40.},50.},
        {SUB,{ADD,{DIV,{MUL,20.,30.},40.},50.},60.},
        {SUB,{ADD,{DIV,{MUL,30.,40.},50.},60.},70.},
        {SUB,{ADD,{DIV,{MUL,40.,50.},60.},70.},80.}
}

evalAST ( var::Float64 ) = var
function evalAST ( var::Array{Any,1} )
    evalargs = {}
    for item in var[2:end]
        push!(evalargs, evalAST(item))
    end
    return var[1] == SUM ? SUM(evalargs) : var[1](evalargs[1], evalargs[2])
end

function timeAST ( var::Array{Any,1}; Iterations::Int64 = 100_000 )
    result = 0
    for i in 1:Iterations
        result += evalAST(var)
    end
    return result
end

# Fisrt Run 'timeAST()' , waiting for functions compiled
print("[NOT benchmark. Waiting for functions compiled.]\n    ")
@time timeAST({SUM, {MUL, {DIV, 1., 1.}, 1.}, {SUB, 1., 1.}, {ADD, 1., 1.}})
print("\n")
# Benchmark @ this time
print("[Benchmark at this time.]\n")
@time timeAST(ast)
@time timeAST(ast)
@time timeAST(ast)
print("\n")

#= Tweaking in julia REPL
using ProfileView
ProfileView.view()
=#

None

