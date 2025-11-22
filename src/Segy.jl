# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module Segy

using StringEncodings
using StyledStrings
using PrettyTables
using WrappedUnions
using FieldViews

# IBM floating point type
include("ibmfloat.jl")

# SEG-Y byte constants
include("consts.jl")

# utility functions
include("utils.jl")
include("ioutils.jl")

# main functions
include("headers.jl")
include("report.jl")
include("load.jl")
include("save.jl")

end
