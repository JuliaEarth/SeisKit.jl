# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    load(fname::AbstractString)

Load SEG-Y from the file `fname`.
"""
load(fname::AbstractString) = open(load, fname)

"""
    load(io::IO)

Load SEG-Y from the IO stream `io`.
"""
function load(io::IO)
  th = textualheader(io)
  bh = binaryheader(io)
  eh = extendedheaders(io)
  trh = traceheaders(io)
  th, bh, eh, trh
end
