# Define UI
ui <- fluidPage(
    
    # Application title
    titlePanel("Reproducibility Curve"),
    
    fluidRow(
        
        column(3,
            
            sliderInput("repro_value", "Reproducibility", min = 0, max = 100, step = 5, value = c(0,100), post = "%"),
            hr(),
            selectInput("param1_value", "Parameter 1", choices = c("All","TRUE","FALSE"), selected = "All"),
            
            sliderInput("param2_value", "Parameter 2", min = 0, max = 1, step = 0.1, value = c(0,1)),
            
            sliderInput("param3_value", "Parameter 3", min = 1, max = 4, step = 1, value = c(1,4))
        ),
        
        column(6,
            plotOutput("repro_plot", height = 240),
            hr(),
            plotOutput("specification_plot", height = 180)
        ),
        
        column(3,
           plotOutput("param1_plot", height = 170),
           plotOutput("param2_plot", height = 170),
           plotOutput("param3_plot", height = 170)
        )
        
    )   
)
    