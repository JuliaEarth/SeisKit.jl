# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Segy.Dataset(th, bh, eh, trh, traces)

A struct to hold SEG-Y dataset information,
including headers and traces.
"""
struct Dataset{TraceHeaderVector<:FieldViewable}
  textualheader::TextualHeader
  binaryheader::BinaryHeader
  extendedheaders::Vector{ExtendedHeader}
  traceheaders::TraceHeaderVector
  traces::Vector{Vector{Float64}}
end

# display SEG-Y dataset in pretty format
function Base.summary(io::IO, dataset::Dataset)
  print(io, "SEG-Y Dataset")
end

Base.show(io::IO, dataset::Dataset) = summary(io, dataset)

function Base.show(io::IO, ::MIME"text/plain", dataset::Dataset)
  ntraces = length(dataset.traces)
  minlen, maxlen = extrema(length.(dataset.traces))
  summary(io, dataset)
  println(io)
  println(io, "├─ Nᵒ traces: ", length(dataset.traces))
  println(io, "├─ Min length: ", minlen)
  print(io,   "└─ Max length: ", maxlen)
end
