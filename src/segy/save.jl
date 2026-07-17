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

  # warn in case of NaN values because they are
  # not part of the SEG-Y standard and each software
  # may handle them differently (e.g., may throw an error)
  if any(any(isnan, t) for t in trd)
    @warn """NaN values found in traces.

    They will be saved as-is, but may not be handled
    correctly by other software. If you plan to share
    this SEG-Y file, consider replacing NaN with a
    sentinel value that can be represented in both
    IBM and IEEE floating-point format (e.g., 0.0).
    """
  end

  # fix issues with headers
  th₁, bh₁, eh₁, trh₁ = fixes(thₒ, bhₒ, ehₒ, trhₒ)

  # set SEG-Y revision
  th₂, bh₂, eh₂, trh₂ = setrev(th₁, bh₁, eh₁, trh₁)

  # swap bytes if necessary
  swapbytes = bh₂.ENDIAN_CONSTANT == BIG_ENDIAN ? hton : htol

  # number type for samples
  numbertype = code2type(bh₂.SAMPLE_FORMAT_CODE)

  # write textual header
  write(io, th₂)

  # write binary header
  writeswap(io, bh₂, swapbytes)

  # write extended headers
  foreach(h -> write(io, h), eh₂)

  # write trace headers and data
  for (h, t) in zip(trh₂, trd)
    writeswap(io, h, swapbytes)
    write(io, map(swapbytes ∘ numbertype, t))
  end
end
