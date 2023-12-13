library(shiny)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # Expression that generates a plot of the distribution. The expression is
  # wrapped in a call to renderPlot to indicate that:
  # 
  # 1) It is 'reactive' and therefore should be automatically re-executed
  # when inputs change 2) Its output type is a plot
  output$distPlot = renderPlot({
    
    # generate an rnorm distribution and plot it
    dist = rnorm(input$obs)
    hist(dist)
  })
  
})

library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Hello Shiny!"),
  
  # Sidebar with inputs for number of observations, mean, SD, and coler.
  sidebarPanel(
    sliderInput("obs", "Number of observations:", min = 0, max = 1000, value = 500),
    numericInput("M", "Mean of this normal distribution:", min = -200, max = 200, value = 100),
    numericInput("S", "SD of this normal distribution:", min = 0, max = 50, value = 10),
    radioButtons("Color", "Select the color of histogram:", choices = c("Red" = "red", "Blue" = "blue", "Green" = "green"))
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
))


library(shiny)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # Expression that generates a plot of the distribution. The expression is
  # wrapped in a call to renderPlot to indicate that:
  # 
  # 1) It is 'reactive' and therefore should be automatically re-executed
  # when inputs change 2) Its output type is a plot
  output$distPlot = renderPlot({
    
    # generate an rnorm distribution and plot it
    dist = rnorm(input$obs,mean=input$M,sd=input$S)
    hist(dist,col=input$Color)
  })
  
})


list_to_string <- function(obj, listname) {
  if (is.null(names(obj))) {
    paste(listname, "[[", seq_along(obj), "]] = ", obj,
          sep = "", collapse = "\n")
  } else {
    paste(listname, "$", names(obj), " = ", obj,
          sep = "", collapse = "\n")
  }
}

function(input, output, session) {
  
  # Print out clientData, which is a reactiveValues object.
  # This object is list-like, but it is not a list.
  output$summary <- renderText({
    # Find the names of all the keys in clientData
    cnames <- names(session$clientData)
    
    # Apply a function to all keys, to get corresponding values
    allvalues <- lapply(cnames, function(name) {
      item <- session$clientData[[name]]
      if (is.list(item)) {
        list_to_string(item, name)
      } else {
        paste(name, item, sep=" = ")
      }
    })
    paste(allvalues, collapse = "\n")
  })
  
  # Parse the GET query string
  output$queryText <- renderText({
    query <- parseQueryString(session$clientData$url_search)
    
    # Return a string with key-value pairs
    paste(names(query), query, sep = "=", collapse=", ")
  })
  
}
