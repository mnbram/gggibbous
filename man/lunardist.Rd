% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{lunardist}
\alias{lunardist}
\title{Lunar distances and principal phases for 2019}
\format{
A data frame with 365 rows and 3 variables:
\describe{
  \item{date}{Date}
  \item{distance}{Distance from the Earth to the Moon in kilometers}
  \item{phase}{Principal phase of the moon (full, new, first quarter, third
  quarter) or NA if no principal phase on that date}
}
}
\source{
\url{https://svs.gsfc.nasa.gov/4442}
}
\usage{
lunardist
}
\description{
This data set contains the distance from the Earth to the Moon for each day
in 2019, as well as the dates (in UTC) of each occurrence of the four
principal phases of the moon. The data are adapted from NASA.
}
\keyword{datasets}
