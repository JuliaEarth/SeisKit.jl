# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module Segy

using StringEncodings
using PrettyTables

# utility functions
include("utils.jl")

# header definitions
include("headers/textual.jl")
include("headers/binary.jl")
include("headers/extended.jl")
include("headers/trace.jl")

# main functionality
include("load.jl")

end
