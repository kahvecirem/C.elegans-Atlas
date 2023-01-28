library(shiny)
library(ggplot2)
library(reshape)
library(plotly)

###part 2####

####user interface####
ui <- fluidPage (
  
  titlePanel("Celegans Atlas")
  
  sidebarLayout(
    
    ##sidebarpanel
    sidebarPanel(
      
      br(),
      
      ##put input boxes here
      tags$em("All Graphs:"),
      selectInput("sizeselect", "Select Organism:",
                  c("Negligible" = "None",
                    "celegans" = "celegans",
                    "human" = "human",
                    "mouse" = "mouse")),
      
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
        tabPanel("Significant", plotOutput("sigpic"),
                 br(),
                 
                 tabPanel("Non-Significant", plotOutput("nonpic"),
                          br(),
                          
                          tabPanel("try_1_", plotOutput("try_1"),
                                   br(),
                                   
                                   tabPanel("More", plotOutput("More"),
                                            br(),
                                            hr("Upload file"),
                                            fileInput("upload", NULL)
                                            
                                            
                                            tabPanel("Comparison", plotOutput("compare"), 
                                                     br(),
                                                     helpText(,br(), 
                                                              
                                                              tabPanel("3D Comparison", plotlyOutput("compare3d"), 
                                                                       br(),
                                                                       
                                                                       "revize ederken hatalara tekrar bak"))
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
                   
                   ####try_1####
                   output$try_1 <- renderPlot({
                     
                     ##log n to get a better graph
                     if (input$Nselect == "log") { agreelong$N = log(agreelong$N)
                     xlabel = "Log N" } else { xlabel = "N"}
                     
                     ####GRAPH####
                   })
                   
                   ####try_2###
                   output$try_2 <- renderPlot({
                     
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
                                       x = ~try_3,
                                       y = ~try_2,
                                       z = ~try_1,
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
                 
                 
                 ######## part 3 ####
                 ui <- fluidPage(
                   
                   sliderInput(inputId = "Id_lenght", label = "Select the range ", value = c(40,50), min = 32, max = 60),
                   
                   navlistPanel(
                     "celegans",
                     tabPanel(title = "Plot",
                              plotOutput("celegans_plot")
                     ),
                     tabPanel(title = "Table",
                              tableOutput("celegans_table")
                     ),
                     "About Celegans",
                     tabPanel(title = "About celegans",
                              textOutput("About celegans")
                     )
                   )
                   
                 )
                 
                 
                 server <- function(input, output){
                   
                   data <- reactive({
                     subset(celegans, bill_length_mm > input$bill_length[1] & bill_length_mm < input$bill_length[2])
                   })
                   
                   output$celegans_plot <- renderPlot({
                     plot(data()$bill_depth_mm, data()$bill_length_mm, col = data()$species)
                   })
                   
                   output$celegans_table <- renderTable({
                     data()
                   })
                   
                   output$celegans_text <- renderText({
                     "Let me introduce you to the research of the celegans" #hr ile de olurdu
                   })
                   
                 }
                 
                 shinyApp(ui, server)