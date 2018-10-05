# jsonlite is a JSON parser/generator

# the functions are fromJSON() and toJSON()

# fromJSON() is made to use simplification
# simplification is a convenient shortcut for parsing common json into useful
# r data structures. Without simplification, json gets parsed as r list of
# lists of lists...etc. Then you have to do a bunch of manual data munging 
# to get it into a useful r data structure. 

# simiplification is all about telling fromJSON how to deal with json arrays
# The most common is simplifyDataFrame=TRUE. It parses a json array of objects
# into a data frame where each row is an object. There is alos support for 
# parsing JSON arrays to vectors and matrices. 

json <-
'[
  {"Name" : "Mario", "Age" : 32, "Occupation" : "Plumber"},
  {"Name" : "Peach", "Age" : 21, "Occupation" : "Princess"},
  {},
  {"Name" : "Bowser", "Occupation" : "Koopa"}
]'

# Create a data frame from json
mydf <- fromJSON(json)

# Create json from a data frame
myjson <- toJSON(mydf)

# It seems that fromJSON will take files and probably urls as arguments as
# well. 


