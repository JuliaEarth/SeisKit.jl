# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

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
  read(io, UInt32) != 33620995
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

function numbertype(io::IO)
  # swap bytes if necessary
  swapbytes = isbigendian(io) ? ntoh : ltoh

  # SEG-Y revision 0.0 uses 4-byte IBM floating point
  version(io).major == 0 && return IBMFloat32

  # SEG-Y revision 1.0 introduced the
  # sample format code at bytes 3225-3226
  # to indicate the floating point type:
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
  seek(io, 3224)
  code = swapbytes(read(io, UInt16))
  if code == 1
    IBMFloat32
  elseif code == 5
    Float32
  elseif code == 6
    Float64
  else
    error("Unsupported SEG-Y sample format code: $code")
  end
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
