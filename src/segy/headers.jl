# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    headers(fname::AbstractString)

Return SEG-Y headers from the file `fname`.
"""
headers(fname::AbstractString) = open(headers, fname)

"""
    headers(io::IO)

Return SEG-Y headers from the IO stream `io`.
"""
function headers(io::IO)
  th = textualheader(io)
  bh = binaryheader(io)
  eh = extendedheaders(io)
  trh = traceheaders(io)
  th, bh, eh, trh
end

# -------------------
# HEADER DEFINITIONS
# -------------------

include("headers/textual.jl")
include("headers/binary.jl")
include("headers/extended.jl")
include("headers/trace.jl")
