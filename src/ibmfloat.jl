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

    (-1)^S × (FFFFFFFF|FFFFFFFF|FFFFFFFF) × 16^(EEEEEEE - 64)

If the fraction is zero, the value is zero regardless of the exponent or sign.
"""
primitive type IBMFloat32 <: AbstractFloat 32 end

function convert(::Type{Float32}, x::IBMFloat32)
  # extract 4 bytes from IBMFloat32
  b1, b2, b3, b4 = reinterpret(NTuple{4,UInt8}, x)

  # compute fraction from last 3 bytes
  F = reinterpret(UInt32, (zero(UInt8), b2, b3, b4))

  # if fraction is zero, value is zero
  iszero(F) && return zero(Float32)

  # compute sign from first bit
  S = b1 >> 7 # shift first bit all the way to the right

  # compute exponent from remaining 7 bits
  E = b1 & 0b01111111 # knock out first bit in byte

  Float32((-1)^S * F * 16^(E - 64))
end
