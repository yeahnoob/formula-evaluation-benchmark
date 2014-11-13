using Base.Test

ADD = +

SUB = -

DIV = /

MUL = *

function SUM (n::Array{Any, 1})
    s = 0.
    for item in n
        s += item
    end
    return s
end

evalAST( var::Float64 ) = var
function evalAST ( var::Array{Any,1} )
    evalargs = {}
    oper = var[1]
    for item in var[2:end]
        push!(evalargs, evalAST(item))
    end
    return oper == SUM ? SUM(evalargs) : oper(evalargs[1],evalargs[2])
end

function timeAST ( var::Array{Any,1}, Iterations::Int64 = 100_000, ifCheck::Bool = true )
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

const ast = {SUM,
        {SUB,{ADD,{DIV,{MUL,10.,20.},30.},40.},50.},
        {SUB,{ADD,{DIV,{MUL,20.,30.},40.},50.},60.},
        {SUB,{ADD,{DIV,{MUL,30.,40.},50.},60.},70.},
        {SUB,{ADD,{DIV,{MUL,40.,50.},60.},70.},80.}
}

# run the first time for timeAST() compiled
#timeAST({SUM,{MUL,{ADD,1.,1.},1.},{DIV,{SUB,2.,1.},1.}}, 1, false)
# Real Benchmark Followed
timeAST(ast)
print 

None

