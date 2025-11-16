# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    IBMFloat32 <: AbstractFloat

32-bit (4-byte) IBM floating point number type (a.k.a. IBM HFP).
See https://en.wikipedia.org/wiki/IBM_hexadecimal_floating-point.

The 4 bytes stored in the type are organized as follows:

[S | EEEEEEE | FFFFFFFF | FFFFFFFF | FFFFFFFF]

S is the sign bit, EEEEEEE is the 7-bit exponent (base 16, excess-64),
and FFFFFFFF (x3) are the 24 bits (3 bytes) of the fraction.

If S = 1, the number is negative; if S = 0, the number is positive.

The value represented is given by

    (-1)^S × 0.(FFFFFFFF|FFFFFFFF|FFFFFFFF) × 16^(EEEEEEE - 64)

If the fraction is zero, the value is zero regardless of the exponent.
"""
primitive type IBMFloat32 <: AbstractFloat 32 end

function Base.convert(::Type{Float64}, x::IBMFloat32)
  b = reinterpret(UInt32, x)
  s = b & 0x80000000
  e = b & 0x7f000000
  f = b & 0x00ffffff

  # if fraction is zero, value is zero
  iszero(f) && return zero(Float64)

  # shift sign bit to the rightmost position
  sieee = Int64(s >> 31)

  # shift exponent bits to the right (3 bytes = 24 bits)
  # and multiply by 4 to convert from base 16 to base 2
  # hence, the resulting shift is 24 - 2 = 22 bits
  eieee = Int64(e >> 22)

  # normalize fraction until the leading digit is equal to 1,
  # and adjust the exponent accordingly (opposite shift)
  d = f & 0x00f00000
  while iszero(d)
    f <<= 4
    eieee -= 4
    d = f & 0x00f00000
  end
  fieee = UInt64(f) << 32 # pad with zeros to the right

  # what is the correct way to combine the parts into Float64?
  sieee, eieee, fieee
end

Base.read(io::IO, ::Type{IBMFloat32}) = reinterpret(IBMFloat32, read(io, UInt32))
