# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    load(fname::AbstractString[, traceinds]) -> Dataset

Load SEG-Y data from the file `fname`.

Optionally, specify a subset of `traceinds` to load.
"""
load(fname::AbstractString, traceinds=nothing) = open(io -> load(io, traceinds), fname)

"""
    load(io::IO[, traceinds]) -> Dataset

Load SEG-Y data from the IO stream `io`.

Optionally, specify a subset of `traceinds` to load.
"""
function load(io::IO, traceinds=nothing)
  th, bh, eh, trh = headers(io)
  inds = isnothing(traceinds) ? (1:length(trh)) : traceinds
  Dataset(th, bh, eh, view(trh, inds), traces(io, trh, inds))
end
