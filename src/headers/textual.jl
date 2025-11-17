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
  # identify encoding from first byte
  # 'C' is 0x43 in ASCII and 0xC3 in EBCDIC
  bytes = read(seekstart(io), 3200)
  encoding = first(bytes) == 0x43 ? "ASCII" : "EBCDIC-CP-US"
  decode(bytes, encoding)
end
