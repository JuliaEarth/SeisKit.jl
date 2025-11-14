# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

function textualheader(fname::AbstractString)
  open(fname) do io
    textualheader(io)
  end
end

function textualheader(io::IO)
  bytes = read(seekstart(io), 3200)
  decode(bytes, "EBCDIC-CP-US")
end
