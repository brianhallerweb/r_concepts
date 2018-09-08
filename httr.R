# httr is a http library inspired by Python's requests. 

################################
# Complete example
library(httr)

r <- GET("http://numbersapi.com/random/year", add_headers("Content-Type" = "application/json"))
print(content(r, "parsed")$text)

###################################
# basic get request
r <- GET("http://httpbin.org/get"):

# response status
status_code(r) #200
http_status(r) #a longer description 
#error checking 
warn_for_status(r)
stop_for_status(r)

# response headers
headers(r)

# response body
content(r, "text")
# The second argument has to do with the response you expect (usually text.
# The second argument can also be 'parsed', which will automatically parse JSON
# into a named list. 
content(r, "parsed")

# response cookies
cookies(r)

#############################
# Sending data in get and post requests 

# get request with a query string
# The query is written as a named list
r <- GET("http://httpbin.org/get", 
  query = list(key1 = "value1", key2 = "value2")
)
content(r)$args
#> $key1
#> [1] "value1"
#> $key2
#> [1] "value2"

# Add a header
r <- GET("http://httpbin.org/get", add_headers(Name = "Obie"))

# post request with a body
# the body is a named list
# there are other ways of writing a body but named list is most common
r <- POST("http://httpbin.org/post", body = list(a = 1, b = 2, c = 3))

# Changing the body encoding
r <- POST(url, body = body, encode = "multipart") #default
r <- POST(url, body = body, encode = "form")
r <- POST(url, body = body, encode = "json")


 

# 
