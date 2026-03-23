# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    traces(fname::AbstractString, trh, inds=1:length(trh)) -> Vector{Vector{Float64}}

Load seismic trace data from the file `fname`,
using information in the trace headers `trh`.

Optionally, specify a subset of trace `inds` to load.
"""
traces(fname::AbstractString, trh, inds=1:length(trh)) = open(io -> traces(io, trh, inds), fname)

"""
    traces(io::IO, trh, inds=1:length(trh)) -> Vector{Vector{Float64}}

Load seismic trace data from the IO stream `io`,
using information in the trace headers `trh`.

Optionally, specify a subset of trace `inds` to load.
"""
function traces(io::IO, trh, inds=1:length(trh))
  # swap bytes if necessary
  swapbytes = isbigendian(io) ? ntoh : ltoh

  # number type for samples
  NUMBER_TYPE = numbertype(io)

  # samples per trace (from binary header)
  SAMPLES_PER_TRACE = samplespertrace(io)

  # number of traces
  ntraces = length(trh)

  # number of samples in each trace
  nsamples = Int.(replace(trh.SAMPLES_IN_TRACE, 0 => SAMPLES_PER_TRACE))

  # seek start of trace headers
  seek(io, TEXTUAL_HEADER_SIZE + BINARY_HEADER_SIZE + nextendedheaders(io) * EXTENDED_HEADER_SIZE)

  # load file into RAM if size permits
  buff = filesize(io) < Sys.free_memory() ÷ 2 ? IOBuffer(read(io)) : io

  # pre-allocate array of traces
  data = [Vector{Float64}(undef, nsamples[j]) for j in inds]

  # consume trace bytes
  current = 0
  indpool = Set(inds)
  @inbounds for j in 1:ntraces
    # skip trace header
    skip(buff, TRACE_HEADER_SIZE)

    # read trace samples
    if j ∈ indpool
      samples = data[(current += 1)]
      for i in 1:nsamples[j]
        samples[i] = swapbytes(read(buff, NUMBER_TYPE))
      end
    else
      skip(buff, nsamples[j] * sizeof(NUMBER_TYPE))
    end
  end

  data
end
