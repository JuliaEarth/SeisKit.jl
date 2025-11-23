# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    extendedheaders(fname::AbstractString) -> Vector{ExtendedHeader}
"""
extendedheaders(fname::AbstractString) = open(extendedheaders, fname)

"""
    extendedheaders(io::IO) -> Vector{ExtendedHeader}
"""
function extendedheaders(io::IO)
  # seek start of extended headers
  seek(io, TEXTUAL_HEADER_SIZE + BINARY_HEADER_SIZE)

  # decode extended headers
  headers = String[]
  for _ in 1:nextendedheaders(io)
    # read extended header bytes
    bytes = read(io, EXTENDED_HEADER_SIZE)

    # identify encoding from first byte
    # '(' is 0x28 in ASCII and 0x4D in EBCDIC
    encoding = first(bytes) == 0x28 ? "ASCII" : "EBCDIC-CP-US"

    # decode bytes with identified encoding
    decode(bytes, encoding)
  end

  # return extended headers as strings
  headers
end 
