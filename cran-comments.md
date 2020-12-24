## Resubmission
This is a resubmission. Notes on changes:

* Package names in DESCRIPTION are now in single quotes.

* draw_key_moon.Rd now includes a \value annotation. I did not add a \value
  section to geom_moon.Rd for consistency with ggplot2 and other extensions to
  that package, which do not generally include a return value in documentation
  for geom_* functions that are only used to add layers to an existing plot.
  
* There is no reference paper associated with this package or its methodology,
  which is largely an aesthetic change to existing data visualization
  functionality. As such, there is no reference to add to the DESCRIPTION.

## Test environments
* Fedora 33 (R 4.0.3 and r-devel)
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
* Possibly mis-spelled words in DESCRIPTION  
  (ggplot and gggibbous, both of which are package names)
