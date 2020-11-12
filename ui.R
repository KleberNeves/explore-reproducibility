# Define UI
ui <- fluidPage(
    
    # Application title
    titlePanel("Reproducibility Curve"),
    
    fluidRow(
        
        column(3,
            selectInput("repro_measure", "Measure", choices = names(repro_measure_choices)),
            
            sliderInput("repro_value", "Reproducibility", min = 0, max = 100, step = 5, value = c(0,100), post = "%"),
            hr(),
            sliderInput("bias_value", "Bias", min = 0, max = 100, step = 10, value = c(0,100), post = "%"),
            
            sliderInput("prevalence_value", "Prevalence", min = 0, max = 100, step = 10, value = c(0,100), post = "%"),
            
            sliderInput("interlab_value", "Interlab Variation", min = 0, max = 100, step = 10, value = c(0,100)),
            
            sliderInput("power_value", "Power", min = 0, max = 100, step = 10, value = c(0,100), post = "%"),
            hr(),
            selectInput("distribution", "Underlying Model", choices = c("Two Peaks", "Single Normal"))
        ),
        
        column(6,
            plotOutput("repro_plot", height = 240),
            hr(),
            plotOutput("specification_plot", height = 330)
        ),
        
        column(3,
           selectInput("plot_type", "Plot Type", choices = c("Specification", "Frequency")),
           hr(),
           plotOutput("bias_plot", height = 130),
           plotOutput("prevalence_plot", height = 130),
           plotOutput("interlab_plot", height = 130),
           plotOutput("power_plot", height = 130)
        )
        
    )   
)
    