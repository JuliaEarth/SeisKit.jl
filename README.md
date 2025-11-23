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

Modern tools written in native Julia for fast IO operations with 
SEG-Y files. The package supports all revisions from the original
1975 standard (rev 0) to the latest 2023 update (rev 2.1).

## Installation

Get the latest stable release with Julia's package manager:

```
] add SeisKit
```

## Usage

## Contributing

Contributions are very welcome. Please [open an issue](https://github.com/JuliaEarth/SeisKit.jl/issues) if you have questions.

## Previous attempts

Packages with similar functionality were written
for older versions of the Julia language:

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