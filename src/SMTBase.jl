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

include("variable.jl")
include("solverinterface.jl")
end
