### Reading raw csv files from Qualtrics -----

## Comment on Import:
## I was having trouble importing the dataset in a way where the data 
## types were properly encoded. I suspect this is due to the metadata
## Raw qualtrics files contain metadata in the first few rows which
## make it difficult to properly import. While `read_csv()` allows you 
## to 'skip' the metadata, I was unable to figure out how to skip 
## the metadata _while_ retaining the first row, of column names. 
## 
## Instead, I have imported the dataset and extracted the column names 
## (from the first row) and stored them in a character vector, `varNames`
## 
## I then import the dataset a second time, skipping the first three rows, 
## and using `varNames` as the names of the columns. 

if(!require(dplyr)){install.packages("dplyr")}

read_csv_from_qsf = function(fileLocation, codebook = FALSE){
  require(dplyr)
  data = readr::read_csv(file = paste0(fileLocation),
                         na = ".",
                         col_names = FALSE)
  
  # Extract variable names
  varNames = as.character(data[1, ]) # Extracting first row to use as column names
  dataDic  = tibble(
    ColumnNames = varNames,
    SurveyItem = as.character(data[2, ])
  ) # Generate data dictionary of original variable set for reference in the future
  
  data = readr::read_csv(file = paste0(fileLocation),
                         na = ".",
                         skip = 3,
                         col_names = varNames
  )
  
  if (codebook == TRUE) {
    dataDic
  }
  else {
    data
  }
}