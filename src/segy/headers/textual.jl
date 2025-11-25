# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    textualheader(fname::AbstractString) -> String

Read the SEG-Y textual header from the file `fname`.
"""
textualheader(fname::AbstractString) = open(textualheader, fname)

"""
    textualheader(io::IO) -> String

Read the SEG-Y textual header from the IO stream `io`.
"""
function textualheader(io::IO)
  # read first textual header bytes
  bytes = read(seekstart(io), TEXTUAL_HEADER_SIZE)

  # identify encoding from first byte
  # 'C' is 0x43 in ASCII and 0xC3 in EBCDIC
  encoding = first(bytes) == 0x43 ? "ASCII" : "EBCDIC-CP-US"

  # decode bytes with identified encoding
  content = decode(bytes, encoding)

  # return textual header
  TextualHeader(content)
end

# ------------------
# HEADER DEFINITION
# ------------------

"""
    TextualHeader(content)

SEG-Y textual header with string `content`.
"""
struct TextualHeader
  content::String
end

# write SEG-Y textual header to IO stream
Base.write(io::IO, header::TextualHeader) = write(io, encode(header.content, "ASCII"))

# display SEG-Y textual header in pretty format
Base.show(io::IO, header::TextualHeader) = print(io, replace(header.content, r"(C\d+)" => s"\n\1"))
