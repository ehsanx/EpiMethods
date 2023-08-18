library(shiny)

ui <- fluidPage(
  titlePanel("Calculator based on 2 numbers"),
  sidebarLayout(
    sidebarPanel(
      numericInput("num1", "Enter the first number:", value = 0),
      numericInput("num2", "Enter the second number:", value = 0),
      selectInput("operator", "Select an operator:",
                  choices = c("+", "-", "*", "/", "^", "%/% (integer division)", "%% (modulo or remainder)", "min", "max"))
    ),
    mainPanel(
      verbatimTextOutput("result")
    )
  )
)

server <- function(input, output) {
  output$result <- renderPrint({
    num1 <- input$num1
    num2 <- input$num2
    operator <- input$operator
    
    result <- switch(operator,
                     "+" = num1 + num2,
                     "-" = num1 - num2,
                     "*" = num1 * num2,
                     "/" = num1 / num2,
                     "^" = num1 ^ num2,
                     "%/% (integer division)" = num1 %/% num2,
                     "%% (modulo or remainder)" = num1 %% num2,
                     "min" = min(num1, num2),
                     "max" = max(num1, num2))
    
    paste("Result:", result)
  })
}

shinyApp(ui = ui, server = server)
