## Notes from previous version

* I did not add a \value section to geom_moon.Rd for consistency with ggplot2
  and other extensions to that package, which do not generally include a return
  value in documentation for geom_* functions that are only used to add layers
  to an existing plot.
  
* There is no reference paper associated with this package or its methodology,
  which is largely an aesthetic change to existing data visualization
  functionality. As such, there is no reference to add to the DESCRIPTION.

## Test environments
* Fedora 33 (R 4.0.3 and r-devel)
* win-builder (devel)

## R CMD check results

On Windows/R devel and Fedora/R 4.0.3:

0 errors | 0 warnings | 0 notes

On Fedora with r-devel, there is one note:

* checking for future file timestamps ... NOTE  
  unable to verify current time  
  This appears to be an issue with the check itself accessing an external web
  API. Disabling \_R_CHECK_SYSTEM_CLOCK_ removes the note.
  