# jsonlite is a JSON parser/generator

# the functions are fromJSON() and toJSON()

# there is support for parsing JSON to vectors and matrices but the most common
# use is for dataframes. 

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


