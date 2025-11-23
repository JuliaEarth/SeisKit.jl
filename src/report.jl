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
  printheaders(th, bh, eh, trh)
  reportissues(th, bh, eh, trh)
end

function printheaders(th, bh, eh, trh)
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

  # trace header summary (non-zero fields only)
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
    alignment=:l,
  )
end

function reportissues(th, bh, eh, trh)
  issues = String[]

  if bh.TRACE_SORTING_CODE < 1
    push!(issues, """
      - Detected TRACE_SORTING_CODE < 1 in binary header.
        The value should be greater than or equal to 1
        to indicate the type of ensemble stored in the
        file (e.g., pre-stack vs. post-stack).
      """
    )
  end

  if any(iszero, trh.SAMPLES_IN_TRACE)
    push!(issues, """
      - Detected trace headers with SAMPLES_IN_TRACE = 0.
        The value SAMPLES_PER_TRACE from the binary header
        should be copied to all trace headers.
      """
    )
  end

  if bh.FIXED_LENGTH_TRACE_FLAG > 0
    if !allequal(trh.SAMPLES_IN_TRACE)
      push!(issues, """
        - Detected FIXED_LENGTH_TRACE_FLAG > 0 in binary header
          with varying SAMPLES_IN_TRACE in trace headers.
          The flag should be set to 0 to indicate variable
          length traces.
        """
      )
    elseif !all(==(bh.SAMPLES_PER_TRACE), trh.SAMPLES_IN_TRACE)
      push!(issues, """
        - Detected FIXED_LENGTH_TRACE_FLAG > 0 in binary header
          with SAMPLES_IN_TRACE in trace headers different
          from SAMPLES_PER_TRACE in binary header. The value
          SAMPLES_IN_TRACE from trace headers should be copied
          to the binary header.
        """
      )
    end
  end

  for field in keys(binaryoptions)
    value = getfield(bh, field)
    if value ∉ binaryoptions[field]
      push!(issues, """
        - Detected $field = $value in binary header.
          $field should be $(join(binaryoptions[field], ", ", " or ")).
        """
      )
    end
  end

  println()

  if isempty(issues)
    println("No SEG-Y issues detected.")
  else
    println(styled"{red,underline:SEG-Y issues report:}\n")
    println(join((styled"{red:$issue}" for issue in issues), "\n"))
    print(styled"""
      {red:You can fix most of these issues with `SeisKit.save(...)`
      after loading the data with `SeisKit.load(...)`.}
      """
    )
  end
end

# valid options for binary fields
const binaryoptions = Dict(
  :FIXED_LENGTH_TRACE_FLAG => (0, 1)
)
