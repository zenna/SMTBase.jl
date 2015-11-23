## Type expressions / variables
## ============================

"Construct dimension param `s`"
function variable(s::Symbol; isnonnegative = true)
  if isnonnegative
    nonnegparam(Integer, s)
  else
    Parameter{Integer}(s)
  end
end

"Construct dimension param `s`"
function variable(s::Integer)
  ConstantVar{Integer}(s)
end

## Variable arrays
## ===============

"Gives names to things which can vary - parameters, port names, type variables"
abstract VarArray{T} <: Variable{T}
printers(VarArray)

immutable IndexedValue{T} <: ParameterExpr{T}
  array::VarArray{T}
  index::ParameterExpr
end

string(x::IndexedValue) = string(x.array, "[", x.index, "]")

"""A fixed length vector of type expressions and constants"""
immutable FixedLenVarArray{T} <: VarArray{T}
  typs::Tuple{Vararg{ParameterExpr{T}}}
end

FixedLenVarArray{T}(p::ParameterExpr{T}) = FixedLenVarArray{T}((p,))

# "create dimension parameters, e.g. dims = [3,d,1]"
FixedLenVarArray(vars::Tuple) = FixedLenVarArray(map(variable, vars))

length(x::FixedLenVarArray) = length(x.typs)
ndims(x::FixedLenVarArray) = 1
string(x::FixedLenVarArray) = join(map(string, x.typs),", ")
eltype{T}(x::FixedLenVarArray{T}) = T
getindex(x::FixedLenVarArray, i::Integer) = x.typs[i]
getindex{T<:Integer}(x::FixedLenVarArray, i::ParameterExpr{T}) = IndexedValue(x, i)

"A more efficient version of a FixedLenVarArray of ConstantVariables"
immutable ConstantArray{T<:Real} <: VarArray
  val::Array{T}
end
string(x::ConstantArray) = string(x.val)
getindex(x::ConstantArray, i::Integer) = x.val[i]
getindex{T<:Integer}(x::ConstantArray, i::ParameterExpr{T}) = IndexedValue(x, i)

"A vector of variable length of type expressions of `len`, e.g. s:[x_i for i = 1:n]"
immutable VarLenVarArray{T} <: VarArray{T}
  indexvar::Symbol        # e.g. i
  lb::Integer             #      1
  ub::Parameter{Integer}  #      n
  expr::ParameterExpr{T}  #      x_i
end

# Convenience
VarLenVarArray(indexvar::Symbol, lb::Integer, n::Symbol, expr::Symbol) =
  VarLenVarArray{Integer}(indexvar, lb, Parameter{Integer}(n), Parameter{Integer}(expr))

length(x::VarLenVarArray) = x.ub
ndims(x::VarLenVarArray) = 1
string(x::VarLenVarArray) = string("$(string(x.expr)) for $(x.indexvar) = $(x.lb):$(string(x.ub))")
getindex(x::VarLenVarArray, i::Integer) = x.typs[i]
getindex{T<:Integer}(x::VarLenVarArray, i::ParameterExpr{T}) = IndexedValue(x, i)

"Zero dimensional Array"
immutable Scalar{T} <: VarArray{T}
  val::ParameterExpr{T}
end

eltype{T}(::Scalar{T}) = T
length(::Scalar) = 0
ndims(::Scalar) = 0
shape(::Scalar) = FixedLenVarArray{Integer}(())
string(x::Scalar) = string(x.val)
