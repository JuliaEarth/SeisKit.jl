# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    load(fname::AbstractString)

Load SEG-Y data from the file `fname`.
"""
load(fname::AbstractString) = open(load, fname)

"""
    load(io::IO)

Load SEG-Y data from the IO stream `io`.
"""
function load(io::IO)
  th, bh, eh, trh = headers(io)
  data = traces(io, bh, eh, trh)
  Dataset(th, bh, eh, trh, data)
end
