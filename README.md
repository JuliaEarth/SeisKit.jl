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

Supports all revisions of the SEG-Y standard from 1975 (rev 0) to
2023 (rev 2.1).

The [SEG technical standards](https://library.seg.org/seg-technical-standards) used in the development of this
package are:

- [SEG-Y rev 1.0 Data Exchange format, May 2002](https://library.seg.org/pb-assets/technical-standards/seg_y_rev1-1686080991247.pdf)

- [SEG-Y rev 2.0 Data Exchange format, January 2017](https://library.seg.org/pb-assets/technical-standards/seg_y_rev2_0-mar2017-1686080998003.pdf)

- [SEG-Y rev 2.1 Data Exchange format, October 2023](https://library.seg.org/pb-assets/technical-standards/seg_y_rev2_1-oct2023-1701361639333.pdf)

Free registration may be required to access these documents.

## Installation

Get the latest stable release with Julia's package manager:

```
] add SeisKit
```

## Usage

The SEG-Y file format is the most widely used format for storing
seismic data in the industry. It consists of a textual header,
a binary header, optional extended headers, and trace data with individual trace headers.

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
