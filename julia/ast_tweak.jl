############################################################
# Using Julia-v0.3.2,
#   from julialang.org.
############################################################
using Base.Test

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
    oper = var[1]
    for item in var[2:end]
        push!(evalargs, evalAST(item))
    end
    return var[1] == SUM ? SUM(evalargs) : oper(evalargs[1], evalargs[2])
end

function timeAST ( var::Array{Any,1}; Iterations::Int64 = 100_000, ifCheck::Bool = true )
    result = 0.
    
    tic()
    for i = 1:Iterations
        result += evalAST(var)
    end
    toc()
    
    if ifCheck == true
        @test_approx_eq_eps( result, 3_900_000, 0.001)
    end
end

# Fisrt Run 'timeAST()' , waiting for functions compiled
print("[NOT benchmark. Waiting for functions compiled.]\n    ")
timeAST({SUM, {MUL, {DIV, 1., 1.}, 1.}, {SUB, 1., 1.}, {ADD, 1., 1.}}; Iterations=1,ifCheck=false )
print("\n")
# Benchmark @ this time
print("[Benchmark at this time.]\n")
timeAST(ast)
timeAST(ast)
timeAST(ast)
print("\n")

#= Tweaking in julia REPL
using ProfileView
ProfileView.view()
=#

None

