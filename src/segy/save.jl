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
  trd = dataset.traces

  # fix issues with headers
  th₁, bh₁, eh₁, trh₁ = fixes(thₒ, bhₒ, ehₒ, trhₒ)

  # set SEG-Y revision
  th₂, bh₂, eh₂, trh₂ = setrev(th₁, bh₁, eh₁, trh₁)

  # swap bytes if necessary
  swapbytes = bh₂.ENDIAN_CONSTANT == BIG_ENDIAN ? hton : htol

  # write textual header
  write(io, th₂)

  # write binary header
  write(io, bh₂)

  # write extended headers
  foreach(h -> write(io, h), eh₂)

  # write trace headers and data
  for (h, t) in zip(trh₂, trd)
    write(io, h)
    write(io, map(Float32, t))
  end
end
