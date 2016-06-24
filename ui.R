

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

origins <- c("NowThisNews",    "NBCNews",        "SOML","buzzfeedtasty", 
             "techinsider",    "HuffingtonPost", "BuzzFeedVideo",  "BuzzFeedFood",  
             "ajplusenglish",  "TipHero",  "tastemade",  "ajplusespanol", 
             "cnn",            "BuzzFeedNews",   "attn",           "FoxNews",       
             "vicenews",       "Vox",            "Channel4News",   "skynews",       
             "Vocativ",  "thisisinsider",  "RYOT",  "ajplusarabi")

shinyUI(
  fluidPage(
    
    # Application title
    titlePanel("NowThis Analytics"),
    
    mainPanel(
      column(12, 
             tabsetPanel(
               tabPanel("Competition Analytics", fluidRow(plotOutput("nationPlot"))),
               tabPanel("Something Analytics", fluidRow(plotOutput("nationPlot2"))),
               tabPanel("Post Analytics", 
                        fluidRow(plotOutput("statePlot"),
                                 wellPanel(
                                   sliderInput(inputId = "nlabels",
                                               label = "Top n Posts:",
                                               min = 1,
                                               max = 10,
                                               value = 6, 
                                               step = 1)
                                 )
                        )
               ),
               
               tabPanel("Post Analytics2", 
                        fluidRow(mainPanel(plotOutput("PostAnalytics")),
                                 sidebarPanel(
                                   #      numericInput('clusters', 'Cluster count', 3,
                                   #                   min = 1, max = 9),
                                   dateRangeInput("dates", 'Created Date range:'),
                                   dateRangeInput("read_dates", 'Read Date range:'),
                                   selectInput('publisher', 'Publisher:', origins),
                                   #nie wiem czy to bedzie dobre,
                                   #musze wrocic do tego co bym chcial osiagnac
                                   #co bym chcial zrobic i czy shiny mi to umozliwia
                                   # czy shiny supportuje rozne taby?
                                   selectInput('xcol', 'Variable:', c('views','likes','comments','shares')),
                                   
                                   actionButton("goButton","Go!")),
                                 
                                 wellPanel(
                                   sliderInput(inputId = "nPosts",
                                               label = "Top n Posts:",
                                               min = 1,
                                               max = 10,
                                               value = 6, 
                                               step = 1)
                                 )
                        )
               ),
               
               tabPanel("Competition Analytics2", 
                        fluidRow(mainPanel(plotOutput("CompetitionAnalytics")),
                                 sidebarPanel(
                                   #      numericInput('clusters', 'Cluster count', 3,
                                   #                   min = 1, max = 9),
                                   dateRangeInput("dates", 'Created Date range:'),
                                   dateRangeInput("read_dates", 'Read Date range:'),
                                   selectInput('publisher', 'Publisher:', origins),
                                   #nie wiem czy to bedzie dobre,
                                   #musze wrocic do tego co bym chcial osiagnac
                                   #co bym chcial zrobic i czy shiny mi to umozliwia
                                   # czy shiny supportuje rozne taby?
                                   selectInput('xcol', 'Variable:', c('views','likes','comments','shares')),
                                   
                                   actionButton("goButton","Go!")),
                                 wellPanel(
                                   sliderInput(inputId = "nPublishers",
                                               label = "Top n Publishers:",
                                               min = 1,
                                               max = 10,
                                               value = 6, 
                                               step = 1)
                                 )
                        )

                          
               ),
               
               tabPanel("Post Lookup", 
                        fluidRow(plotOutput("iStatePlot"),
                                 wellPanel(
                                   htmlOutput("selectState"))
                        )
               )
             )
      ), 
      #      column(4, 
      #             includeHTML("intro_text.html")),
      width = 12)
  )
)