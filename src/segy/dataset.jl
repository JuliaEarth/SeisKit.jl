# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Segy.Dataset(th, bh, eh, trh, data)

A struct to hold SEG-Y dataset information,
including headers and trace data.
"""
struct Dataset{TraceHeaderVector<:FieldViewable,Data<:Array}
  textualheader::TextualHeader
  binaryheader::BinaryHeader
  extendedheaders::Vector{ExtendedHeader}
  traceheaders::TraceHeaderVector
  data::Data
end

# display SEG-Y dataset in pretty format
function Base.show(io::IO, dataset::Dataset)
  show(io, dataset.data)
end
