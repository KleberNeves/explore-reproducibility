# Define UI
ui <- fluidPage(
    
    # Application title
    titlePanel("Reproducibility Curve"),
    
    fluidRow(
        
        column(3,
            
            sliderInput("repro_value", "Reproducibility", min = 0, max = 100, step = 5, value = c(0,100), post = "%"),
            hr(),
            sliderInput("bias_value", "Bias", min = 0, max = 100, step = 10, value = c(0,100), post = "%"),
            
            sliderInput("prevalence_value", "Prevalence", min = 0, max = 100, step = 10, value = c(0,100), post = "%"),
            
            sliderInput("interlab_value", "Interlab Variation", min = 1, max = 4, step = 1, value = c(1,4)),
            
            sliderInput("power_value", "Power", min = 0, max = 100, step = 10, value = c(0,100), post = "%")
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
    