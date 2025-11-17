# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# tells the floating point type used for samples in the SEG-Y file
floattype(fname::AbstractString) = open(floattype, fname)

function floattype(io::IO)
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
  elseif code == 2
    Int32
  elseif code == 3
    Int16
  elseif code == 4
    error("""
      4-byte fixed-point with gain is not supported.

      If you really need to load SEG-Y files with this
      data type, please consider submitting a pull request
      to add the FixedPointNumbers.jl package as a dependency
      and replace this error by the appropriate `Fixed` type.
      """
    )
  elseif code == 5
    Float32
  elseif code == 6
    Float64
  elseif code == 7
    error("""
      3-byte signed integer (Int24) is not supported.

      If you really need to load SEG-Y files with this
      data type, please consider submitting a pull request
      to add the BitIntegers.jl package as a dependency and
      replace this error by `Int24`.
      """
    )
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
  elseif code == 15
    error("""
      3-byte unsigned integer (UInt24) is not supported.

      If you really need to load SEG-Y files with this
      data type, please consider submitting a pull request
      to add the BitIntegers.jl package as a dependency and
      replace this error by `UInt24`.
      """
    )
  elseif code == 16
    UInt8
  else
    error("Unexpected sample format code: $code")
  end
end

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
