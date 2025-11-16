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
  # extract sign, exponent, and fraction bits
  b = reinterpret(UInt32, x)
  s = b & 0x80000000
  e = b & 0x7f000000
  f = b & 0x00ffffff

  # if fraction is zero, value is zero
  iszero(f) && return zero(Float64)

  # position sign bit at the leftmost bit of 8 bytes
  sieee = Int64(s) << 32

  # shift exponent bits to the right (3 bytes = 24 bits)
  # and multiply by 4 to convert from base 16 to base 2
  # hence, the resulting shift is 24 - 2 = 22 bits
  eieee = Int64(e >> 22)

  # exponent of 64 in base 16 means 0 in the IBM standard,
  # and exponent of 1023 in base 2 means 0 in the IEEE standard
  # hence, the bias adjustment is 1023 - 4*64 = 767
  eieee += 767

  # shift fraction bits to the left until the leading digit
  # is equal to 1 (normalization), then shift one more bit
  # to the left to ignore the leading 1 (implicit in IEEE)
  shift = leading_zeros(f) - 8 # ignore sign and exponent bits
  fieee = UInt64(f << (shift + 1))
  eieee -= (shift + 1)

  # pad fraction with zeros to the right, and since IEEE
  # uses 52 bits for the fraction and IBM uses 24 bits,
  # we need to shift 52 - 24 = 28 bits to the left
  fieee <<= 28

  # now that the exponent bits have been adjusted, shift
  # them to their final position in the IEEE representation
  eieee <<= 52

  # reinterpret bits as Float64
  reinterpret(Float64, sieee | eieee | fieee)
end

Base.read(io::IO, ::Type{IBMFloat32}) = reinterpret(IBMFloat32, read(io, UInt32))
