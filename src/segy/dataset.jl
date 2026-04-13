# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Segy.Dataset(th, bh, eh, trh, traces)

A struct to hold SEG-Y dataset information,
including headers and traces.
"""
struct Dataset{TraceHeaderVector<:FieldViewable,TraceVector<:AbstractVector}
  textualheader::TextualHeader
  binaryheader::BinaryHeader
  extendedheaders::Vector{ExtendedHeader}
  traceheaders::TraceHeaderVector
  traces::TraceVector
end

"""
    ndims(dataset::Dataset) -> Int

Retrieve the number of dimensions (2D or 3D) of the SEG-Y `dataset`.
"""
function ndims(dataset::Dataset)
  # retrieve inlines and crosslines
  trh = dataset.traceheaders
  ilines = trh.INLINE_NUMBER
  xlines = trh.CROSSLINE_NUMBER

  # check if dataset is 2D or 3D
  nilines = length(unique(ilines))
  nxlines = length(unique(xlines))
  nilines > 1 && nxlines > 1 ? 3 : 2
end

"""
    image(dataset::Dataset) -> Matrix{Float64}

Convert the traces in a 2D SEG-Y `dataset` to an image (i.e., matrix of samples).
"""
function image(dataset::Dataset)
  # make sure dataset is 2D
  ndims(dataset) == 2 || error("Cannot convert 3D SEG-Y dataset to a 2D image")

  # sort traces by their positions
  inds = sortperm(positions(dataset))
  traces = @view dataset.traces[inds]

  # return matrix of samples
  reduce(hcat, traces)
end

"""
    grid(dataset::Dataset; velocity=4000.0) -> Meshes.StructuredGrid

Retrieve structured grid from a 2D SEG-Y `dataset` such that trace
values correspond to grid vertices.

A `velocity` value in m/s can be provided to scale the time/depth axis.
By default, the velocity is set to 4000 m/s (marine sedimentary rock).
"""
function grid(dataset::Dataset; velocity=4000.0)
  # make sure dataset is 2D
  ndims(dataset) == 2 || error("Cannot extract 2D grid from 3D SEG-Y dataset")

  # extract x and y coordinates
  xy = map(sort(positions(dataset))) do p
    c = convert(Cartesian, Meshes.coords(p))
    c.x, c.y
  end
  xs = first.(xy)
  ys = last.(xy)

  # compute z coordinate
  nz = length(first(dataset.traces))
  δz = dataset.binaryheader.SAMPLE_INTERVAL * (velocity / 1e6) * u"m"
  zs = range(0u"m", -δz * nz, length=nz)

  # build coordinate arrays
  X = repeat(transpose(xs), nz, 1)
  Y = repeat(transpose(ys), nz, 1)
  Z = repeat(zs, 1, length(xs))

  # build grid topology
  t = GridTopology((length(zs) - 1, length(xs) - 1))

  # build structured grid
  StructuredGrid((X, Y, Z), t)
end

"""
    segment(dataset::Dataset) -> Meshes.Segment

Retrieve the segment defined by the positions of the traces in a 2D SEG-Y `dataset`.
"""
function segment(dataset::Dataset)
  ndims(dataset) == 2 || error("Cannot extract 2D segment from positions of 3D SEG-Y dataset")
  points = sort(positions(dataset))
  Segment(first(points), last(points))
end

"""
    positions(dataset::Dataset) -> Vector{<:Meshes.Point}

Retrieve positions for all traces in the SEG-Y `dataset`
"""
positions(dataset::Dataset) = map(Point, coords(dataset))

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
  print(io, "└─ X-lines: ", text(xmin, xmax))
end
