<p align="center">
  <img src="docs/logo.webp" height="200"><br>
  <a href="https://github.com/JuliaEarth/SeisKit.jl/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/JuliaEarth/SeisKit.jl/CI.yml?branch=master&style=flat-square">
  </a>
  <a href="https://codecov.io/gh/JuliaEarth/SeisKit.jl">
    <img src="https://img.shields.io/codecov/c/github/JuliaEarth/SeisKit.jl?style=flat-square">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square">
  </a>
</p>

Fast IO operations with SEG-Y files and other basic utilities for
seismic data.

Supports all revisions of the SEG-Y standard from 1975 (rev 0) to
2023 (rev 2.1).

The [SEG technical standards](https://library.seg.org/seg-technical-standards) used in the development of this
package are:

- [SEG-Y rev 1.0 Data Exchange format, May 2002](https://library.seg.org/pb-assets/technical-standards/seg_y_rev1-1686080991247.pdf)

- [SEG-Y rev 2.0 Data Exchange format, January 2017](https://library.seg.org/pb-assets/technical-standards/seg_y_rev2_0-mar2017-1686080998003.pdf)

- [SEG-Y rev 2.1 Data Exchange format, October 2023](https://library.seg.org/pb-assets/technical-standards/seg_y_rev2_1-oct2023-1701361639333.pdf)

## Installation

Get the latest stable release with Julia's package manager:

```
] add SeisKit
```

## Usage

We provide the `SeisKit.report` function to report header information
and highlight issues with SEG-Y files. It can be useful to spot files
that are not compliant with the standard, and to anticipate potential
problems when loading the data:

```julia
using SeisKit

SeisKit.report("path/to/file.sgy")
```

To actually get the headers for further processing, we provide specific
functions described below.

### Headers

All headers can be retrieved at once with the `SeisKit.headers` function:

```julia
th, bh, eh, trh = SeisKit.headers("path/to/file.sgy")
```

Or individually with dedicated functions:

#### Textual header

```julia
th = SeisKit.textualheader("path/to/file.sgy")
```

The textual header has a `th.content` field with the decoded text,
containing all lines C1 to C40. The SEG-Y standard allows both EBCDIC
and ASCII encodings, and SeisKit.jl automatically detects and decodes
the correct format.

#### Binary header

```julia
bh = SeisKit.binaryheader("path/to/file.sgy")
```

The binary header fields can be accessed directly:

```julia
bh.SAMPLE_INTERVAL # sample interval in microseconds
```

#### Extended headers

```julia
eh = SeisKit.extendedheaders("path/to/file.sgy")
```

The extended headers are rarely used in practice.
They consist of textual headers similar to the main
textual header, but with well-defined formats
(a.k.a. stanzas).

#### Trace headers

```julia
trh = SeisKit.traceheaders("path/to/file.sgy")
```

The trace headers are stored in a vector-like data structure
that allows easy access to individual fields without unnecessary
memory copies:

```julia
trh.ENSEMBLE_X # vector of ensemble x coordinates

trh[1].CROSSLINE_NUMBER # crossline number of the first trace
```

### Traces

The actual seismic data can be retrieved with the `SeisKit.load`
function. It calls `SeisKit.headers` and then `SeisKit.traces`
to read the data efficiently into Julia arrays:

```julia
seismic = SeisKit.load("path/to/file.sgy")
```

The array is stored in the `seismic.data` field. The `SeisKit.save`
function can be used to write the data back to a SEG-Y file that is
compliant with the rev 2.1 standard:

```julia
SeisKit.save("path/to/new_file.sgy", seismic)
```

We do not support saving in older revisions because:

> The SEG Technical Standards Committee strongly
> encourages producers and users of SEG-Y data sets
> to move to the revised (2.1) standard in an
> expeditious fashion.

The `SeisKit.save` function will fix any issues found in the headers
with `SeisKit.fixissues` before writing the new file. Please consult
the docstrings of all these functions for more details.

## Contributing

Contributions are very welcome. Please [open an issue](https://github.com/JuliaEarth/SeisKit.jl/issues) if you have questions.

## Previous attempts

Packages with similar functionality were written
for older versions of the language:

- [SegyIO.jl](https://github.com/slimgroup/SegyIO.jl)
  provides read/write functions for SEG-Y rev 1 that
  are ~1.5x slower than SeisKit.jl on average. That
  is because SeisKit.jl adopted more idiomatic Julia
  coding styles and optimized IO operations more
  aggressively.

- [SeisIO.jl](https://github.com/jpjones76/SeisIO.jl)
  provides tools for SEG-Y rev 0 and rev 1 files, and
  other seismic data formats. However, it is not
  actively maintained anymore, and has too many
  unnecessary dependencies for an IO package.