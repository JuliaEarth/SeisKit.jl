# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    gathers(fname::AbstractString[, fields]; lazy=false)

Load SEG-Y gathers from the file `fname` based on the trace header `fields`.
By default, gathers are grouped by the `"ORIGINAL_FIELD_RECORD_NUMBER"`.

Optionally, specify `lazy=true` to load gathers lazily when the file is too
large to fit in memory.
"""
function gathers(fname::AbstractString, fields=(:ORIGINAL_FIELD_RECORD_NUMBER,); lazy=false)
  lazy && error("""
    Cannot load gathers lazily from a file name.

    Please open an IO stream manually with `io = open(fname)`
    and then call `gathers(io, fields; lazy=true)` to load
    gathers lazily.

    After the gathers are consumed through iteration, make
    sure to close the IO stream with `close(io)`.
    """)
  open(io -> gathers(io, fields; lazy), fname)
end

"""
    gathers(io::IO[, fields]; lazy=false)

Load SEG-Y gathers from the IO stream `io` based on the trace header `fields`.
By default, gathers are grouped by the `"ORIGINAL_FIELD_RECORD_NUMBER"`.

Optionally, specify `lazy=true` to load gathers lazily when the file is too
large to fit in memory.
"""
function gathers(io::IO, fields=(:ORIGINAL_FIELD_RECORD_NUMBER,); lazy=false)
  # load all headers from file
  th, bh, eh, trh = headers(io)

  # extract values from trace header fields
  vals = map(trh) do h
    map(f -> getfield(h, Symbol(f)), fields)
  end

  gather = if lazy
    # gather traces lazily from file
    val -> let
      inds = findall(==(val), vals)
      Dataset(th, bh, eh, view(trh, inds), traces(io, trh, inds))
    end
  else
    # load full dataset into memory
    d = Dataset(th, bh, eh, trh, traces(io, trh))

    # gather traces from loaded dataset
    val -> let
      inds = findall(==(val), vals)
      Dataset(th, bh, eh, view(trh, inds), view(d.traces, inds))
    end
  end

  (gather(val) for val in unique(vals))
end

# methods with single field for convenience
gathers(fname::AbstractString, field::AbstractString; lazy=false) = gathers(fname, (field,); lazy)
gathers(fname::AbstractString, field::Symbol; lazy=false) = gathers(fname, (field,); lazy)
gathers(io::IO, field::AbstractString; lazy=false) = gathers(io, (field,); lazy)
gathers(io::IO, field::Symbol; lazy=false) = gathers(io, (field,); lazy)
