# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
The `Segy` module provides tools to load and save SEG-Y files
as well as utilities to report and fix common issues found in
SEG-Y headers.

The main functions defined in this module are:

- [`Segy.report`](@ref): reports common issues found in SEG-Y headers.
- [`Segy.headers`](@ref): retrieves textual, binary, extended and trace headers.
- [`Segy.load`](@ref): loads SEG-Y files into Julia arrays effieciently.
- [`Segy.save`](@ref): saves seismic structs into SEG-Y files compliant with rev 2.1.

Additional functions are provided to fix common issues found in SEG-Y headers
(`Segy.fixissues`), read trace headers only (`Segy.traceheaders`), and more.
"""
module Segy

using StringEncodings
using StyledStrings
using PrettyTables
using WrappedUnions
using FieldViews
using CoordRefSystems
using Unitful

# IBM floating point type
include("segy/ibmfloat.jl")

# SEG-Y byte constants
include("segy/consts.jl")

# utility functions
include("segy/utils.jl")
include("segy/ioutils.jl")

# headers and traces
include("segy/headers.jl")
include("segy/traces.jl")

# header improvements
include("segy/fixissues.jl")
include("segy/updaterev.jl")

# SEG-Y datasets
include("segy/dataset.jl")

# main functions
include("segy/report.jl")
include("segy/load.jl")
include("segy/save.jl")

end
