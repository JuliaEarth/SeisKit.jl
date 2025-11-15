# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    extendedheaders(fname::AbstractString) -> Vector{ExtendedHeader}
"""
extendedheaders(fname::AbstractString) = open(extendedheaders, fname)

"""
    extendedheaders(io::IO) -> Vector{ExtendedHeader}
"""
function extendedheaders(io::IO)
end 
