# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    save(fname::AbstractString, dataset)

Save SEG-Y `dataset` to the file `fname`.
"""
save(fname::AbstractString, dataset::Dataset) = open(io -> save(io, dataset), fname, "w")

"""
    save(io::IO, dataset)

Save SEG-Y `dataset` to the IO stream `io`.
"""
function save(io::IO, dataset::Dataset)
  # retrieve dataset components
  thₒ = dataset.textualheader
  bhₒ = dataset.binaryheader
  ehₒ = dataset.extendedheaders
  trhₒ = dataset.traceheaders
  data = dataset.data

  # fix issues with headers
  th₁, bh₁, eh₁, trh₁ = fixissues(thₒ, bhₒ, ehₒ, trhₒ)

  # update to rev 2.1 compliance
  th₂, bh₂, eh₂, trh₂ = updaterev(th₁, bh₁, eh₁, trh₁)

  # write textual header
  write(io, th₂)

  # write binary header
  write(io, bh₂)

  # write extended headers
  foreach(h -> write(io, h), eh₂)

  # write trace headers and data
  for (h, t) in zip(trh₂, eachcol(data))
    write(io, h)
    write(io, t)
  end
end
