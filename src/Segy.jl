# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module Segy

using StringEncodings
using PrettyTables

# IBM floating point type
include("ibmfloat.jl")

# utility functions
include("utils.jl")

# header definitions
include("headers/textual.jl")
include("headers/binary.jl")
include("headers/extended.jl")
include("headers/trace.jl")

# main functions
include("load.jl")

end
