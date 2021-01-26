# Define UI
ui <- fluidPage(
    
    # Application title
    titlePanel("Reproducibility Curve"),
    
    fluidRow(
        
        column(3,
            sliderInput("repro_value_pi", "Reproducibility (Pred. Int.)", min = 0, max = 100, step = 5, value = c(0,100), post = "%"),
            
            sliderInput("repro_value_sss", "Reproducibility (Signif.)", min = 0, max = 100, step = 5, value = c(0,100), post = "%"),
            
            sliderInput("repro_value_vote", "Reproducibility (Vote)", min = 0, max = 100, step = 5, value = c(0,100), post = "%"),
            
            hr(),
            
            sliderInput("power_value", "Power", min = 0, max = 100, step = 10, value = c(0,100), post = "%"),
            
            sliderInput("interlab_value", "Interlab Variation", min = 0, max = 100, step = 10, value = c(0,100)),
            
            sliderInput("bias_value", "Bias", min = 0, max = 100, step = 10, value = c(0,100), post = "%"),
            
            sliderInput("prevalence_value", "Prevalence", min = 0, max = 100, step = 10, value = c(0,100), post = "%")
            
        ),
        
        column(6,
            plotOutput("repro_plot", height = 600, width = "95%"),
            
            selectInput("repro_measure", "Measure to show", choices = names(repro_measure_choices)),
        ),
        
        column(3,
               selectInput("distribution", "Underlying Model", choices = c("Two Peaks", "Single Normal")),
           hr(),
           plotOutput("bias_plot", height = 130),
           plotOutput("prevalence_plot", height = 130),
           plotOutput("interlab_plot", height = 130),
           plotOutput("power_plot", height = 130)
        )
        
    )   
)
    