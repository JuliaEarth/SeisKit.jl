# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# endianness constants
const BIG_ENDIAN = 67305985
const LITTLE_ENDIAN = 33620995

# IEEE floating point constants
const IEEE_FLOAT32 = 5
const IEEE_FLOAT64 = 6

# tells whether the SEG-Y file is big-endian
isbigendian(fname::AbstractString) = open(isbigendian, fname)

function isbigendian(io::IO)
  # SEG-Y revision ≤ 1.0 files are always big-endian.
  # SEG-Y revision ≥ 2.0 introduced a constant from
  # byte 3297 to 3300 to indicate the endianness.
  # If the constant is different than 33620995,
  # the file is not little-endian. Hence, we can
  # conclude that it is big-endian, regardless of
  # the SEG-Y revision.
  seek(io, 3296)
  read(io, UInt32) != LITTLE_ENDIAN
end

# SEG-Y major and minor version
version(fname::AbstractString) = open(version, fname)

function version(io::IO)
  # SEG-Y revision ≥ 2.0 introduced the version number
  # at bytes 3501 (major) and 3502 (minor).
  seek(io, 3500)
  major = read(io, UInt8)
  minor = read(io, UInt8)
  (; major, minor)
end

# number of extended headers in the SEG-Y file
nextendedheaders(fname::AbstractString) = open(nextendedheaders, fname)

function nextendedheaders(io::IO)
  # SEG-Y revision ≥ 1.0 introduced the number of
  # extended headers from byte 3505 to byte 3506.
  seek(io, 3504)
  read(io, UInt16)
end

# tells the number type used for samples in the SEG-Y file
numbertype(fname::AbstractString) = open(numbertype, fname)

numbertype(io::IO) = unwrap(_numbertype(io))

function _numbertype(io::IO)
  # swap bytes if necessary
  swapbytes = isbigendian(io) ? ntoh : ltoh

  # get the SEG-Y major version for validations
  majorversion = version(io).major

  # SEG-Y revision 1.0 introduced the
  # sample format code at bytes 3225-3226
  # to indicate the floating point type
  seek(io, 3224)
  code = swapbytes(read(io, UInt16))

  # SEG-Y revision 0.0 does not support
  # sample format code, so we must emit
  # a warning if the code is not null
  # or 1 (4-byte IBM floating point)
  if majorversion == 0 && code > 1
    @warn "SEG-Y revision 0.0 files must use 4-byte IBM floating point (code 1)"
  end

  # SEG-Y revision 2.0 introduced more
  # sample format codes, so we must emit
  # a warning if the code is not supported
  # by older revisions of the standard
  if majorversion < 2 && code ∈ (6, 7, 9, 10, 11, 12, 15, 16)
    @warn "SEG-Y revision $majorversion.0 files do not support sample format code $code"
  end

  # number type for the sample format code
  NumberType(_code2type(code))
end

numbertype(code::UInt16) = unwrap(_numbertype(code))

_numbertype(code::UInt16) = NumberType(_code2type(code))

function _code2type(code)
  # 1: 4-byte IBM floating point
  # 2: 4-byte, twos's complement integer
  # 3: 2-byte, twos's complement integer
  # 4: 4-byte fixed-point with gain (obsolete)
  # 5: 4-byte IEEE floating point
  # 6: 8-byte IEEE floating point (since revision 2.0)
  # 7: 3-byte, twos's complement integer (since revision 2.0)
  # 8: 1-byte, twos's complement integer
  # 9: 8-byte, twos's complement integer (since revision 2.0)
  # 10: 4-byte, unsigned integer (since revision 2.0)
  # 11: 2-byte, unsigned integer (since revision 2.0)
  # 12: 8-byte, unsigned integer (since revision 2.0)
  # 15: 3-byte, unsigned integer (since revision 2.0)
  # 16: 1-byte, unsigned integer (since revision 2.0)
  if code == 1
    IBMFloat32
  elseif code == 2
    Int32
  elseif code == 3
    Int16
  elseif code == 5
    Float32
  elseif code == 6
    Float64
  elseif code == 8
    Int8
  elseif code == 9
    Int64
  elseif code == 10
    UInt32
  elseif code == 11
    UInt16
  elseif code == 12
    UInt64
  elseif code == 16
    UInt8
  else
    error("""
      Unsupported SEG-Y sample format code: $code

      If you need support for fixed-point numbers
      or 3-byte integers, please open an issue.

      The Julia packages FixedPointNumbers.jl and
      BitIntegers.jl could be added as dependencies
      to implement this support.
      """)
  end
end

# wrapped union to avoid performance issues
# with large number of types at runtime
@wrapped struct NumberType <: WrappedUnion
  union::Union{
    Type{IBMFloat32},
    Type{Int32},
    Type{Int16},
    Type{Float32},
    Type{Float64},
    Type{Int8},
    Type{Int64},
    Type{UInt32},
    Type{UInt16},
    Type{UInt64},
    Type{UInt8}
  }
end

# tells the ensemble type used in the SEG-Y file
ensembletype(fname::AbstractString) = open(ensembletype, fname)

function ensembletype(io::IO)
  # swap bytes if necessary
  swapbytes = isbigendian(io) ? ntoh : ltoh

  # SEG-Y revision ≥ 1.0 introduced the
  # trace sorting code at bytes 3229-3230
  # to indicate the ensemble type:
  # -1: other (should be specified in extended textual header stanza)
  # 0: unknown sorting
  # 1: as recorded (no sorting)
  # 2: common depth point
  # 3: single fold continuous profile
  # 4: horizontally stacked
  # 5: common source point
  # 6: common receiver point
  # 7: common offset point
  # 8: common mid-point
  # 9: common conversion point
  seek(io, 3228)
  code = swapbytes(read(io, Int16))
  if code == 1
    :RAW
  elseif code == 2
    :CDP
  elseif code == 3
    :SINGLEFOLD
  elseif code == 4
    :STACKED
  elseif code == 5
    :CSP
  elseif code == 6
    :CRP
  elseif code == 7
    :COP
  elseif code == 8
    :CMP
  elseif code == 9
    :CCP
  elseif code == 0
    :UNKNOWN
  elseif code == -1
    :OTHER
  else
    error("Unexpected trace sorting code: $code")
  end
end

# number of samples per trace in the SEG-Y binary header
samplespertrace(fname::AbstractString) = open(samplespertrace, fname)

function samplespertrace(io::IO)
  # swap bytes if necessary
  swapbytes = isbigendian(io) ? ntoh : ltoh

  # SEG-Y revision ≥ 1.0 introduced the number
  # of samples per trace at bytes 3221-3222
  seek(io, 3220)
  swapbytes(read(io, UInt16))
end
