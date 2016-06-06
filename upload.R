library (RSQLite)
library(data.table)

upload <- function(dbname, start_date, end_date, origin) {
  db <- dbConnect(SQLite(), dbname)

  query <- sprintf("
SELECT * 
FROM PostsByReadDates
WHERE (created_date BETWEEN '%s' AND '%s')
AND (hours_elapsed < 168)
AND (origin = '%s')
", start_date, end_date, origin)
  
  db_prefix <- substr(dbname, start = 0, stop = nchar(dbname)-3)
  file_name <- sprintf("RDS_tmp_files/%s_%s_%s_%s.RDS", db_prefix, start_date, end_date, origin)
  if (file.exists(file_name)) 
    return( readRDS(file_name) )
  
  
  system.time(
    test <- dbGetQuery(db, query)
  )
  
  # w tym momencie tracimy informacje o godzinie/minucie
  # ale można rzutować z zachowaniem szczegółowych danych
  test$created_date <- as.Date(test$created_date)
  test$read_date <- as.POSIXct(test$read_date, format = "%Y_%m_%d_%H")
# nie wiem czy chce to juz teraz rzutowac
  
  DT_test <- as.data.table(test)
  
  saveRDS(DT_test, file = file_name)
  
  DT_test
}
