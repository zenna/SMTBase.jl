module SMTBase

using Compat
using ZenUtils

import Base:^,
            +,
            -,
            *,
            /,
            >,
            >=,
            <=,
            <,
            ==,
            !=,
            |,
            &,
            !,
            ifelse

import Base: string, isequal, print, println, show, showcompact
import Base: getindex, length

include("variable.jl")
include("array.jl")
include("solverinterface.jl")
end
