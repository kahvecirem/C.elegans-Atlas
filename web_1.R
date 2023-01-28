#first try

library(shiny)
library(shinythemes)
library(ggplot2)
library(ggpubr)
library(pheatmap)
library(DT)
library(plyr)
library(dplyr)
library(iheatmapr)
library(heatmaply)
library(downloader)
library(plotly)
iris <- iris

#
organism <- c("human", "celegans", "mouse", "drasophila")
#ui part
shinyApp(
  ui = fluidPage(
    theme = shinytheme("flatly"), 
    titlePanel(
      "Celegans Atlas"),
    sidebarPanel(
      textInput("txt", "Search:", "main"),
      actionButton("action", "Compare"),
      actionButton("action2", "More info", class = "btn-primary")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(("About"), #sekme_1
                 hr("About web site")),
        tabPanel(("Organism"),#sekme_2
                 radioButtons("organism", "Choose organism", organism)),
        
        tabPanel(("More"),#sekme_3
                 
                 hr("Upload file"),
                 fileInput("upload", NULL))
      )
    )
  ),
  
  server = function(input, output) {}
)

#

shinyApp(ui = ui, server = server)
