library(shiny)
library(shinythemes)
library(shinyWidgets)
library(markdown)
library(rgl)
library(shinydashboard)
library(png)
library(base64enc)
#require sources
#source("/Users/iremkahveci/Desktop/C.elegans Atlas/28.June/lazyrr.R")
#source("/Users/iremkahveci/Desktop/C.elegans Atlas/28.June/interactivee.R")
#source("/Users/iremkahveci/Desktop/C.elegans Atlas/28.June/animationn.R")

# Setting and obtaining cookies ----

jsCode <- '
  shinyjs.getcookie = function(params) {
    var cookie = Cookies.get("id");
    if (typeof cookie !== "undefined") {
      Shiny.onInputChange("jscookie", cookie);
    } else {
      var cookie = "";
      Shiny.onInputChange("jscookie", cookie);
    }
  }
  shinyjs.setcookie = function(params) {
    Cookies.set("id", escape(params));
    Shiny.onInputChange("jscookie", params);
  }
  shinyjs.rmcookie = function(params) {
    Cookies.remove("id");
    Shiny.onInputChange("jscookie", "");
  }
'

jscode2 <- '$(document).keyup(function(e) {
    if (e.key == "Enter") {
    $("#geneName2_search").click();
}});'

jscode3 <-
  '$(document).on("shiny:connected", function(e) {
  var jsWidth = screen.width;
  Shiny.onInputChange("GetScreenWidth",jsWidth);
});
'

jscode4 <- "shinyjs.init = function() {
  window.onpopstate = function (event) {
    Shiny.onInputChange('navigatedTo', location.search);
  } 
}
shinyjs.updateHistory = function(params) {
  var queryString = [];
  for (var key in params) {
    queryString.push(encodeURIComponent(key) + '=' + encodeURIComponent(params[key]));
  }
  queryString = '?' + queryString.join('&');
  history.pushState(null, null, queryString)
}"

organism <- c("human,celegans,mouse")
#ui part
shinyApp(
  ui = fluidPage(
    # Logo
    div(
      id = "logo",
      tags$a(
        tags$img(
          src='http://agubiogen.org/wp-content/uploads/2021/02/AGUBioGen-logo-100.png', height='40', width='40'),
      ),
      style = "display: inline-block; padding-left: 10px;"
    ),
    
    div(
      id = "logo-text",
      h4('Celegans Atlas'),
      style = "display: inline-block; color: #00bcd4; padding-bottom: 10px;"
    ),
    
    theme = shinytheme("spacelab"), 
    titlePanel(
      "Celegans Atlas"),
    
    # Menu
    div(
      id = "tabs1",
      sidebarMenu(
        id = "tabs",
        # tab panel 2 - Comparison
        textInput("txt", "Search:", "What are you doing?"),
        # ----------------------------------
        # tab panel 2 - Comparison
        actionButton("action", "Compare"),
        actionButton("action2", "More info", class = "btn-primary"),
        # ----------------------------------
        # tab panel 2 - Comparison
        menuItem("Gene search", tabName = "hometab", icon = icon("home")),
        # ----------------------------------
        # tab panel 2 - Comparison
        menuItem("Explore data", tabName = "exploretab", icon = icon("search")),
        # tab panel 2 - Comparison
        menuItem("How to use Celegans Atlas", tabName = "howtab", icon = icon("question-circle")),
        # tab panel 2 - Comparison
        menuItem("Data", tabName = "datatab", icon = icon("database"),
                 menuSubItem("Source",tabName = "sourcetab",icon = icon("file")),
                 menuSubItem("Download", tabName = "downloadtab", icon = icon("download"))
        ),
        menuItem("About", tabName = "abouttab", icon = icon("address-card")),
        actionBttn(
          inputId = "helpbutton",
          label = "Help",
          icon = icon("question-circle"),
          style = "bordered",
          color = "primary",
          size = "sm"
        )
      )
    ),
    mainPanel(
      tabsetPanel(
        navbarMenu(("About"), #sekme_1
                   tabPanel("Research"),
                   tabPanel(("Kaplan Lab"),
                            hr("About web site"))),
        tabPanel(("Compare"),#sekme_2
                 radioButtons("organism", "Choose organism", organism),
                 fluidRow(
                   column(3, selectInput(
                     "demo_dt", "Choose a Demo Data", choices = c(
                       "3D Celegans Confocal" = "/Users/iremkahveci/Downloads/img.png",
                       "4D Celegans Confocal" = "data/4d_fmri.nii.gz"))),
                   column(1, h5("Or"), class = "text-center", style = "padding-top: 15px;"),
                   column(4, fileInput("your_dt", "Upload .tiff .png")),
                   column(1, h2("|"), class = "text-center", 
                          style = "margin-top: -5px; "),
                   column(3, shinyWidgets::switchInput(
                     "interactive", "Interactive", onStatus = "success"), style = "padding-top: 25px;"))),
        
        tabPanel(("C. elegans"), #sekme_3
                 
                 
                 column(4, wellPanel(
                   sliderInput("rslide", "Radius :", min = 01, max = 10, value = 1, step = 1),
                   radioButtons("picture", "Picture:", c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10"))
                 )),
                 column(4,
                        imageOutput("image1", height = 600),
                        imageOutput("image2"),
                        imageOutput("image3"),
                        imageOutput("image4"),
                        imageOutput("image5"),
                        imageOutput("image6"),
                        imageOutput("image7"),
                        imageOutput("image8"),
                        imageOutput("image9"),
                        imageOutput("image10")
                 ),
                 
                 #hr("Upload file"),
                 #fileInput("upload", NULL)
                 
        ),
      ) ) ),
  ###server function
  
  
  server = function(input, output, session) { 
    # For writePNG function
    
    #function(input, output, session) 
    {
      
      # image1 creates a new PNG file each time Radius changes
      #output$image1 <- renderImage({
      # Get width and height of image1
      #width  <- session$clientData$output_image1_width
      # height <- session$clientData$output_image1_height
      
      # A temp file to save the output.
      # This file will be automatically removed later by
      # renderImage, because of the deleteFile=TRUE argument.
      # outfile <- tempfile(fileext = ".png")
      
      # Generate the image and write it to file
      #x <- matrix(rep((0:(width-1))/(width-1), height), height,
      #            byrow = TRUE)
      #y <- matrix(rep((0:(height-1))/(height-1), width), height)
      #pic <- gauss2d(x, y, input$r)
      #writePNG(pic, target = outfile)
      
      # Return a list containing information about the image
      # list(src = outfile,
      #     contentType = "image/png",
      #     width = width,
      #     height = height,
      #     alt = "This is alternate text")
      
      #}, deleteFile = TRUE)
      
      
      # image2 sends pre-rendered images
      
      
      output$image1 <- renderImage({
        if (is.null(input$rslide))
          return(NULL)
        
        if (input$rslide == "1") { return(list(src = "images/01.jpg", filetype = "image/jpeg", alt = "01 Nolu Resim" )) }
        else if (input$rslide == "2") { return(list(src = "images/02.jpg", filetype = "image/jpeg", alt = "02 Nolu Resim" )) }
        else if (input$rslide == "3") { return(list(src = "images/03.jpg", filetype = "image/jpeg", alt = "03 Nolu Resim" )) }
        else if (input$rslide == "4") { return(list(src = "images/04.jpg", filetype = "image/jpeg", alt = "04 Nolu Resim" )) }
        else if (input$rslide == "5") { return(list(src = "images/05.jpg", filetype = "image/jpeg", alt = "05 Nolu Resim" )) }
        else if (input$rslide == "6") { return(list(src = "images/06.jpg", filetype = "image/jpeg", alt = "06 Nolu Resim" )) }
        else if (input$rslide == "7") { return(list(src = "images/07.jpg", filetype = "image/jpeg", alt = "07 Nolu Resim" )) }
        else if (input$rslide == "8") { return(list(src = "images/08.jpg", filetype = "image/jpeg", alt = "08 Nolu Resim" )) }
        else if (input$rslide == "9") { return(list(src = "images/09.jpg", filetype = "image/jpeg", alt = "09 Nolu Resim" )) }
        else if (input$rslide == "10") {return(list(src = "images/10.jpg", filetype = "image/jpeg", alt = "10 Nolu Resim" )) }
      }, deleteFile = FALSE)
      
      # ***
      
      output$image2 <- renderImage({
        if (is.null(input$picture))
          return(NULL)
        
        if (input$picture == "01") {return(list(src = "images/01.jpg", filetype = "image/jpeg", alt = "01 Nolu Resim" )) }
        else if (input$picture == "02") {return(list(src = "images/02.jpg", filetype = "image/jpeg", alt = "02 Nolu Resim" )) }
        else if (input$picture == "03") {return(list(src = "images/03.jpg", filetype = "image/jpeg", alt = "03 Nolu Resim" )) }
        else if (input$picture == "04") {return(list(src = "images/04.jpg", filetype = "image/jpeg", alt = "04 Nolu Resim" )) }
        else if (input$picture == "05") {return(list(src = "images/05.jpg", filetype = "image/jpeg", alt = "05 Nolu Resim" )) }
        else if (input$picture == "06") {return(list(src = "images/06.jpg", filetype = "image/jpeg", alt = "06 Nolu Resim" )) }
        else if (input$picture == "07") {return(list(src = "images/07.jpg", filetype = "image/jpeg", alt = "07 Nolu Resim" )) }
        else if (input$picture == "08") {return(list(src = "images/08.jpg", filetype = "image/jpeg", alt = "08 Nolu Resim" )) }
        else if (input$picture == "09") {return(list(src = "images/09.jpg", filetype = "image/jpeg", alt = "09 Nolu Resim" )) }
        else if (input$picture == "10") {return(list(src = "images/10.jpg", filetype = "image/jpeg", alt = "10 Nolu Resim" )) }
        
      }, deleteFile = FALSE)
      
    } } )

#shinyApp(ui = ui, server = server)

## Footer ----

## Footer ----