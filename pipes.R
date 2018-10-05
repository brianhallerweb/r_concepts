library(tidyverse)
# Pipes (%>%) come from the magrittr package. 
# Magrittr is a dependency in the tidyverse.

# how %>% works
# I think it is essentially a function that does a "lexical transformation."
# I think it takes the left hand side and right hand side as arguments. The
# output of the left hand side is assigned to a temp variable and that temp
# variable is put into the right hand side.   
# The important thing to notice about this behavior is that functions that use
# the the global environment will not work properly because their scope will be
# changed to the pipe. It is possible to control the environment explicitly
# within the pip but is probably easier to avoid the pipe with functions like
# assign(), get(), or load()

# when to use %>%
# Pipes are most useful when you are doing a series of linear transformations
# on an object. All they do is help you do avoid the clutter and confusion of
# naming intermediate variables or having nested functions.

############################
# magrittr has other pipe-like functions
library(magrittr)

# tee (%T>%)
# Instead of returning the right hand side, it returns the left hand side. It
# is useful for calling functions for their side effects from within a # piping
# series (like plotting or printing output)
rnorm(100) %>%
   matrix(ncol = 2) %T>%
   plot() %>%
   str()

# %$%
# I don't know if this pipe has name but it does what the dollar sign does in a
# data frame. It takes the columns out of dataframe. So it is useful when you
# want to pipe into a function that expects vectors as arguments. For example,
# the correlation function
mtcars %$%
	cor(disp, mpg) %T>%
	print()


