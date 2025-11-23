# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

function prettyheader(io::IO, header, title)
  field = collect(fieldnames(typeof(header)))
  value = getfield.(Ref(header), field)
  pretty_table(io, (; field, value),
    title=title,
    fit_table_in_display_vertically=false,
    new_line_at_end=false,
    alignment=:l,
  )
end
