# This info comes from the book Efficient R

# At startup 2 config files are run. 
# .Renviron runs first
# .Rprofile run second

# These files are located at root, and optionally in your home directory and
# working directory. The order of precedence is working directory, home
# directory, root directory. 

# .Rprofile simply runs line of R code. There might be a few uses for this but
# it compromises portability and reproducibility. The only useful thing I can
# think of for .Rproile is to set a permanent CRAN mirror, but even that is
# pretty useless. 

# .Renviron
# this file is useful
# it is where you can set environmental variables
# The enviornmental variables are separate for R. They include things like
# $BROWSER set in .profile
# check your environmental variables within R with Sys.getenv()
# use it to specify the R_LIBS_USER path, which is where new packages are installed
