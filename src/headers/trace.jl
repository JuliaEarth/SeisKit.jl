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

  # number type for samples
  ntype = numbertype(io)

  # seek start of trace headers
  seek(io, 3600 + nextendedheaders(io) * 3200)

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

    # skip trace samples
    skip(io, header.NO_SAMPLES_IN_TRACE * sizeof(ntype))

    # save header and continue
    push!(headers, header)
  end

  # return trace headers as vector
  headers
end

# ------------------
# HEADER DEFINITION
# ------------------

"""
    TraceHeader(fields...)

SEG-Y trace header with all `fields` from
revisions 1.0, 2.0, and 2.1 of the standard.
"""
struct TraceHeader
  TRACE_NO_LINE::Int32
  TRACE_NO_FILE::Int32
  ORIGINAL_FIELD_RECORD_NO::Int32
  TRACE_NO_FIELD_RECORD::Int32
  ENERGY_SOURCE_POINT_NO::Int32
  ENSEMBLE_NO::Int32
  TRACE_NO_ENSEMBLE::Int32
  TRACE_ID_CODE::Int16
  NO_VERTICAL_SUM_TRACES::Int16
  NO_HORIZONTAL_SUM_TRACES::Int16
  DATA_USE::Int16
  DISTANCE_SOURCE_RECEIVER::Int32
  RECEIVER_ELEVATION::Int32
  SOURCE_SURFACE_ELEVATION::Int32
  SOURCE_DEPTH_BELOW_SURFACE::Int32
  DATUM_RECEIVER::Int32
  DATUM_SOURCE::Int32
  SOURCE_WATER_DEPTH::Int32
  RECEIVER_WATER_DEPTH::Int32
  ELEVATION_SCALAR::Int16
  COORDINATE_SCALAR::Int16
  SOURCE_X::Int32
  SOURCE_Y::Int32
  RECEIVER_X::Int32
  RECEIVER_Y::Int32
  COORDINATE_UNITS::Int16
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
  NO_SAMPLES_IN_TRACE::Int16
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
  GEOPHONE_NO_ROW_SWITCH_POS_ONE::Int16
  GEOPHONE_NO_FIRST_TRACE_IN_ORIGINAL_RECORD::Int16
  GEOPHONE_NO_LAST_TRACE_IN_ORIGINAL_RECORD::Int16
  GAP_SIZE::Int16
  TAPER_OVER_TRAVEL::Int16
  ENSEMBLE_X::Int32
  ENSEMBLE_Y::Int32
  INLINE_NO::Int32
  CROSSLINE_NO::Int32
  SHOTPOINT_NO::Int32
  SHOTPOINT_SCALAR::Int16
  TRACE_MEASUREMENT_UNIT::Int16
  TRANSDUCTION_CONSTANT::Int32
  TRANSDUCTION_CONSTANT_EXPONENT::Int16
  TRANSDUCTION_CONSTANT_UNIT::Int16
  DEVICE_ID::Int16
  TIME_SCALAR::Int16
  SOURCE_TYPE_ORIENTATION::Int16
  SOURCE_DIRECTION_VERTICAL::Int16
  SOURCE_DIRECTION_CROSSLINE::Int16
  SOURCE_DIRECTION_INLINE::Int16
  SOURCE_CONSTANT::Int32
  SOURCE_CONSTANT_EXPONENT::Int16
  SOURCE_CONSTANT_UNIT::Int16
end

# display SEG-Y trace header in pretty table format
Base.show(io::IO, header::TraceHeader) = prettyheader(io, header, "SEG-Y Trace Header")
