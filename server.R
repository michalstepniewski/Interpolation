library(shiny)
source("upload.R")

start_date <- "2016-01-07"                 # insert start date for post analysis
end_date <- "2016-01-14"                   # insert end date for post analysis
dbname <- "crawl_sqlite_db_2016_01_18.db"  # insert database filename
origin <- "NowThisNews"

DT_interval <- upload(dbname, start_date, end_date, origin)

print ("loaded database")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  dataInput <-   reactive({
 

    upload(dbname, input$dates[1], input$dates[2], origin)
    print ('uploaded')

  })

    output$Plot <- renderPlot({

    
    #    print (input$xcol)
#    print (DT_interval$views)
#    print ()
    print('rerunning render plot')
    x    <- dataInput()[,get(input$xcol)] #[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    print (x)
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'skyblue', border = 'white')
  })
})

