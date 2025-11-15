# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    textualheader(fname::AbstractString) -> String

Extract the SEGY textual header from the file `fname`.
"""
textualheader(fname::AbstractString) = open(textualheader, fname)

"""
    textualheader(io::IO) -> String

Extract the SEGY textual header from the IO stream `io`.
"""
function textualheader(io::IO)
  # decode first 3200 bytes as EBCDIC
  bytes = read(seekstart(io), 3200)
  decode(bytes, "EBCDIC-CP-US")
end
