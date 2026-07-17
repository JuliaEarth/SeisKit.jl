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
  th = dataset.textualheader
  bh = dataset.binaryheader
  eh = dataset.extendedheaders
  trh = dataset.traceheaders
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

  # fix issues with headers and
  # set SEG-Y revision explicitly
  bh′, trh′ = fixes(th, bh, eh, trh)

  # swap bytes if necessary
  swapbytes = bh′.ENDIAN_CONSTANT == BIG_ENDIAN ? hton : htol

  # floating point type
  floattype = code2type(bh′.SAMPLE_FORMAT_CODE)

  # write textual header
  write(io, th)

  # write binary header
  writeswap(io, bh′, swapbytes)

  # write extended headers
  foreach(h -> write(io, h), eh)

  # write trace headers and data
  for (h, t) in zip(trh′, trd)
    writeswap(io, h, swapbytes)
    write(io, map(swapbytes ∘ floattype, t))
  end
end

"""
    fixes(th, bh, eh, trh) -> (bh′, trh′)

Prepare SEG-Y headers for saving by fixing
issues and setting the revision explicitly.
"""
function fixes(th, bh, eh, trh)
  # copy inputs to avoid side effects
  bh′ = deepcopy(bh)
  trh′ = deepcopy(trh)

  # fix SAMPLES_IN_TRACE = 0
  replace!(trh′.SAMPLES_IN_TRACE, 0 => bh′.SAMPLES_PER_TRACE)

  if bh.FIXED_LENGTH_TRACE_FLAG > 0
    # fix varying SAMPLES_IN_TRACE with FIXED_LENGTH_TRACE_FLAG > 0
    if !allequal(trh′.SAMPLES_IN_TRACE)
      bh′.FIXED_LENGTH_TRACE_FLAG = 0
    end

    # fix SAMPLES_IN_TRACE different from SAMPLES_PER_TRACE
    if !all(==(bh′.SAMPLES_PER_TRACE), trh′.SAMPLES_IN_TRACE)
      bh′.SAMPLES_PER_TRACE = first(trh′.SAMPLES_IN_TRACE)
    end
  end

  if bh′.FIXED_LENGTH_TRACE_FLAG > 1
    # fix invalid FIXED_LENGTH_TRACE_FLAG
    bh′.FIXED_LENGTH_TRACE_FLAG = 1
  end

  if isempty(eh)
    # be conservative, save in revision 1.0
    bh′.MAJOR_REVISION_NUMBER = 1
    bh′.MINOR_REVISION_NUMBER = 0
    bh′.ENDIAN_CONSTANT = BIG_ENDIAN
    bh′.SAMPLE_FORMAT_CODE = IEEE_FLOAT32
  else
    # extended headers require revision 2.x
    bh′.MAJOR_REVISION_NUMBER = 2
    bh′.MINOR_REVISION_NUMBER = 1
    bh′.ENDIAN_CONSTANT = LITTLE_ENDIAN
    bh′.SAMPLE_FORMAT_CODE = IEEE_FLOAT64
  end

  # return fixed headers
  bh′, trh′
end
