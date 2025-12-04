# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Segy.Dataset(th, bh, eh, trh, traces)

A struct to hold SEG-Y dataset information,
including headers and traces.
"""
struct Dataset{TraceHeaderVector<:FieldViewable}
  textualheader::TextualHeader
  binaryheader::BinaryHeader
  extendedheaders::Vector{ExtendedHeader}
  traceheaders::TraceHeaderVector
  traces::Vector{Vector{Float64}}
end

"""
    coords(dataset::Dataset) -> Vector{<:CoordRefSystems.CRS}

Retrieve coordinates for all traces in the SEG-Y `dataset`
"""
function coords(dataset::Dataset)
  # retrieve raw coordinates
  xy = rawcoords(dataset)

  CRS = try # to retrieve CRS from headers
    crs(dataset)
  catch # guess CRS from units of raw coordinates
    u = unit(first(first(xy)))
    d = datum(dataset)
    if u == u"m"
      Cartesian{d}
    elseif u == u"°"
      LatLon{d}
    else
      error("Cannot infer CRS from coordinate units: $u")
    end
  end

  # build coordinates
  [CRS(x, y) for (x, y) in xy]
end

"""
    crs(dataset::Dataset) -> Type{<:CoordRefSystems.CRS}

Retrieve coordinate reference system the of the SEG-Y `dataset`.
"""
function crs(dataset::Dataset)
  # TODO: prioritize extended headers when available
  crs(dataset.textualheader)
end

"""
    datum(dataset::Dataset) -> CoordRefSystems.Datum

Retrieve datum of the SEG-Y `dataset`.
"""
function datum(dataset::Dataset)
  # TODO: prioritize extended headers when available
  datum(dataset.textualheader)
end

"""
    rawcoords(dataset::Dataset) -> Vector{Tuple{Quantity, Quantity}}

Retrieve raw coordinates for all traces in the SEG-Y `dataset`.
"""
rawcoords(dataset::Dataset) = rawcoords.(dataset.traceheaders)

# -----------
# IO METHODS
# -----------

# display SEG-Y dataset in pretty format
function Base.summary(io::IO, dataset::Dataset)
  bh = dataset.binaryheader
  major = bh.MAJOR_REVISION_NUMBER
  minor = bh.MINOR_REVISION_NUMBER
  print(io, "SEG-Y Dataset (rev $major.$minor)")
end

Base.show(io::IO, dataset::Dataset) = summary(io, dataset)

function Base.show(io::IO, ::MIME"text/plain", dataset::Dataset)
  trh = dataset.traceheaders
  ilines = trh.INLINE_NUMBER
  xlines = trh.CROSSLINE_NUMBER
  traces = dataset.traces
  ntraces = length(traces)
  tmin, tmax = extrema(length, traces)
  imin, imax = extrema(ilines)
  xmin, xmax = extrema(xlines)
  text(min, max) = min == max ? "$min (fixed)" : "$min ─ $max"
  summary(io, dataset)
  println(io)
  println(io, "├─ Nᵒ traces: ", ntraces)
  println(io, "├─ Nᵒ samples: ", text(tmin, tmax))
  println(io, "├─ Inlines: ", text(imin, imax))
  print(io,   "└─ X-lines: ", text(xmin, xmax))
end
