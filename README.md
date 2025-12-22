<p align="center">
  <img src="docs/logo.webp" height="200"><br>
  <a href="https://github.com/JuliaEarth/SeisKit.jl/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/JuliaEarth/SeisKit.jl/CI.yml?branch=main&style=flat-square">
  </a>
  <a href="https://codecov.io/gh/JuliaEarth/SeisKit.jl">
    <img src="https://img.shields.io/codecov/c/github/JuliaEarth/SeisKit.jl?style=flat-square">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square">
  </a>
</p>

Fast IO operations with SEG-Y files and other basic utilities for
working with seismic data.

Supports all revisions of the SEG-Y standard from 2002 (rev 1) to
2023 (rev 2.1).

The [SEG technical standards](https://seg.org/publications/seg-technical-standards)
used in the development of this package are:

- [SEG-Y rev 1.0 Data Exchange format, May 2002](https://seg.org/wp-content/uploads/2025/11/seg_y_rev1.pdf)

- [SEG-Y rev 2.0 Data Exchange format, January 2017](https://seg.org/wp-content/uploads/2025/11/seg_y_rev2_0_mar2017.pdf)

- [SEG-Y rev 2.1 Data Exchange format, October 2023](https://seg.org/wp-content/uploads/2025/11/seg_y_rev2_1-oct2023.pdf)

Free registration may be required to access these documents.

## Installation

Get the latest stable release with Julia's package manager:

```
] add SeisKit
```

## Usage

The SEG-Y file format is the most widely used format for storing
seismic data in the industry. It consists of a textual header,
a binary header, optional extended headers, and trace data with
individual trace headers.

The `SeisKit` module exports the `Segy` submodule to work with SEG-Y files:

```julia
julia> using SeisKit
```

### Retrieving SEG-Y headers

All SEG-Y headers can be retrieved with the `Segy.headers` function:

```julia
th, bh, eh, trh = Segy.headers("test/data/stacked2Drev1.sgy")
```

but they can also be retrieved separately:

#### Textual header

```julia
julia> th = Segy.textualheader("test/data/stacked2Drev1.sgy")
```
<details>
<summary>Click to expand output</summary>>
<pre>
C 1 CLIENT                        COMPANY                       CREW NO         C 2 LINE            AREA                        MAP ID                          C 3 REEL NO           DAY-START OF REEL     YEAR      OBSERVER                  C 4 INSTRUMENT: MFG            MODEL            SERIAL NO                       C 5 DATA TRACES/RECORD        AUXILIARY TRACES/RECORD         CDF FOLD          C 6 SAMPLE INTERVAL         SAMPLES/TRACE       BITS/IN     BYTES/SAMPPLE       C 7 RECORDING FORMAT        FORMAT THIS REEL        MEASUREMENT SYSTEM          C 8 SAMPLE CODE: FLOATING PT     FIXED PT     FIXED PT-GAIN     CORRELATED      C 9 GAIN  TYPE: FIXED     BINSRY     FLOATING POINT     OTHER                   
C10 FILTERS: ALIAS     HZ  NOTCH     HZ BAND      -     HZ  SLOPE    -    DB/OCT
C11 SOURCE: TYPE            NUMBER/POINT        POINT INTERVAL                  
C12     PATTERN:                           LENGTH        WIDTH                  
C13 SWEEP: START     HZ END      HZ  LENGTH      MS  CHANNEL NO     TYPE        
C14 TAPER: START LENGTH       MS END LENGTH        MS TYPE                      
C15 SPREAD: OFFSET        MAX DISTANCE        GROUP INTERVAL                    
C16 GEOPHONES: PER GROUP     SPACING     FREQUENCY     MFG          MODEL       
C17     PATTERN:                           LENGTH        WIDTH                  
C18 TRACESSORTED BY: RECORD      CDP     OTHER                                  
C19 AMPLITUDE RECOVRY: NONE       SPHERICAL DIV       AGC    OTHER              
C20 MAP PROJECTION                      ZONE ID       COORDINATE UNITS          
C21 PROCESSING:                                                                 
C22 PROCESSING:                                                                 
C23                                                                             
C24                                                                             
C25                                                                             
C26                                                                             
C27                                                                             
C28                                                                             
C29                                                                             
C30                                                                             
C31                                                                             
C32                                                                             
C33                                                                             
C34                                                                             
C35                                                                             
C36                                                                             
C37                                                                             
C38                                                                             
C39 SEG Y REV1                                                                  
C40 END TEXTUAL HEADER
</pre>
</details>

The textual header has a `th.content` field with the decoded text,
containing all lines C1 to C40. The SEG-Y standard allows both EBCDIC
and ASCII encodings, and SeisKit.jl automatically detects and decodes
the correct format.

#### Binary header

```julia
julia> bh = Segy.binaryheader("test/data/stacked2Drev1.sgy")
```
<details>
<summary>Click to expand output</summary>
<pre>
              SEG-Y Binary Header
┌─────────────────────────────────────┬───────┐
│ field                               │ value │
│ Symbol                              │ Real  │
├─────────────────────────────────────┼───────┤
│ JOB_NUMBER                          │ 0     │
│ LINE_NUMBER                         │ 0     │
│ REEL_NUMBER                         │ 0     │
│ TRACES_PER_ENSEMBLE                 │ 1     │
│ AUX_TRACES_PER_ENSEMBLE             │ 1     │
│ SAMPLE_INTERVAL                     │ 10000 │
│ ORIGINAL_SAMPLE_INTERVAL            │ 0     │
│ SAMPLES_PER_TRACE                   │ 351   │
│ ORIGINAL_SAMPLES_PER_TRACE          │ 351   │
│ SAMPLE_FORMAT_CODE                  │ 1     │
│ ENSEMBLE_FOLD                       │ 1     │
│ TRACE_SORTING_CODE                  │ 4     │
│ VERTICAL_SUM_CODE                   │ 0     │
│ SWEEP_FREQ_START                    │ 0     │
│ SWEEP_FREQ_END                      │ 0     │
│ SWEEP_LENGTH                        │ 0     │
│ SWEEP_TYPE                          │ 4     │
│ TRACE_NUMBER_OF_SWEEP_CHANNEL       │ 0     │
│ SWEEP_TRACE_TAPER_LENGTH_START      │ 0     │
│ SWEEP_TRACE_TAPER_LENGTH_END        │ 0     │
│ TAPER_TYPE                          │ 3     │
│ CORRELATED_TRACES                   │ 1     │
│ BINARY_GAIN_RECOVERED               │ 2     │
│ AMPLITUDE_RECOVERY_METHOD           │ 4     │
│ MEASUREMENT_SYSTEM                  │ 1     │
│ IMPULSE_SIGNAL_POLARITY             │ 0     │
│ VIBRATORY_POLARITY_CODE             │ 0     │
│ EXTENDED_TRACES_PER_ENSEMBLE        │ 0     │
│ EXTENDED_AUX_TRACES_PER_ENSEMBLE    │ 0     │
│ EXTENDED_SAMPLES_PER_TRACE          │ 0     │
│ EXTENDED_SAMPLE_INTERVAL            │ 0.0   │
│ EXTENDED_ORIGINAL_SAMPLE_INTERVAL   │ 0.0   │
│ EXTENDED_ORIGINAL_SAMPLES_PER_TRACE │ 0     │
│ EXTENDED_ENSEMBLE_FOLD              │ 0     │
│ ENDIAN_CONSTANT                     │ 0     │
│ MAJOR_REVISION_NUMBER               │ 1     │
│ MINOR_REVISION_NUMBER               │ 0     │
│ FIXED_LENGTH_TRACE_FLAG             │ 256   │
│ EXTENDED_TEXT_HEADER_COUNT          │ 0     │
│ MAX_EXTENDED_TRACE_HEADERS          │ 0     │
│ SURVEY_TYPE                         │ 0     │
│ TIME_BASIS_CODE                     │ 0     │
│ TRACES_IN_FILE                      │ 0     │
│ FIRST_TRACE_OFFSET                  │ 0     │
│ TRAILER_RECORDS                     │ 0     │
└─────────────────────────────────────┴───────┘
</pre>
</details>

The binary header fields can be accessed directly:

```julia
julia> bh.SAMPLE_INTERVAL # sample interval in microseconds
```
```
0x2710
```

#### Extended headers

```julia
julia> eh = Segy.extendedheaders("test/data/stacked2Drev1.sgy")
```
```
SeisKit.Segy.ExtendedHeader[]
```

The extended headers are rarely used in practice.
They consist of textual headers similar to the main
textual header, but with well-defined formats
(a.k.a. stanzas).

#### Trace headers

```julia
julia> trh = Segy.traceheaders("test/data/stacked2Drev1.sgy")
```
<details>
<summary>Click to expand output</summary>
<pre>
                    SEG-Y Trace Header
┌─────────────────────────────────────────────┬───────────┐
│ field                                       │ value     │
│ Symbol                                      │ Signed    │
├─────────────────────────────────────────────┼───────────┤
│ TRACE_NUMBER_IN_LINE                        │ 1         │
│ TRACE_NUMBER_IN_FILE                        │ 0         │
│ ORIGINAL_FIELD_RECORD_NUMBER                │ 0         │
│ TRACE_NUMBER_IN_ORIGINAL_FIELD_RECORD       │ 0         │
│ ENERGY_SOURCE_POINT_NUMBER                  │ 0         │
│ ENSEMBLE_NUMBER                             │ 0         │
│ TRACE_NUMBER_IN_ENSEMBLE                    │ 0         │
│ TRACE_ID_CODE                               │ 1         │
│ VERTICALLY_SUMMED_TRACES                    │ 0         │
│ HORIZONTALLY_STACKED_TRACES                 │ 0         │
│ DATA_USE                                    │ 1         │
│ DISTANCE_SOURCE_RECEIVER                    │ 0         │
│ RECEIVER_ELEVATION                          │ 0         │
│ SOURCE_SURFACE_ELEVATION                    │ 0         │
│ SOURCE_DEPTH_BELOW_SURFACE                  │ 0         │
│ RECEIVER_DATUM                              │ 0         │
│ SOURCE_DATUM                                │ 0         │
│ SOURCE_WATER_DEPTH                          │ 0         │
│ RECEIVER_WATER_DEPTH                        │ 0         │
│ ELEVATION_SCALAR                            │ 1         │
│ COORDINATE_SCALAR                           │ -100      │
│ SOURCE_X                                    │ 0         │
│ SOURCE_Y                                    │ 0         │
│ RECEIVER_X                                  │ 0         │
│ RECEIVER_Y                                  │ 0         │
│ COORDINATE_UNIT                             │ 1         │
│ WEATHERING_VELOCITY                         │ 0         │
│ SUBWEATHERING_VELOCITY                      │ 0         │
│ SOURCE_UPHOLE_TIME                          │ 0         │
│ RECEIVER_UPHOLE_TIME                        │ 0         │
│ SOURCE_STATIC_CORRECTION                    │ 0         │
│ RECEIVER_STATIC_CORRECTION                  │ 0         │
│ TOTAL_STATIC_CORRECTION                     │ 0         │
│ LAG_TIME_A                                  │ 0         │
│ LAG_TIME_B                                  │ 0         │
│ DELAY_RECORDING_TIME                        │ 0         │
│ MUTE_TIME_START                             │ 0         │
│ MUTE_TIME_END                               │ 0         │
│ SAMPLES_IN_TRACE                            │ 351       │
│ SAMPLE_INTERVAL                             │ 10000     │
│ GAIN_TYPE                                   │ 0         │
│ INSTRUMENT_GAIN_CONSTANT                    │ 0         │
│ INSTRUMENT_INITIAL_GAIN                     │ 0         │
│ CORRELATED_TRACES                           │ 0         │
│ SWEEP_FREQ_START                            │ 0         │
│ SWEEP_FREQ_END                              │ 0         │
│ SWEEP_LENGTH                                │ 0         │
│ SWEEP_TYPE                                  │ 0         │
│ SWEEP_TRACE_TAPER_LENGTH_START              │ 0         │
│ SWEEP_TRACE_TAPER_LENGTH_END                │ 0         │
│ TAPER_TYPE                                  │ 0         │
│ ALIAS_FILTER_FREQ                           │ 0         │
│ ALIAS_FILTER_SLOPE                          │ 0         │
│ NOTCH_FILTER_FREQ                           │ 0         │
│ NOTCH_FILTER_SLOPE                          │ 0         │
│ LOWCUT_FREQ                                 │ 0         │
│ HIGHCUT_FREQ                                │ 0         │
│ LOWCUT_SLOPE                                │ 0         │
│ HIGHCUT_SLOPE                               │ 0         │
│ YEAR_DATA_RECORDED                          │ 0         │
│ DAY_OF_YEAR                                 │ 0         │
│ HOUR_OF_DAY                                 │ 0         │
│ MINUTE_OF_HOUR                              │ 0         │
│ SECOND_OF_MINUTE                            │ 0         │
│ TIME_BASIS_CODE                             │ 0         │
│ TRACE_WEIGHTING_FACTOR                      │ 0         │
│ GROUP_NUMBER_ROW_SWITCH_POS_ONE             │ 0         │
│ GROUP_NUMBER_FIRST_TRACE_IN_ORIGINAL_RECORD │ 0         │
│ GROUP_NUMBER_LAST_TRACE_IN_ORIGINAL_RECORD  │ 0         │
│ GAP_SIZE                                    │ 0         │
│ TAPER_OVER_TRAVEL                           │ 0         │
│ ENSEMBLE_X                                  │ 47320112  │
│ ENSEMBLE_Y                                  │ 719430976 │
│ INLINE_NUMBER                               │ 0         │
│ CROSSLINE_NUMBER                            │ 7200      │
│ SHOTPOINT_NUMBER                            │ 2400      │
│ SHOTPOINT_SCALAR                            │ 0         │
│ TRACE_MEASUREMENT_UNIT                      │ 0         │
│ TRANSDUCTION_CONSTANT                       │ 0         │
│ TRANSDUCTION_CONSTANT_EXPONENT              │ 0         │
│ TRANSDUCTION_CONSTANT_UNIT                  │ 0         │
│ DEVICE_NUMBER                               │ 0         │
│ TIME_SCALAR                                 │ 0         │
│ SOURCE_TYPE_ORIENTATION                     │ 0         │
│ SOURCE_DIRECTION_VERTICAL                   │ 0         │
│ SOURCE_DIRECTION_CROSSLINE                  │ 0         │
│ SOURCE_DIRECTION_INLINE                     │ 0         │
│ SOURCE_CONSTANT                             │ 0         │
│ SOURCE_CONSTANT_EXPONENT                    │ 0         │
│ SOURCE_CONSTANT_UNIT                        │ 0         │
└─────────────────────────────────────────────┴───────────┘
.
.
.
                    SEG-Y Trace Header
┌─────────────────────────────────────────────┬───────────┐
│ field                                       │ value     │
│ Symbol                                      │ Signed    │
├─────────────────────────────────────────────┼───────────┤
│ TRACE_NUMBER_IN_LINE                        │ 7701      │
│ TRACE_NUMBER_IN_FILE                        │ 0         │
│ ORIGINAL_FIELD_RECORD_NUMBER                │ 0         │
│ TRACE_NUMBER_IN_ORIGINAL_FIELD_RECORD       │ 0         │
│ ENERGY_SOURCE_POINT_NUMBER                  │ 0         │
│ ENSEMBLE_NUMBER                             │ 0         │
│ TRACE_NUMBER_IN_ENSEMBLE                    │ 0         │
│ TRACE_ID_CODE                               │ 1         │
│ VERTICALLY_SUMMED_TRACES                    │ 0         │
│ HORIZONTALLY_STACKED_TRACES                 │ 0         │
│ DATA_USE                                    │ 1         │
│ DISTANCE_SOURCE_RECEIVER                    │ 0         │
│ RECEIVER_ELEVATION                          │ 0         │
│ SOURCE_SURFACE_ELEVATION                    │ 0         │
│ SOURCE_DEPTH_BELOW_SURFACE                  │ 0         │
│ RECEIVER_DATUM                              │ 0         │
│ SOURCE_DATUM                                │ 0         │
│ SOURCE_WATER_DEPTH                          │ 0         │
│ RECEIVER_WATER_DEPTH                        │ 0         │
│ ELEVATION_SCALAR                            │ 1         │
│ COORDINATE_SCALAR                           │ -100      │
│ SOURCE_X                                    │ 0         │
│ SOURCE_Y                                    │ 0         │
│ RECEIVER_X                                  │ 0         │
│ RECEIVER_Y                                  │ 0         │
│ COORDINATE_UNIT                             │ 1         │
│ WEATHERING_VELOCITY                         │ 0         │
│ SUBWEATHERING_VELOCITY                      │ 0         │
│ SOURCE_UPHOLE_TIME                          │ 0         │
│ RECEIVER_UPHOLE_TIME                        │ 0         │
│ SOURCE_STATIC_CORRECTION                    │ 0         │
│ RECEIVER_STATIC_CORRECTION                  │ 0         │
│ TOTAL_STATIC_CORRECTION                     │ 0         │
│ LAG_TIME_A                                  │ 0         │
│ LAG_TIME_B                                  │ 0         │
│ DELAY_RECORDING_TIME                        │ 0         │
│ MUTE_TIME_START                             │ 0         │
│ MUTE_TIME_END                               │ 0         │
│ SAMPLES_IN_TRACE                            │ 351       │
│ SAMPLE_INTERVAL                             │ 10000     │
│ GAIN_TYPE                                   │ 0         │
│ INSTRUMENT_GAIN_CONSTANT                    │ 0         │
│ INSTRUMENT_INITIAL_GAIN                     │ 0         │
│ CORRELATED_TRACES                           │ 0         │
│ SWEEP_FREQ_START                            │ 0         │
│ SWEEP_FREQ_END                              │ 0         │
│ SWEEP_LENGTH                                │ 0         │
│ SWEEP_TYPE                                  │ 0         │
│ SWEEP_TRACE_TAPER_LENGTH_START              │ 0         │
│ SWEEP_TRACE_TAPER_LENGTH_END                │ 0         │
│ TAPER_TYPE                                  │ 0         │
│ ALIAS_FILTER_FREQ                           │ 0         │
│ ALIAS_FILTER_SLOPE                          │ 0         │
│ NOTCH_FILTER_FREQ                           │ 0         │
│ NOTCH_FILTER_SLOPE                          │ 0         │
│ LOWCUT_FREQ                                 │ 0         │
│ HIGHCUT_FREQ                                │ 0         │
│ LOWCUT_SLOPE                                │ 0         │
│ HIGHCUT_SLOPE                               │ 0         │
│ YEAR_DATA_RECORDED                          │ 0         │
│ DAY_OF_YEAR                                 │ 0         │
│ HOUR_OF_DAY                                 │ 0         │
│ MINUTE_OF_HOUR                              │ 0         │
│ SECOND_OF_MINUTE                            │ 0         │
│ TIME_BASIS_CODE                             │ 0         │
│ TRACE_WEIGHTING_FACTOR                      │ 0         │
│ GROUP_NUMBER_ROW_SWITCH_POS_ONE             │ 0         │
│ GROUP_NUMBER_FIRST_TRACE_IN_ORIGINAL_RECORD │ 0         │
│ GROUP_NUMBER_LAST_TRACE_IN_ORIGINAL_RECORD  │ 0         │
│ GAP_SIZE                                    │ 0         │
│ TAPER_OVER_TRAVEL                           │ 0         │
│ ENSEMBLE_X                                  │ 46642304  │
│ ENSEMBLE_Y                                  │ 719775424 │
│ INLINE_NUMBER                               │ 0         │
│ CROSSLINE_NUMBER                            │ 7500      │
│ SHOTPOINT_NUMBER                            │ 2500      │
│ SHOTPOINT_SCALAR                            │ 0         │
│ TRACE_MEASUREMENT_UNIT                      │ 0         │
│ TRANSDUCTION_CONSTANT                       │ 0         │
│ TRANSDUCTION_CONSTANT_EXPONENT              │ 0         │
│ TRANSDUCTION_CONSTANT_UNIT                  │ 0         │
│ DEVICE_NUMBER                               │ 0         │
│ TIME_SCALAR                                 │ 0         │
│ SOURCE_TYPE_ORIENTATION                     │ 0         │
│ SOURCE_DIRECTION_VERTICAL                   │ 0         │
│ SOURCE_DIRECTION_CROSSLINE                  │ 0         │
│ SOURCE_DIRECTION_INLINE                     │ 0         │
│ SOURCE_CONSTANT                             │ 0         │
│ SOURCE_CONSTANT_EXPONENT                    │ 0         │
│ SOURCE_CONSTANT_UNIT                        │ 0         │
└─────────────────────────────────────────────┴───────────┘
</pre>
</details>

The trace headers are stored in a vector-like data structure
that allows easy access to individual fields without unnecessary
memory copies:

```julia
julia> trh.ENSEMBLE_X # vector of ensemble x coordinates
```
```
7701-element FieldViews.FieldView{:ENSEMBLE_X, Int32, 1, SeisKit.Segy.TraceHeader, Vector{SeisKit.Segy.TraceHeader}}:
 47320112
 47320864
 47321616
 47322364
 47323116
 47323868
 47324620
        ⋮
 46637800
 46638552
 46639300
 46640052
 46640804
 46641552
 46642304
```

```julia
julia> trh[1].CROSSLINE_NUMBER # crossline number of the first trace
```
```
7200
```

### Retrieving SEG-Y traces

The actual seismic data can be retrieved with the `Segy.load`
function. It calls `Segy.headers` and then `Segy.traces`
to read the data efficiently into Julia arrays:

```julia
julia> seismic = Segy.load("test/data/stacked2Drev1.sgy")
```
```
SEG-Y Dataset (rev 1.0)
├─ Nᵒ traces: 7701
├─ Nᵒ samples: 351 (fixed)
├─ Inlines: 0 (fixed)
└─ X-lines: 7200 ─ 7500
```

The arrays are stored in the `seismic.traces` field. The `Segy.save`
function can be used to write the data back to a file that is compliant
with SEG-Y rev 2.1:

```julia
julia> Segy.save("path/to/newfile.sgy", seismic)
```

We do not support saving in older revisions because:

> The SEG Technical Standards Committee strongly
> encourages producers and users of SEG-Y data sets
> to move to the revised (2.1) standard in an
> expeditious fashion.

### Retrieving trace positions

The trace positions can be retrieved with the `Segy.positions` function.
The package automatically detects the coordinate reference system (CRS)
using various heuristics. If no CRS is found, the function returns a generic
Cartesian system with units in meters.

```julia
julia> Segy.positions(seismic)
```
<details>
<summary>Click to expand output</summary>
<pre>
7701-element Vector{Meshes.Point{Meshes.𝔼{2}, CoordRefSystems.Cartesian2D{CoordRefSystems.WGS84Latest, Unitful.Quantity{Float64, 𝐋, Unitful.FreeUnits{(m,), 𝐋, nothing}}}}}:
 Point(x: 473201.12 m, y: 7.19430976e6 m)
 Point(x: 473208.64 m, y: 7.1943328e6 m)
 Point(x: 473216.16 m, y: 7.19435712e6 m)
 Point(x: 473223.64 m, y: 7.1943808e6 m)
 Point(x: 473231.16 m, y: 7.19440448e6 m)
 Point(x: 473238.68 m, y: 7.1944288e6 m)
 ⋮
 Point(x: 466385.52 m, y: 7.1976352e6 m)
 Point(x: 466393.0 m, y: 7.19765888e6 m)
 Point(x: 466400.52 m, y: 7.19768256e6 m)
 Point(x: 466408.04 m, y: 7.19770624e6 m)
 Point(x: 466415.52 m, y: 7.19773056e6 m)
 Point(x: 466423.04 m, y: 7.19775424e6 m)
</pre>
</details>

### Converting to an image

In the case of 2D seismic with fixed-length traces (e.g., 2D post-stack),
it is often useful to place the traces side by side to form an image.
For that, we provide the `Segy.matrix` and `Segy.image` functions.

The `Segy.matrix` function sorts the traces based on their positions,
and returns a simple 2D array (i.e., matrix) without geospatial information:

```julia
julia> Segy.matrix(seismic)
```
<details>
<summary>Click to expand output</summary>
<pre>
351×7701 Matrix{Float64}:
 1496.38  1496.4   1496.4   1496.39  1496.37  1496.36  1496.37  1496.39  1496.42  …  1497.82  1497.72  1497.51  1497.05  1496.64  1496.29  1495.98  1495.73
 1496.38  1496.4   1496.4   1496.39  1496.37  1496.36  1496.37  1496.39  1496.42     1497.82  1497.72  1497.51  1497.05  1496.64  1496.29  1495.98  1495.73
 1493.5   1493.51  1493.5   1493.49  1493.46  1493.44  1493.44  1493.45  1493.47     1494.6   1494.51  1494.33  1493.94  1493.59  1493.29  1493.03  1492.81
 1490.57  1490.57  1490.55  1490.53  1490.5   1490.47  1490.46  1490.46  1490.46     1491.32  1491.24  1491.09  1490.77  1490.49  1490.24  1490.03  1489.85
 1487.21  1487.19  1487.16  1487.13  1487.1   1487.06  1487.04  1487.02  1487.01     1487.55  1487.48  1487.36  1487.12  1486.91  1486.73  1486.56  1486.42
 1484.38  1484.35  1484.31  1484.27  1484.23  1484.19  1484.16  1484.13  1484.1   …  1484.84  1484.78  1484.68  1484.5   1484.35  1484.21  1484.09  1483.99
 1483.24  1483.19  1483.15  1483.11  1483.08  1483.05  1483.01  1482.96  1482.91     1484.61  1484.56  1484.47  1484.36  1484.26  1484.18  1484.11  1484.06
 1485.9   1485.84  1485.8   1485.77  1485.76  1485.74  1485.69  1485.64  1485.57     1487.23  1487.18  1487.12  1487.09  1487.07  1487.05  1487.05  1487.05
    ⋮                                            ⋮                                ⋱                       ⋮                                            ⋮
 4306.74  4310.65  4315.24  4319.14  4324.03  4326.27  4321.0   4318.07  4317.0      4122.27  4122.17  4122.27  4122.27  4122.27  4122.27  4122.17  4122.07
 4140.14  4140.73  4141.51  4142.19  4142.88  4143.07  4142.19  4141.61  4141.7      4122.27  4122.46  4122.56  4122.56  4122.66  4122.56  4122.56  4122.37
 4135.45  4135.84  4136.33  4136.62  4137.11  4137.41  4137.41  4137.5   4137.6   …  4118.46  4118.66  4118.75  4118.75  4118.56  4118.56  4118.27  4118.17
 4134.87  4135.65  4136.23  4137.11  4137.8   4138.29  4138.19  4138.19  4138.29     4121.88  4121.78  4121.78  4121.88  4122.17  4122.27  4122.46  4122.46
 4137.6   4137.99  4138.48  4138.97  4139.75  4140.04  4140.14  4140.14  4140.14     4134.67  4133.99  4133.3   4133.3   4133.4   4134.18  4134.87  4135.65
 4143.17  4142.29  4141.51  4140.63  4139.75  4139.26  4139.26  4139.36  4139.46     4278.62  4274.52  4272.37  4277.05  4281.84  4286.14  4290.73  4294.83
 4147.07  4145.41  4143.66  4141.9   4140.04  4139.16  4139.16  4139.26  4139.36     4382.23  4381.84  4382.33  4384.18  4386.14  4387.11  4388.48  4389.85
 4146.59  4145.22  4143.95  4142.58  4141.12  4140.04  4140.04  4139.95  4139.95  …  4579.3   4575.69  4570.8   4573.44  4576.57  4579.01  4582.43  4583.4
</pre>
</details>

The `Segy.image` function performs the additional step of georeferencing
the matrix over a structured grid, returning a `GeoTable` object:

```julia
julia> img = Segy.image(seismic)
```
<details>
<summary>Click to expand output</summary>
<pre>
                                          2695000×2 GeoTable over 350×7700 StructuredGrid
┌────────────┬─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│   signal   │                                                      geometry                                                       │
│ Continuous │                                                     Quadrangle                                                      │
│ [NoUnits]  │                                                � Cartesian{NoDatum}                                                 │
├────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  1497.87   │       Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 0.0 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 0.0 m))       │
│  1497.87   │   Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 55694.7 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 55694.7 m))   │
│  1494.58   │ Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 1.11389e5 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 1.11389e5 m)) │
│  1491.23   │  Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 167084.0 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 167084.0 m))  │
│  1487.38   │ Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 2.22779e5 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 2.22779e5 m)) │
│  1484.58   │ Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 2.78473e5 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 2.78473e5 m)) │
│  1484.19   │  Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 334168.0 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 334168.0 m))  │
│  1486.54   │ Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 3.89863e5 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 3.89863e5 m)) │
│  1488.79   │ Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 4.45557e5 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 4.45557e5 m)) │
│  1491.16   │ Quadrangle((x: 4.66048e5 m, y: 7.19656e6 m, z: 5.01252e5 m), ..., (x: 4.66055e5 m, y: 7.19659e6 m, z: 5.01252e5 m)) │
│     ⋮      │                                                          ⋮                                                          │
└────────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
                                                                                                                2694990 rows omitted
</pre>
</details>

An optional `velocity` value can be provided to scale the time/depth axis.
By default, the velocity is set to `1500` m/s (typical for water).

```julia

### Troubleshooting

We provide the `Segy.report` function to report header information
and highlight issues with SEG-Y files. It can be useful to spot files
that are not compliant with the standard, and to anticipate potential
problems when loading the data:

```julia
julia> Segy.report("test/data/stacked2Drev1.sgy")
```
<details>
<summary>Click to expand output</summary>
<pre>
C 1 CLIENT                        COMPANY                       CREW NO         C 2 LINE            AREA                        MAP ID                          C 3 REEL NO           DAY-START OF REEL     YEAR      OBSERVER                  C 4 INSTRUMENT: MFG            MODEL            SERIAL NO                       C 5 DATA TRACES/RECORD        AUXILIARY TRACES/RECORD         CDF FOLD          C 6 SAMPLE INTERVAL         SAMPLES/TRACE       BITS/IN     BYTES/SAMPPLE       C 7 RECORDING FORMAT        FORMAT THIS REEL        MEASUREMENT SYSTEM          C 8 SAMPLE CODE: FLOATING PT     FIXED PT     FIXED PT-GAIN     CORRELATED      C 9 GAIN  TYPE: FIXED     BINSRY     FLOATING POINT     OTHER                   
C10 FILTERS: ALIAS     HZ  NOTCH     HZ BAND      -     HZ  SLOPE    -    DB/OCT
C11 SOURCE: TYPE            NUMBER/POINT        POINT INTERVAL                  
C12     PATTERN:                           LENGTH        WIDTH                  
C13 SWEEP: START     HZ END      HZ  LENGTH      MS  CHANNEL NO     TYPE        
C14 TAPER: START LENGTH       MS END LENGTH        MS TYPE                      
C15 SPREAD: OFFSET        MAX DISTANCE        GROUP INTERVAL                    
C16 GEOPHONES: PER GROUP     SPACING     FREQUENCY     MFG          MODEL       
C17     PATTERN:                           LENGTH        WIDTH                  
C18 TRACESSORTED BY: RECORD      CDP     OTHER                                  
C19 AMPLITUDE RECOVRY: NONE       SPHERICAL DIV       AGC    OTHER              
C20 MAP PROJECTION                      ZONE ID       COORDINATE UNITS          
C21 PROCESSING:                                                                 
C22 PROCESSING:                                                                 
C23                                                                             
C24                                                                             
C25                                                                             
C26                                                                             
C27                                                                             
C28                                                                             
C29                                                                             
C30                                                                             
C31                                                                             
C32                                                                             
C33                                                                             
C34                                                                             
C35                                                                             
C36                                                                             
C37                                                                             
C38                                                                             
C39 SEG Y REV1                                                                  
C40 END TEXTUAL HEADER                                                          

              SEG-Y Binary Header
┌─────────────────────────────────────┬───────┐
│ field                               │ value │
│ Symbol                              │ Real  │
├─────────────────────────────────────┼───────┤
│ JOB_NUMBER                          │ 0     │
│ LINE_NUMBER                         │ 0     │
│ REEL_NUMBER                         │ 0     │
│ TRACES_PER_ENSEMBLE                 │ 1     │
│ AUX_TRACES_PER_ENSEMBLE             │ 1     │
│ SAMPLE_INTERVAL                     │ 10000 │
│ ORIGINAL_SAMPLE_INTERVAL            │ 0     │
│ SAMPLES_PER_TRACE                   │ 351   │
│ ORIGINAL_SAMPLES_PER_TRACE          │ 351   │
│ SAMPLE_FORMAT_CODE                  │ 1     │
│ ENSEMBLE_FOLD                       │ 1     │
│ TRACE_SORTING_CODE                  │ 4     │
│ VERTICAL_SUM_CODE                   │ 0     │
│ SWEEP_FREQ_START                    │ 0     │
│ SWEEP_FREQ_END                      │ 0     │
│ SWEEP_LENGTH                        │ 0     │
│ SWEEP_TYPE                          │ 4     │
│ TRACE_NUMBER_OF_SWEEP_CHANNEL       │ 0     │
│ SWEEP_TRACE_TAPER_LENGTH_START      │ 0     │
│ SWEEP_TRACE_TAPER_LENGTH_END        │ 0     │
│ TAPER_TYPE                          │ 3     │
│ CORRELATED_TRACES                   │ 1     │
│ BINARY_GAIN_RECOVERED               │ 2     │
│ AMPLITUDE_RECOVERY_METHOD           │ 4     │
│ MEASUREMENT_SYSTEM                  │ 1     │
│ IMPULSE_SIGNAL_POLARITY             │ 0     │
│ VIBRATORY_POLARITY_CODE             │ 0     │
│ EXTENDED_TRACES_PER_ENSEMBLE        │ 0     │
│ EXTENDED_AUX_TRACES_PER_ENSEMBLE    │ 0     │
│ EXTENDED_SAMPLES_PER_TRACE          │ 0     │
│ EXTENDED_SAMPLE_INTERVAL            │ 0.0   │
│ EXTENDED_ORIGINAL_SAMPLE_INTERVAL   │ 0.0   │
│ EXTENDED_ORIGINAL_SAMPLES_PER_TRACE │ 0     │
│ EXTENDED_ENSEMBLE_FOLD              │ 0     │
│ ENDIAN_CONSTANT                     │ 0     │
│ MAJOR_REVISION_NUMBER               │ 1     │
│ MINOR_REVISION_NUMBER               │ 0     │
│ FIXED_LENGTH_TRACE_FLAG             │ 256   │
│ EXTENDED_TEXT_HEADER_COUNT          │ 0     │
│ MAX_EXTENDED_TRACE_HEADERS          │ 0     │
│ SURVEY_TYPE                         │ 0     │
│ TIME_BASIS_CODE                     │ 0     │
│ TRACES_IN_FILE                      │ 0     │
│ FIRST_TRACE_OFFSET                  │ 0     │
│ TRAILER_RECORDS                     │ 0     │
└─────────────────────────────────────┴───────┘

SEG-Y Trace Header Summary (non-zero fields only)
┌──────────────────────┬───────────┬───────────┐
│ field                │ minimum   │ maximum   │
│ Symbol               │ Int64     │ Int64     │
├──────────────────────┼───────────┼───────────┤
│ TRACE_NUMBER_IN_LINE │ 1         │ 7701      │
│ TRACE_ID_CODE        │ 1         │ 1         │
│ DATA_USE             │ 1         │ 1         │
│ ELEVATION_SCALAR     │ 1         │ 1         │
│ COORDINATE_SCALAR    │ -100      │ -100      │
│ COORDINATE_UNIT      │ 1         │ 1         │
│ SAMPLES_IN_TRACE     │ 351       │ 351       │
│ SAMPLE_INTERVAL      │ 10000     │ 10000     │
│ ENSEMBLE_X           │ 46604756  │ 47357660  │
│ ENSEMBLE_Y           │ 719430976 │ 719775424 │
│ CROSSLINE_NUMBER     │ 7200      │ 7500      │
│ SHOTPOINT_NUMBER     │ 2400      │ 2500      │
└──────────────────────┴───────────┴───────────┘

SEG-Y issues report:

- Detected FIXED_LENGTH_TRACE_FLAG = 256 in binary header.
  FIXED_LENGTH_TRACE_FLAG should be 0 or 1.

You can fix most of these issues with `Segy.save(...)`
after loading the data with `Segy.load(...)`.
</pre>
</details>

If `Segy.report` shows issues that you want to fix manually,
you can modify the `Segy.headers`, create a `Segy.Dataset`
with the modified headers and traces, and then save it with
`Segy.save`. The `Segy.save` function fixes most issues found
in the headers using the `Segy.fixissues` function before
writing the new file in SEG-Y rev 2.1.

Please consult the docstrings of all these functions for more details.

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
