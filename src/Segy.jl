# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module Segy

using StringEncodings
using PrettyTables

# SEG-Y constants
include("consts.jl")

# IBM floating point type
include("ibmfloat.jl")

# utility functions
include("utils.jl")
include("ioutils.jl")

# header definitions
include("headers/textual.jl")
include("headers/binary.jl")
include("headers/extended.jl")
include("headers/trace.jl")

# main functions
include("load.jl")

end
