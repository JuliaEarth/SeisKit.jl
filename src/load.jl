# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    load(fname::AbstractString)

Load SEGY from the file `fname`.
"""
load(fname::AbstractString) = open(load, fname)

"""
    load(io::IO)

Load SEGY from the IO stream `io`.
"""
function load(io::IO)
  th = textualheader(io)
  bh = binaryheader(io)
end
