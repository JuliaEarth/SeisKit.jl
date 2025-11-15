# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    traceheaders(fname::AbstractString) -> Vector{TraceHeader}

Extract all SEG-Y trace headers from the file `fname`.
"""
traceheaders(fname::AbstractString) = open(traceheaders, fname)

"""
    traceheaders(io::IO) -> Vector{TraceHeader}

Extract all SEG-Y trace headers from the IO stream `io`.
"""
function traceheaders(io::IO)
end
