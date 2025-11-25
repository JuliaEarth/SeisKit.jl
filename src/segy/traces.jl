# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    traces(io, bh, trh)

Load seismic trace data from the IO stream `io`,
given the binary header `bh` and trace headers `trh`.
"""
function traces(io, bh, trh)
  # determine number of traces
  ntraces = length(trh)

  # determine number of samples in each trace
  nsamples = Int.(replace(trh.SAMPLES_IN_TRACE, 0 => bh.SAMPLES_PER_TRACE))

  # determine number of dimensions (2D or 3D seismic)
  ilines = trh.INLINE_NUMBER
  xlines = trh.CROSSLINE_NUMBER
  nilines = length(unique(ilines))
  nxlines = length(unique(xlines))
  ndims = nilines > 1 && nxlines > 1 ? 3 : 2

  # determine if all traces have the same number of samples
  fixedlength = allequal(nsamples)

  # load traces with optimized method
  if fixedlength
    if ndims == 2
      # return 2D matrix of size nsamples[1] x ntraces
      tracesfixedlength2D(io, first(nsamples), ntraces)
    else
      # return 3D array of size nsamples[1] x nilines x nxlines
      throw(ErrorException("3D seismic not yet implemented"))
    end
  else
    throw(ErrorException("variable-length traces not yet implemented"))
  end
end

function tracesfixedlength2D(io, m, n)
  # swap bytes if necessary
  swapbytes = isbigendian(io) ? ntoh : ltoh

  # number type for samples
  NUMBER_TYPE = numbertype(io)

  # seek start of trace headers
  seek(io, TEXTUAL_HEADER_SIZE + BINARY_HEADER_SIZE + nextendedheaders(io) * EXTENDED_HEADER_SIZE)

  # load file into RAM if size permits
  buff = filesize(io) < Sys.free_memory() ÷ 2 ? IOBuffer(read(io)) : io

  # convert trace bytes into matrix
  data = Matrix{Float64}(undef, m, n)
  for j in 1:n
    # skip trace header
    skip(buff, TRACE_HEADER_SIZE)

    # read trace samples
    for i in 1:m
      @inbounds data[i, j] = swapbytes(read(buff, NUMBER_TYPE))
    end
  end

  data
end
