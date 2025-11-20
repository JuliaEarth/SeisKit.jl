# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    report(fname::AbstractString)

Report SEG-Y information from the file `fname`.
"""
report(fname::AbstractString) = open(report, fname)

"""
    report(io::IO)

Report SEG-Y information from the IO stream `io`.
"""
function report(io::IO)
  th, bh, eh, trh = headers(io)
end
