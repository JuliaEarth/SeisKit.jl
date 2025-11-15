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
  major, minor
end
