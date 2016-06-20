library(shiny)
library(ggplot2)
source("upload.R")
source("upload_all_origins.R")

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

  output$distPlot <- renderPlot({
#    print (input$xcol)
#    print (DT_interval$views)
#    print ()
    input$goButton
    isolate ({
    print ('uploading/reuploading')
    system.time(DT_interval <- upload(dbname, input$dates[1], input$dates[2],input$publisher))
    print ('uploaded/reuploaded')
    x    <- DT_interval[,get(input$xcol)] #[, 2]  # Old Faithful Geyser data

    bins <- seq(min(x), max(x), length.out = input$bins + 1)
#    print (x)
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'skyblue', border = 'white')
    })

    
    
      })

  output$distPlot2 <- renderPlot({
    #    print (input$xcol)
    #    print (DT_interval$views)
    #    print ()
    input$goButton
    isolate ({
      print ('uploading/reuploading')
      system.time(DT_interval <- upload_all_origins(dbname, input$dates[1], input$dates[2]))
      print (DT_interval$origin)
      print ('uploaded/reuploaded')
      x    <- DT_interval[,get(input$xcol)] #[, 2]  # Old Faithful Geyser data
      
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      #    print (x)
      # draw the histogram with the specified number of bins
#      hist(x, breaks = bins, col = 'skyblue', border = 'white')
  #   DT_interval_cumulative <- DT_interval[ , .(sum_likes = max(likes),
  #                                               sum_comments = max(comments),
  #                                               sum_shares = max(shares), 
  #                                               sum_views = max(views)),
  #                                           by = .(origin, read_date) ]
      DT_interval_cumulative <- DT_interval[ , .(sum_likes = sum(likes),
                                                 sum_comments = sum(comments),
                                                 sum_shares = sum(shares), 
                                                 sum_views = sum(views)),
                                             by = .(origin, read_date) ]
      
#      print (DT_interval_cumulative$origin)
#      qplot(read_date, sum_likes, data=DT_interval_cumulative[DT_interval_cumulative$origin %in% c("buzzfeedtasty")], colour = 'red', main = DT_interval_cumulative$origin, log = 'n',geom = "line", ylab ="stats")#  + geom_line(aes(read_date, sum_comments), data=DT_interval_cumulative,colour='blue')#+geom_line(aes(read_date, sum_shares), data=DT_interval_cumulative,colour='green')#+geom_line(aes(read_date, sum_views), data=DT_interval_cumulative,colour='yellow')  +
#      p <- ggplot(data=DT_interval_cumulative, aes(x=data$read_date))
    #  ggplot(data=DT_interval_cumulative)#, aes(x=data$read_date))
      plot(data$read_date, data$sum_likes, data=DT_interval_cumulative[DT_interval_cumulative$origin %in% c("buzzfeedtasty")], colour = 'red', main = "Graf", geom = "line", ylab ="stats")
      #      p
      
#        for (origin in unique(DT_interval_cumulative$origin)[1]) 
#  {
#          data=DT_interval_cumulative[DT_interval_cumulative$origin %in% origin]
          #      plot(read_date, sum_likes, data=DT_interval_cumulative[DT_interval_cumulative$origin %in% c("buzzfeedtasty")], colour = 'red', main = DT_interval_cumulative$origin, log = 'n',geom = "line", ylab ="stats")
          #      data <- DT_interval_cumulative[DT_interval_cumulative$origin %in% c("buzzfeedtasty")]
          #      p
          #      p <- p + geom_line(aes_string(y = data$sum_shares))#, color = shQuote(2)))
#          p <- p + geom_line(aes_string(y = data$sum_shares, x=data$read_date,  color = shQuote(2)))
#          p
#        }   
      
      #      qplot(read_date, sum_likes, data=DT_interval_cumulative[DT_interval_cumulative$origin %in% c("buzzfeedtasty")], colour = 'red', main = DT_interval_cumulative$origin, log = 'n',geom = "line", ylab ="stats")
#      + geom_line(aes(read_date, sum_likes), data=DT_interval_cumulative[DT_interval_cumulative$origin %in% c("NowThisNews")],colour='blue')
      #+geom_line(aes(read_date, sum_shares), data=DT_interval_cumulative,colour='green')#+geom_line(aes(read_date, sum_views), data=DT_interval_cumulative,colour='yellow')  +
#        scale_colour_manual(values=c("red","green","blue"))
    })
    
    


        
  })  
  
  })



#DT_interval_cumulative <- DT_interval[ , .(sum_likes = max(likes),
#                                           sum_comments = max(comments),
#                                           sum_shares = max(shares),
#                                           sum_views = max(views)),
#                                       by = .(post_id, origin, read_date) ]

#max_ids_per_plot <- 1


#this_origin <- origin

#post_ids_for_this_origin <- unique(DT_interval_cumulative[origin == this_origin]$post_id)

#n_of_groups <- ceiling(length(post_ids_for_this_origin)/max_ids_per_plot)

#for (j in 1:n_of_groups) {
  
#  particular_ids <- unlist(split(post_ids_for_this_origin, ceiling(seq_along(post_ids_for_this_origin)/max_ids_per_plot))[j])
  
#  DT_interval_cumulative_snippet <- DT_interval_cumulative[ origin == this_origin & post_id %in% particular_ids ]
  
#  p <- qplot(read_date, sum_likes, data=DT_interval_cumulative_snippet, colour = 'red', main = DT_interval_cumulative_snippet$post_id, log = 'y',geom = "line", ylab ="stats") + geom_line(aes(read_date, sum_comments), data=DT_interval_cumulative_snippet,colour='blue')+geom_line(aes(read_date, sum_shares), data=DT_interval_cumulative_snippet,colour='green')+geom_line(aes(read_date, sum_views), data=DT_interval_cumulative_snippet,colour='yellow')  +
#    scale_colour_manual(values=c("red","green","blue"))# + #+ geom_smooth()
  #theme(legend.position="bottom",
  #       legend.title=element_blank())+
  #   ggtitle("Line plot")
#  show(p)
#}  