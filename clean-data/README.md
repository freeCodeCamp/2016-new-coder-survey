# Cleaning and Combine Free Code Camp Survey Data

## Introduction

The survey data was broken up into two parts and need to be combined into one
for ease of future downstream analyses. Additionally, these two data sets need
to be cleaned up a bit because of the nature of survey data.

## Notable Data Transformations

### Obvious Outliers

In some of the numeric free text answers, numeric values were filtered out if it
was beyond a reasonable threshold. For example, an answer saying you've coded
for 100,000 months would be removed.

### Numeric Ranges

Some answers were given as ranges. For example, a range of "9-10" months of
programming might have been answer to a question. The average of this range was
taken when possible.

### Years to Months

Some answers to a question asking about months were given in years. These were
converted to months if possible.

### Normalization of Answers

Some of the free text answers were very similar to each other, with the
exception of a space or two. These will register as different answers if you
aren't looking for them. Answers like "Cybersecurity" and "Cyber Security" are
the same and were changed to a consistent manner. There may have been some
missed.


## Prerequisites to Rerun Data Manipulations

- [R][RProj] (>= 3.2.3)
- [dplyr][dplyrGH] (>= 0.4.3) [CRAN][dplyrCRAN]
- [Rcpp][RcppGH] (>= 0.12.4) [CRAN][RcppCRAN]

[RProj]: https://www.r-project.org/
[dplyrGH]: https://github.com/hadley/dplyr
[RcppGH]: https://github.com/RcppCore/Rcpp
[dplyrCRAN]: https://cran.r-project.org/web/packages/dplyr/index.html
[RcppCRAN]: https://cran.r-project.org/web/packages/Rcpp/index.html


## Reproduce Cleaning and Combining of Data

Running the following script will create a new file
`2016-New-Coders-Survey.csv` file in this directory `clean-data/`.

```shell
git clone https://github.com/FreeCodeCamp/2016-new-coder-survey.git
cd clean-data
Rscript clean-data.R
```


## Cleaning Pipeline

1. Rename column names
2. Clean free text fields for appropriate question
