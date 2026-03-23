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

  # number of samples in each trace
  nsamples = Int.(replace(trh.SAMPLES_IN_TRACE, 0 => SAMPLES_PER_TRACE))

  # seek start of trace headers
  seek(io, TEXTUAL_HEADER_SIZE + BINARY_HEADER_SIZE + nextendedheaders(io) * EXTENDED_HEADER_SIZE)

  # load file into RAM if size permits
  buff = filesize(io) < Sys.free_memory() ÷ 2 ? IOBuffer(read(io)) : io

  # sort trace indices to read traces in order
  sortedinds = sort(inds)

  # pre-allocate array of traces
  data = [Vector{Float64}(undef, nsamples[ind]) for ind in sortedinds]

  # consume trace bytes
  prev = 1
  @inbounds for (j, ind) in enumerate(sortedinds)
    # skip all traces before the current trace
    for k in prev:ind-1
      skip(buff, TRACE_HEADER_SIZE + nsamples[k] * sizeof(NUMBER_TYPE))
    end

    # skip trace header of current trace
    skip(buff, TRACE_HEADER_SIZE)

    # read trace samples
    samples = data[j]
    for i in 1:nsamples[ind]
      samples[i] = swapbytes(read(buff, NUMBER_TYPE))
    end

    prev = ind + 1
  end

  data
end
