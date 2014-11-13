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
    for item in var[2:end]
        push!(evalargs, evalAST(item))
    end
    oper = var[1]
    return oper == SUM ? SUM(evalargs) : oper(evalargs[1],evalargs[2])
end

function timeAST ( var::Array{Any,1}, Iterations::Int64 = 100_000 )
    result = 0.
    for i in 1:Iterations
        result += evalAST(var)
    end
    return result
end

const ast = {SUM,
        {SUB,{ADD,{DIV,{MUL,10.,20.},30.},40.},50.},
        {SUB,{ADD,{DIV,{MUL,20.,30.},40.},50.},60.},
        {SUB,{ADD,{DIV,{MUL,30.,40.},50.},60.},70.},
        {SUB,{ADD,{DIV,{MUL,40.,50.},60.},70.},80.}
}

timeAST({SUM,{MUL,{ADD,1.,1.},1.},{DIV,{SUB,2.,1.},1.}})
@time result = timeAST(ast)
print("The result number of AST is ", iround(result), "\n")

None

