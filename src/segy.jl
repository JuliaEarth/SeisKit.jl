# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module Segy

using StringEncodings
using StyledStrings
using PrettyTables
using FieldViews

# IBM floating point type
include("segy/ibmfloat.jl")

# SEG-Y byte constants
include("segy/consts.jl")

# utility functions
include("segy/utils.jl")
include("segy/ioutils.jl")

# main functions
include("segy/headers.jl")
include("segy/report.jl")
include("segy/load.jl")
include("segy/save.jl")

end
