rm(list=ls())
library(tidyverse)
library(jsonlite)

# 9/24
# This is an example of wrangling a unusual json file into a tibble
# I doubt it is the best way to solve the problem but I still deciced
# to keep it for reference.

# The json looks like this
# { widget_id: {widget_id: 12345,
#               clicks: 2,
#               cost: ...,
#               . 
#               . 
#               . 
#               referrer: [.com, com, .com] 
#               }
#   ... 
#   ... 
#   ... 
# }

data = fromJSON("/home/bsh/Documents/UlanMedia/data/by_widgets_by_campaigns_data/506319_seven_by_widgets_by_campaigns_data.json")

widget_id <- vector("character", length(data))
clicks <- vector("integer", length(data))
cost <- vector("double", length(data))
revenue <- vector("double", length(data))
leads <- vector("integer", length(data))
sales <- vector("double", length(data))
referrer <- vector("character", length(data))

df <- tibble(widget_id, clicks, cost, revenue, leads, sales, referrer)

for (i in 1:length(data)){
	names <- names(data[[i]])
	for (j in 1:length(data[[i]])){
            if (names[[j]] == "referrer"){
		 if (length(data[[i]][[j]]) == 0){
		     df[["referrer"]][[i]] <- NA
		 } else {
	             # This is a list of referrer data. I'm not sure
		     # if it is correct to store the entire list or not
		     df[["referrer"]][[i]] <- data[[i]][[j]][1]
                 }	
	         next
	    }
	    df[[names[[j]]]][[i]] <- data[[i]][[j]] 
	}
}
print(df, n = 500)


