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

  # textual header
  println(th)
  println()

  # binary header
  println(bh)
  println()

  # extended headers
  if !isempty(eh)
    foreach(h -> println(h), eh)
  end

  # trace headers (non-zero fields only)
  field = Symbol[]
  minimum = Int[]
  maximum = Int[]
  for name in propertynames(trh)
    min, max = extrema(getproperty(trh, name))
    if !iszero(min)
      push!(field, name)
      push!(minimum, min)
      push!(maximum, max)
    end
  end
  pretty_table((; field, minimum, maximum);
    title="SEG-Y Trace Header Summary (non-zero fields only)",
    fit_table_in_display_vertically=false,
    new_line_at_end=false,
    alignment=:l,
  )
end
