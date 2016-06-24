
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(readr)
library(magrittr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(Cairo)

df_tb <- read_tsv("data/OTIS 2013 TB Data.txt", n_max = 1069, col_types = "-ciiii?di")


shinyServer(function(input, output) {
  
  output$nationPlot <- renderPlot({
    
    df_tb %>% 
      group_by(Year) %>% 
      summarise(n_cases = sum(Count), pop = sum(Population), us_rate = (n_cases / pop * 100000)) %>% 
      ggplot() +
      labs(x = "Year reported",
           y = "TB Cases per 100,000 residents",
           title = "Reported Active Tuberculosis Cases in the U.S.") +
      theme_minimal() +
      geom_line(aes(x = Year, y = us_rate))
  })

  output$nationPlot2 <- renderPlot({
    
    df_tb %>% 
      group_by(Year) %>% 
      summarise(n_cases = sum(Count), pop = sum(Population), us_rate = (n_cases / pop * 100000)) %>% 
      ggplot() +
      labs(x = "Year reported",
           y = "TB Cases per 100,000 residents",
           title = "Reported Active Tuberculosis Cases in the U.S.") +
      theme_minimal() +
      geom_line(aes(x = Year, y = us_rate))
  })
  
    
  output$statePlot <- renderPlot({
    # generate bins based on input$labels from ui.R
    
    top_states <- df_tb %>% 
      filter(Year == 2013) %>% 
      arrange(desc(Rate)) %>% 
      slice(1:input$nlabels) %>% 
      select(State)
    
    df_tb$top_state <- factor(df_tb$State, levels = c(top_states$State, "Other"))
    df_tb$top_state[is.na(df_tb$top_state)] <- "Other"
    df_tb %>% 
      ggplot() +
      labs(x = "Year reported",
           y = "TB Cases per 100,000 residents",
           title = "Reported Active Tuberculosis Cases in the U.S.") +
      theme_minimal() +
      geom_line(aes(x = Year, y = Rate, group = State, colour = top_state, size = top_state)) +
      scale_colour_manual(values = c(brewer.pal(n = input$nlabels, "Paired"), "grey"), guide = guide_legend(title = "State")) +
      scale_size_manual(values = c(rep(1,input$nlabels), 0.5), guide = guide_legend(title = "State")) 
  })

  output$PostAnalytics <- renderPlot({
    # generate bins based on input$labels from ui.R
    
    top_states <- df_tb %>% 
      filter(Year == 2013) %>% 
      arrange(desc(Rate)) %>% 
      slice(1:input$nPosts) %>% 
      select(State)
    
    df_tb$top_state <- factor(df_tb$State, levels = c(top_states$State, "Other"))
    df_tb$top_state[is.na(df_tb$top_state)] <- "Other"
    df_tb %>% 
      ggplot() +
      labs(x = "Date",
           y = "views, likes, shares or comments",
           title = "Number of views, likes, shares or comments development in time") +
      theme_minimal() +
      geom_line(aes(x = Year, y = Rate, group = State, colour = top_state, size = top_state)) +
      scale_colour_manual(values = c(brewer.pal(n = input$nPosts, "Paired"), "grey"), guide = guide_legend(title = "Post ID")) +
      scale_size_manual(values = c(rep(1,input$nPosts), 0.5), guide = guide_legend(title = "Post ID")) 
  })  

  output$CompetitionAnalytics <- renderPlot({
    # generate bins based on input$labels from ui.R
    
    top_states <- df_tb %>% 
      filter(Year == 2013) %>% 
      arrange(desc(Rate)) %>% 
      slice(1:input$nPublishers) %>% 
      select(State)
    
    df_tb$top_state <- factor(df_tb$State, levels = c(top_states$State, "Other"))
    df_tb$top_state[is.na(df_tb$top_state)] <- "Other"
    df_tb %>% 
      ggplot() +
      labs(x = "Date",
           y = "views,likes,shares or comments",
           title = "Views, likes, shares or comments development in time") +
      theme_minimal() +
      geom_line(aes(x = Year, y = Rate, group = State, colour = top_state, size = top_state)) +
      scale_colour_manual(values = c(brewer.pal(n = input$nPublishers, "Paired"), "grey"), guide = guide_legend(title = "Publisher")) +
      scale_size_manual(values = c(rep(1,input$nPublishers), 0.5), guide = guide_legend(title = "Publisher")) 
  })  
  
  output$selectState <- renderUI({ 
    selectInput(inputId = "state", label = "Which post?", choices = unique(df_tb$State), selected = "Alabama", multiple = FALSE)
  })
  
  output$iStatePlot <- renderPlot({
    df_tb %>% 
      filter(State == input$state) %>% 
      ggplot() +
      labs(x = "Year reported",
           y = "TB Cases per 100,000 residents",
           title = "Reported Active Tuberculosis Cases in the U.S.") +
      theme_minimal() +
      geom_line(aes(x = Year, y = Rate))
  })
  
})
