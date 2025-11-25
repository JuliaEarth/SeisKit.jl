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
  headers = ExtendedHeader[]
  for _ in 1:nextendedheaders(io)
    # read extended header bytes
    bytes = read(io, EXTENDED_HEADER_SIZE)

    # identify encoding from first byte
    # '(' is 0x28 in ASCII and 0x4D in EBCDIC
    encoding = first(bytes) == 0x28 ? "ASCII" : "EBCDIC-CP-US"

    # decode bytes with identified encoding
    content = decode(bytes, encoding)

    # store extended header
    push!(headers, ExtendedHeader(content))
  end

  # return extended headers
  headers
end

# ------------------
# HEADER DEFINITION
# ------------------

"""
    ExtendnedHeader(content)

SEG-Y extended header with string `content`.
"""
struct ExtendedHeader
  content::String
end

# write SEG-Y extended header to IO stream
Base.write(io::IO, header::ExtendedHeader) = write(io, encode(header.content, "ASCII"))

# display SEG-Y extended header in pretty format
Base.show(io::IO, header::ExtendedHeader) = print(io, header.content)
