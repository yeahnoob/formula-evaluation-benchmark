type ADD
    x::Float64
    y::Float64
    ADD(p) = 
        typeof(p) == Array{Any,1} ?
            new(p[1]::Float64, p[2]::Float64) : new(p)
end
calc (n::ADD) = n.x + n.y

type SUB
    x::Float64
    y::Float64
    SUB(p) = 
        typeof(p) == Array{Any,1} ?
            new(p[1]::Float64, p[2]::Float64) : new(p)
end
calc (n::SUB) = n.x - n.y

type MUL
    x::Float64
    y::Float64
    MUL(p) = 
        typeof(p) == Array{Any,1} ?
            new(p[1]::Float64, p[2]::Float64) : new(p)
end
calc (n::MUL) = n.x * n.y

type DIV
    x::Float64
    y::Float64
    DIV(p) = 
        typeof(p) == Array{Any,1} ?
            new(p[1]::Float64,p[2]::Float64) : new(p)
end
calc (n::DIV) = n.x / n.y

type SUM
    x::Array{Any,1}
end
function calc (n::SUM)
    s = 0
    for item in n.x
        s += item
    end
    return s
end


function evalAST ( var )
    opertype = var[1]
    evalargs = {}
    for item in var[2:end]
        if (typeof(item) == Array{Any,1})
            t = evalAST(item)
            push!(evalargs, t)
        else
            push!(evalargs, item)
        end
    end

    return calc(opertype(evalargs))
end

iterations = 100_000
function timeAST ( var )
    result = 0
    for i in 1:iterations
        result += evalAST(var)
    end
    return result
end

ast = {SUM,
        {SUB,{ADD,{DIV,{MUL,10.,20.},30.},40.},50.},
        {SUB,{ADD,{DIV,{MUL,20.,30.},40.},50.},60.},
        {SUB,{ADD,{DIV,{MUL,30.,40.},50.},60.},70.},
        {SUB,{ADD,{DIV,{MUL,40.,50.},60.},70.},80.}
}
@time result = timeAST(ast)
print("The result number of AST is ", iround(result), "\n")
ast = {SUM,
        {SUB,{ADD,{DIV,{MUL,50.,40.},30.},20.},10.},
        {SUB,{ADD,{DIV,{MUL,60.,50.},40.},30.},20.},
        {SUB,{ADD,{DIV,{MUL,70.,60.},50.},40.},30.},
        {SUB,{ADD,{DIV,{MUL,80.,70.},60.},50.},40.}
}
@time result = timeAST(ast)
print("The result number of AST is ", iround(result), "\n")
ast = {SUM,
        {SUB,{ADD,{DIV,{MUL,10.,20.},30.},40.},50.},
        {SUB,{ADD,{DIV,{MUL,20.,30.},40.},50.},60.},
        {SUB,{ADD,{DIV,{MUL,30.,40.},50.},60.},70.},
        {SUB,{ADD,{DIV,{MUL,40.,50.},60.},70.},80.}
}
@time result = timeAST(ast)
print("The result number of AST is ", iround(result), "\n")
ast = {SUM,
        {SUB,{ADD,{DIV,{MUL,50.,40.},30.},20.},10.},
        {SUB,{ADD,{DIV,{MUL,60.,50.},40.},30.},20.},
        {SUB,{ADD,{DIV,{MUL,70.,60.},50.},40.},30.},
        {SUB,{ADD,{DIV,{MUL,80.,70.},60.},50.},40.}
}
@time result = timeAST(ast)
print("The result number of AST is ", iround(result), "\n")

None

