# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    traceheaders(fname::AbstractString) -> Vector{TraceHeader}

Read all SEG-Y trace headers from the file `fname`.
"""
traceheaders(fname::AbstractString) = open(traceheaders, fname)

"""
    traceheaders(io::IO) -> Vector{TraceHeader}

Read all SEG-Y trace headers from the IO stream `io`.
"""
function traceheaders(io::IO)
  # swap bytes if necessary
  swapbytes = isbigendian(io) ? ntoh : ltoh

  # number type for samples (from binary header)
  NUMBER_TYPE = numbertype(io)

  # samples per trace (from binary header)
  SAMPLES_PER_TRACE = samplespertrace(io)

  # seek start of trace headers
  seek(io, TEXTUAL_HEADER_SIZE + BINARY_HEADER_SIZE + nextendedheaders(io) * EXTENDED_HEADER_SIZE)

  # read all trace headers
  headers = TraceHeader[]
  while !eof(io)
    # read fields of trace header
    fields = map(fieldnames(TraceHeader)) do field
      type = fieldtype(TraceHeader, field)
      swapbytes(read(io, type))
    end

    # skip unassigned section (bytes 233 to 240)
    skip(io, 8)

    # build trace header
    header = TraceHeader(fields...)

    # determine number of samples in trace
    SAMPLES_IN_TRACE = header.SAMPLES_IN_TRACE
    if iszero(SAMPLES_IN_TRACE)
      SAMPLES_IN_TRACE = SAMPLES_PER_TRACE
    end

    # skip trace samples
    skip(io, SAMPLES_IN_TRACE * sizeof(NUMBER_TYPE))

    # save header and continue
    push!(headers, header)
  end

  # return trace headers as field views
  FieldViewable(headers)
end

# ------------------
# HEADER DEFINITION
# ------------------

"""
    TraceHeader(fields...)

SEG-Y trace header with all `fields` from
revisions 1.0, 2.0, and 2.1 of the standard.
"""
mutable struct TraceHeader
  TRACE_NUMBER_IN_LINE::Int32
  TRACE_NUMBER_IN_FILE::Int32
  ORIGINAL_FIELD_RECORD_NUMBER::Int32
  TRACE_NUMBER_IN_ORIGINAL_FIELD_RECORD::Int32
  ENERGY_SOURCE_POINT_NUMBER::Int32
  ENSEMBLE_NUMBER::Int32
  TRACE_NUMBER_IN_ENSEMBLE::Int32
  TRACE_ID_CODE::Int16
  VERTICALLY_SUMMED_TRACES::Int16
  HORIZONTALLY_STACKED_TRACES::Int16
  DATA_USE::Int16
  DISTANCE_SOURCE_RECEIVER::Int32
  RECEIVER_ELEVATION::Int32
  SOURCE_SURFACE_ELEVATION::Int32
  SOURCE_DEPTH_BELOW_SURFACE::Int32
  RECEIVER_DATUM::Int32
  SOURCE_DATUM::Int32
  SOURCE_WATER_DEPTH::Int32
  RECEIVER_WATER_DEPTH::Int32
  ELEVATION_SCALAR::Int16
  COORDINATE_SCALAR::Int16
  SOURCE_X::Int32
  SOURCE_Y::Int32
  RECEIVER_X::Int32
  RECEIVER_Y::Int32
  COORDINATE_UNIT::Int16
  WEATHERING_VELOCITY::Int16
  SUBWEATHERING_VELOCITY::Int16
  SOURCE_UPHOLE_TIME::Int16
  RECEIVER_UPHOLE_TIME::Int16
  SOURCE_STATIC_CORRECTION::Int16
  RECEIVER_STATIC_CORRECTION::Int16
  TOTAL_STATIC_CORRECTION::Int16
  LAG_TIME_A::Int16
  LAG_TIME_B::Int16
  DELAY_RECORDING_TIME::Int16
  MUTE_TIME_START::Int16
  MUTE_TIME_END::Int16
  SAMPLES_IN_TRACE::Int16
  SAMPLE_INTERVAL::Int16
  GAIN_TYPE::Int16
  INSTRUMENT_GAIN_CONSTANT::Int16
  INSTRUMENT_INITIAL_GAIN::Int16
  CORRELATED_TRACES::Int16
  SWEEP_FREQ_START::Int16
  SWEEP_FREQ_END::Int16
  SWEEP_LENGTH::Int16
  SWEEP_TYPE::Int16
  SWEEP_TRACE_TAPER_LENGTH_START::Int16
  SWEEP_TRACE_TAPER_LENGTH_END::Int16
  TAPER_TYPE::Int16
  ALIAS_FILTER_FREQ::Int16
  ALIAS_FILTER_SLOPE::Int16
  NOTCH_FILTER_FREQ::Int16
  NOTCH_FILTER_SLOPE::Int16
  LOWCUT_FREQ::Int16
  HIGHCUT_FREQ::Int16
  LOWCUT_SLOPE::Int16
  HIGHCUT_SLOPE::Int16
  YEAR_DATA_RECORDED::Int16
  DAY_OF_YEAR::Int16
  HOUR_OF_DAY::Int16
  MINUTE_OF_HOUR::Int16
  SECOND_OF_MINUTE::Int16
  TIME_BASIS_CODE::Int16
  TRACE_WEIGHTING_FACTOR::Int16
  GROUP_NUMBER_ROW_SWITCH_POS_ONE::Int16
  GROUP_NUMBER_FIRST_TRACE_IN_ORIGINAL_RECORD::Int16
  GROUP_NUMBER_LAST_TRACE_IN_ORIGINAL_RECORD::Int16
  GAP_SIZE::Int16
  TAPER_OVER_TRAVEL::Int16
  ENSEMBLE_X::Int32
  ENSEMBLE_Y::Int32
  INLINE_NUMBER::Int32
  CROSSLINE_NUMBER::Int32
  SHOTPOINT_NUMBER::Int32
  SHOTPOINT_SCALAR::Int16
  TRACE_MEASUREMENT_UNIT::Int16
  TRANSDUCTION_CONSTANT::Int32
  TRANSDUCTION_CONSTANT_EXPONENT::Int16
  TRANSDUCTION_CONSTANT_UNIT::Int16
  DEVICE_NUMBER::Int16
  TIME_SCALAR::Int16
  SOURCE_TYPE_ORIENTATION::Int16
  SOURCE_DIRECTION_VERTICAL::Int16
  SOURCE_DIRECTION_CROSSLINE::Int16
  SOURCE_DIRECTION_INLINE::Int16
  SOURCE_CONSTANT::Int32
  SOURCE_CONSTANT_EXPONENT::Int16
  SOURCE_CONSTANT_UNIT::Int16
end

# write SEG-Y trace header to IO stream
function Base.write(io::IO, header::TraceHeader)
  # write fields of trace header
  for field in fieldnames(TraceHeader)
    write(io, getfield(header, field))
  end

  # write unassigned section (bytes 233 to 240)
  write(io, zeros(UInt8, 8))
end

# display SEG-Y trace header in pretty table format
Base.show(io::IO, header::TraceHeader) = prettyheader(io, header, "SEG-Y Trace Header")
