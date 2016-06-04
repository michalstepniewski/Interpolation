library(shiny)
library(datasets)
source("upload.R")

start_date <- "2016-01-07"                 # insert start date for post analysis
end_date <- "2016-01-14"                   # insert end date for post analysis
dbname <- "crawl_sqlite_db_2016_01_18.db"  # insert database filename
origin <- "NowThisNews"

DT_interval <- upload(dbname, start_date, end_date, origin)

print (names(DT_interval))
print (colnames(DT_interval))
# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Hello World!"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
#      numericInput('clusters', 'Cluster count', 3,
#                   min = 1, max = 9),
      dateRangeInput("dates", label = h3("Date range")),
      selectInput('publisher', 'Publisher:', unique(DT_interval$origin)),
      selectInput('xcol', 'Variable:', names(DT_interval)[9:12]),
      sliderInput("bins",
                  "Number of bins:",
                  min = 5,
                  max = 50,
                  value = 30)
#    ),
    # Generate a row with a sidebar
#    sidebarLayout(      
      
      # Define the sidebar with one input
#      sidebarPanel(
#        selectInput("region", "Region:", 
#                    choices=colnames(WorldPhones)),
#selectInput('xcol', 'X Variable', names(iris)),
        #colnames(DT_interval)
#        hr(),
#        helpText("Data from AT&T (1961) The World's Telephones.")
      ),
      
      
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))

