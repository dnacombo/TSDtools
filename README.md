
# TSDtools

<!-- badges: start -->
<!-- badges: end -->

TSDtools provides a function to read data from the Time Social Distancing (TSD) experiment data.
If you are entitled to use this data, you have received a link to download it.

## Installation

You can install the released version of TSDtools from [Github](https://github.com/dnacombo/TSDtools) with:

``` r
install.packages('devtools')
devtools::install_github('dnacombo/TSDtools')
```

## Example

This is a basic example showing how to read data using TSDtools' `gimmedata()`.

``` r
library(TSDtools)

DataDir <- "/local/path/where/I/have/my/data"

d <- gimmedata(DataDir, ExperimentName = 'FR', UniqueName = 'Implicit', Run = 3, Session = 1)

d <- gimmedata(DataDir,ExperimentName = 'JP', UniqueName = '.*Self.*', verbose = T) %>%
    filter(`Event Index` == "1")

```

