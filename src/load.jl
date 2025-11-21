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
  traces(io, bh, eh, trh)
end

function traces(io, bh, eh, trh)
  # determine number of traces
  ntraces = length(trh)

  # determine number of samples in each trace
  nsamples = Int.(replace(trh.SAMPLES_IN_TRACE, 0 => bh.SAMPLES_PER_TRACE))

  # determine number of dimensions (2D or 3D seismic)
  ninline = length(unique(trh.INLINE_NUMBER))
  ncross = length(unique(trh.CROSSLINE_NUMBER))
  ndims = ninline > 1 && ncross > 1 ? 3 : 2

  # load traces with optimized method
  if ndims == 2
    if allequal(nsamples)
      traces2Dfixedlength(io, first(nsamples), ntraces)
    else
      throw(ErrorException("Variable-length 2D seismic data loading not yet implemented"))
    end
  else
    throw(ErrorException("3D seismic data loading not yet implemented"))
  end
end

function traces2Dfixedlength(io, m, n)
  # swap bytes if necessary
  swapbytes = isbigendian(io) ? ntoh : ltoh

  # determine final number type for samples
  T = numbertype(io)
  F = T <: IBMFloat32 ? Float64 : T

  # pre-allocate data array with final number type
  data = Matrix{F}(undef, m, n)

  # seek start of trace data
  seek(io, TEXTUAL_HEADER_SIZE + BINARY_HEADER_SIZE + nextendedheaders(io) * EXTENDED_HEADER_SIZE)

  # load all traces
  for j in 1:n
    # skip trace header
    skip(io, TRACE_HEADER_SIZE)

    # read trace samples
    @inbounds for i in 1:m
      v = swapbytes(read(io, T))
      data[i, j] = convert(F, v)
    end
  end

  data
end
