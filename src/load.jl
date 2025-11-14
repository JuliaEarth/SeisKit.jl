# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

function load(fname::AbstractString)
  open(fname) do io
    load(io)
  end
end

function load(io::IO)
  theader = textualheader(io)
  bheader = binaryheader(io)
end
