# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    binarheader(fname::AbstractString) -> BinaryHeader

Extract the SEG-Y binary header from the file `fname`.
"""
binaryheader(fname::AbstractString) = open(binaryheader, fname)

"""
    binarheader(io::IO) -> BinaryHeader

Extract the SEG-Y binary header from the IO stream `io`.
"""
function binaryheader(io::IO)
  # seek start of binary header
  seek(io, 3200)

  # read section 1 (bytes 3201 to 3300)
  fields1 = map(section1(BinaryHeader)) do field
    type = fieldtype(BinaryHeader, field)
    ntoh(read(io, type))
  end

  # skip unassigned section (bytes 3301 to 3500)
  skip(io, 200)

  # read section 2 (bytes 3501 to 3532)
  fields2 = map(section2(BinaryHeader)) do field
    type = fieldtype(BinaryHeader, field)
    ntoh(read(io, type))
  end

  # reinterpret fields as struct
  reinterpret(BinaryHeader, (fields1..., fields2...))
end

"""
    BinaryHeader(fields...)

SEG-Y binary header with all `fields` from
revisions 1.0, 2.0, and 2.1 of the standard.
"""
struct BinaryHeader
  JOB_ID::Int32
  LINE_NO::UInt32
  REEL_NO::UInt32
  DATA_TRACES_PER_ENSEMBLE::UInt16
  AUX_TRACES_PER_ENSEMBLE::UInt16
  SAMPLE_INTERVAL::UInt16
  ORIGINAL_SAMPLE_INTERVAL::UInt16
  SAMPLES_PER_TRACE::UInt16
  ORIGINAL_SAMPLES_PER_TRACE::UInt16
  SAMPLE_FORMAT_CODE::UInt16
  ENSEMBLE_FOLD::UInt16
  TRACE_SORTING_CODE::Int16
  VERTICAL_SUM_CODE::UInt16
  SWEEP_FREQ_START::UInt16
  SWEEP_FREQ_END::UInt16
  SWEEP_LENGTH::UInt16
  SWEEP_TYPE::UInt16
  TRACE_NO_SWEEP_CHANNEL::UInt16
  SWEEP_TRACE_TAPER_START::UInt16
  SWEEP_TRACE_TAPER_END::UInt16
  TAPER_TYPE::UInt16
  CORRELATED_TRACES::UInt16
  BINARY_GAIN_RECOV::UInt16
  AMPLITUDE_RECOV_METHOD::UInt16
  MEASUREMENT_SYSTEM::UInt16
  IMPULSE_SIGNAL_POLARITY::UInt16
  VIBRATORY_POLARITY_CODE::UInt16
  EXTENDED_DATA_TRACES_PER_ENSEMBLE::UInt32
  EXTENDED_AUX_TRACES_PER_ENSEMBLE::UInt32
  EXTENDED_SAMPLES_PER_TRACE::UInt32
  EXTENDED_SAMPLE_INTERVAL::Float64
  EXTENDED_ORIGINAL_SAMPLE_INTERVAL::Float64
  EXTENDED_ORIGINAL_SAMPLES_PER_TRACE::UInt32
  EXTENDED_ENSEMBLE_FOLD::UInt32
  ENDIAN_CONSTANT::UInt32
  MAJOR_SEGY_REV_NO::UInt8
  MINOR_SEGY_REV_NO::UInt8
  FIXED_LENGTH_TRACE_FLAG::UInt16
  EXTENDED_TEXT_HEADER_COUNT::UInt16
  MAX_EXTENDED_TRACE_HEADERS::UInt16
  SURVEY_TYPE::UInt16
  TIME_BASIS_CODE::UInt16
  TRACES_IN_STREAM::UInt64
  FIRST_TRACE_OFFSET::UInt64
  TRAILER_RECORDS::UInt32
end

# the first section of the SEG-Y binary header
# corresponds to all fields up to ENDIAN_CONSTANT
function section1(::Type{BinaryHeader})
  fields = fieldnames(BinaryHeader)
  endian = findfirst(==(:ENDIAN_CONSTANT), fields)
  fields[begin:endian]
end

# the second section of the SEG-Y binary header
# corresponds to all fields after ENDIAN_CONSTANT
function section2(::Type{BinaryHeader})
  fields = fieldnames(BinaryHeader)
  endian = findfirst(==(:ENDIAN_CONSTANT), fields)
  fields[endian+1:end]
end

# display SEG-Y binary header in pretty table format
function Base.show(io::IO, header::BinaryHeader)
  field = collect(fieldnames(typeof(header)))
  value = getfield.(Ref(header), field)
  pretty_table(io, (; field, value),
    title="SEG-Y Binary Header",
    fit_table_in_display_vertically=false,
    new_line_at_end=false,
    alignment=:l,
  )
end
