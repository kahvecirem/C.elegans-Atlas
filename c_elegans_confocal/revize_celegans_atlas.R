#sooooon1

#required package
library(shiny)
library(ggplot2)
library(reshape)
library(plotly)
library(shinythemes)

# Used packages
pacotes = c("shiny", "shinydashboard", "shinythemes", "plotly", "shinycssloaders","tidyverse",
            "scales", "knitr", "kableExtra", "ggfortify","dplyr","plotly","FNN")

# Run the following command to verify that the required packages are installed. If some package is missing, it will be installed automatically
package.check <- lapply(pacotes, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
  }
})

# Define working directory
data <- read.table("PES2019.txt",header=TRUE,sep="\t")
names(data)[1] <- "player"  #rename from "ï..player" to "player"
####
####
selectInput("Nselect", "Select N Scaling:",
            c("N" = "N",
              "Log N" = "log")),

htmlOutput("slider_selector")

####change the slider####
output$slider_selector = renderUI({ 
  
  if (input$Nselect == "N") { minN = 10; maxN = 1000; stepN = 10}
  if (input$Nselect == "log") { minN = round(log(10),1) 
  maxN = round(log(1000),1)
  stepN = .1}
  
  sliderInput("xaxisrange", "X-Axis Range:",
              min = minN, max = maxN,
              value = c(minN,maxN),
              sep = "",
              round = -1,
              step = stepN)
})

####user interface####
ui <- fluidPage (
  theme = shinytheme("flatly"), 
  
  titlePanel("Celegans Atlas"),
  
  sidebarLayout(
    
    ##sidebarpanel
    sidebarPanel(
      
      br(),
      
      ##put input boxes here
      tags$em("All Graphs:"),
      selectInput("sizeselect", "Select Organism:",
                  c("None" = "None",
                    "Celegans" = "Celegans",
                    "Human" = "Human",
                    "Mus Musculus" = "Mus Musculus")),
      
      tags$em("Percent Graphs:"),
      selectInput("Nselect", "Select N Scaling:",
                  c("N" = "N",
                    "Log N" = "log")),
      
      htmlOutput("slider_selector"),
      
      tags$em("Comparison Graphs:"),
      
      selectInput("graphselect", "Select Graph:",
                  c("PCC - p" = "pccp",
                    "PCC - BF" = "pccbf",
                    "BF - p" = "bfp")),
      
      sliderInput("bfrange", "Log BF Range:",
                  min = -5, max = 600,
                  value = c(-5,600),
                  sep = "",
                  step = 10),
      
      sliderInput("prange", "p Range:",
                  min = 0, max = 1,
                  value = c(0,1),
                  step = .01),
      
      sliderInput("pccrange", "PCC Range:",
                  min = 0, max = 1,
                  value = c(0,1),
                  step = .01)
      
    ), #close sidebar panel
    
    mainPanel(
      
      tabsetPanel(
        tabPanel("Celegans", plotOutput("sigpic"),
                 br(),
                 helpText("Soon")),
        tabPanel("3D Comparision", plotOutput("postagree"),
                 br(),
                 helpText("Soon",br(), 
                          "3D images panel")),
        ui <- fluidPage (
        navbarPage("Celegans Atlas _try"),
                   tabPanel("Graphic",fluidPage(theme = shinytheme("flatly")),
                            tags$head(
                              tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                            pageWithSidebar(
                              headerPanel('Select'),
                              sidebarPanel(width = 4,
                                           selectInput('organism', 'Choose a organism:',paste(data$player,"-",data$team)),
                                           sliderInput("overall", "Overall:",
                                                       min = 50, max = 100,
                                                       value = c(50,100)),
                                           sliderInput("height", "Height (cm):",
                                                       min = 155, max = 203,
                                                       value = c(155,203)),
                                           checkboxGroupInput(inputId = "Gene",
                                                              label = 'Gene_name:', choices = c("gene_1" = "gene_1", "gene_2" = "gene_2",
                                                                                                "gene_3"="gene_3",
                                                                                                selected = c("gene_3"="gene_3"),inline=TRUE),
                                                              checkboxGroupInput(inputId = "Image type",
                                                                                 label = 'Image:', choices = c("Confocal" = "Confocal",
                                                                                                               "3D" = "3D"), 
                                                                                 selected = c("Confocal" = "Confocal",
                                                                                              "3D" = "3D"),inline=TRUE),
                                                              submitButton("Update filters")
                                           ),
                                           mainPanel(
                                             column(8, plotlyOutput("plot1", width = 800, height=700),
                                                    p("To visualize the graph of the organism, click the icon at side of names 
             in the graphic legend. It is worth noting that graphics will be overlapped.",
                                                      style = "font-size:25px")
                                                    
                                             )
                                           )
                              )),
                            tabPanel("About",p("We used a data set consisting of 39 attributes from 11,158 players registered
                          in Pro Evolution Soccer 2019 (PES 2019), an electronic soccer game. The data set
                          was obtained from ", a("PES Data Base", href="http://pesdb.net/", target="_blank"),
                                               "website using web scraping. This app is an interactive tool that allows any user to choose a soccer player from the game
                         and find the ten players most similar whith him. The similarity between the players is determined using a data mining technique
                         called", a("k-nearest neighbors", href="https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm", target="_blank"), ".",style = "font-size:25px"),
                                     
                                     hr(), 
                                     p("The available genes are:",style = "font-size:25px"),
                                     p("gene_1: Gene_1 Try",style = "font-size:15px;color: blue"),
                                     p("gene_2: Gene_2 Try",style = "font-size:15px;color: blue"),
                                     p("gene_3: Gene_3 Try",style = "font-size:15px;color: blue"),
                                     
                                     hr(), 
                                     
                                     p("The abbreviations used in the radar chart are:",style = "font-size:25px"),
                                     
                                     p("BAL: Unwavering Balance",style = "font-size:15px;color: blue"),
                                     p("STM: Stamina",style = "font-size:15px;color: blue"),
                                     p("SPE: Speed",style = "font-size:15px;color: blue"),
                                     p("EXP: Explosive Power",style = "font-size:15px;color: blue"),
                                     p("ATT: Attacking Prowess",style = "font-size:15px;color: blue"),
                                     p("BCO: Ball Control",style = "font-size:15px;color: blue"),
                                     p("DRI: Dribbling",style = "font-size:15px;color: blue"),
                                     p("LPAS: Low Pass",style = "font-size:15px;color: blue"),
                                     p("APAS: Air Pass (Lofted Pass)",style = "font-size:15px;color: blue"),
                                     p("KPOW: Kicking Power",style = "font-size:15px;color: blue"),
                                     p("FIN: Finishing",style = "font-size:15px;color: blue"),
                                     p("PKIC: Place Kicking",style = "font-size:15px;color: blue"),
                                     p("SWE: Swerve",style = "font-size:15px;color: blue"),
                                     p("HEA: Header",style = "font-size:15px;color: blue"),
                                     p("JUM: Jump",style = "font-size:15px;color: blue"),
                                     p("PHY: Physical Contact",style = "font-size:15px;color: blue"),
                                     p("BWIN: Ball Winning",style = "font-size:15px;color: blue"),
                                     p("DEF: Defensive Prowess",style = "font-size:15px;color: blue"),
                                     p("GOA: Goalkeeping",style = "font-size:15px;color: blue"),
                                     p("GKC: GK Catch",style = "font-size:15px;color: blue"),
                                     p("CLE: Clearing",style = "font-size:15px;color: blue"),
                                     p("REF: Reflexes",style = "font-size:15px;color: blue"),
                                     p("COV: Coverage",style = "font-size:15px;color: blue")),
                            
                   )
                   
        ))),
        tabPanel("Support", plotOutput("compare"), ##en en en önemli yer
                 
                 hr("Upload file"),
                 fileInput("upload", NULL)),
        tabPanel("About", plotlyOutput("compare3d"), 
                 br(),
                 helpText("Soon",br(), 
                          "info@kaplanlab.com"))
      )
      
    ) #close main panel 
    
  ) #close sidebar layout
  
) #close fluid page

####server functions####
server <- function(input, output) {
  
  ####change the slider####
  output$slider_selector = renderUI({ 
    
    if (input$Nselect == "N") { minN = 10; maxN = 1000; stepN = 10}
    if (input$Nselect == "log") { minN = round(log(10),1) 
    maxN = round(log(1000),1)
    stepN = .1}
    
    sliderInput("xaxisrange", "X-Axis Range:",
                min = minN, max = maxN,
                value = c(minN,maxN),
                sep = "",
                round = -1,
                step = stepN)
  })
  
  ####SIGNIFICANT EFFECTS####
  output$sigpic <- renderPlot({
    
    graphdata = subset(long_graph, Significance=="Sig" & Effect == input$sizeselect)
    
    ##log N
    if (input$Nselect == "log") { graphdata$N = log(graphdata$N) 
    xlabel = "Log N" } else { xlabel = "N"}
    
    ####GRAPH####
  })
  
  ####NONSIGNIFICANT EFFECTS####
  output$nonpic <- renderPlot({
    
    nsgraphdata = subset(long_graph, Significance=="Non" & Effect == input$sizeselect)
    
    ##log N
    if (input$Nselect == "log") { nsgraphdata$N = log(nsgraphdata$N)  
    xlabel = "Log N" } else { xlabel = "N"}
    
    ####GRAPH####
  })
  
  ####OMNIBUS AGREEMENT####
  output$omniagree <- renderPlot({
    
    ##log n to get a better graph
    if (input$Nselect == "log") { agreelong$N = log(agreelong$N)
    xlabel = "Log N" } else { xlabel = "N"}
    
    ####GRAPH####
  })
  
  ####POST HOC AGREEMENT####
  output$postagree <- renderPlot({
    
    ##log n to get a better graph
    if (input$Nselect == "log") { agreelong$N = log(agreelong$N)
    xlabel = "Log N" } else { xlabel = "N"}
    
    ####GRAPH####
  })
  
  ####COMPARISON GRAPHS####
  output$compare <- renderPlot({
    
    if (input$graphselect == "pccp"){
      
      ####GRAPH####
      
    } else if (input$graphselect == "pccbf"){
      
      ####GRAPH####
      
    } else if (input$graphselect == "bfp"){
      
      ####GRAPH####
      
    }
    
  })
  
  ####3D COMPARISON GRAPHS####
  output$compare3d <- renderPlotly({
    
    ####GRAPH SET UP####
    
    overall = plot_ly(overallgraph3d, 
                      x = ~overallBF,
                      y = ~oompcc,
                      z = ~omniP,
                      color = ~N,
                      symbol = ~star,
                      symbols=c("circle","cross"),
                      mode="markers") %>%
      add_markers() %>%
      layout(scene = list(xaxis = list(title = 'Bayes Factors'),
                          yaxis = list(title = 'OOM PCC'),
                          zaxis = list(title = 'p-Value')),
             annotations = list(
               x = 1.13,
               y = 1.05,
               text = colorlabel,
               xref = 'paper',
               yref = 'paper',
               showarrow = FALSE
             ))
    
    overall
    
  })
  
} #close server functions

# Run the application 
shinyApp(ui = ui, server = server)
