# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    traces(io, bh, trh)

Load seismic trace data from the IO stream `io`,
given the binary header `bh` and trace headers `trh`.
"""
function traces(io, bh, trh)
  # swap bytes if necessary
  swapbytes = isbigendian(io) ? ntoh : ltoh

  # number type for samples
  NUMBER_TYPE = numbertype(io)

  # number of traces
  ntraces = length(trh)

  # number of samples in each trace
  nsamples = Int.(replace(trh.SAMPLES_IN_TRACE, 0 => bh.SAMPLES_PER_TRACE))

  # seek start of trace headers
  seek(io, TEXTUAL_HEADER_SIZE + BINARY_HEADER_SIZE + nextendedheaders(io) * EXTENDED_HEADER_SIZE)

  # load file into RAM if size permits
  buff = filesize(io) < Sys.free_memory() ÷ 2 ? IOBuffer(read(io)) : io

  # pre-allocate array of traces
  data = [Vector{Float64}(undef, nsamples[j]) for j in 1:ntraces]

  # consume trace bytes
  @inbounds for j in 1:ntraces
    # skip trace header
    skip(buff, TRACE_HEADER_SIZE)

    # read trace samples
    samples = data[j]
    for i in 1:nsamples[j]
      samples[i] = swapbytes(read(buff, NUMBER_TYPE))
    end
  end

  data
end
