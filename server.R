server <- function(input, output, session) {
  
  observeEvent(c(input$repro_value, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value), {
    SELECTION <<- SIMS %>%
      filter(
        repro_rate >= input$repro_value[1] / 100 & repro_rate <= input$repro_value[2] / 100 &
        bias.level >= input$bias_value[1] / 100 & bias.level <= input$bias_value[2] / 100 &
        typical.power >= input$power_value[1] / 100 & typical.power <= input$power_value[2] / 100 &
        weightB >= input$prevalence_value[1] / 100 & weightB <= input$prevalence_value[2] / 100 &
        interlab.var.p >= input$interlab_value[1] / 100 & interlab.var <= input$interlab_value[2] / 100
      )
    
    if (nrow(SELECTION) > 1000) {
      SELECTION <<- SELECTION %>% sample_n(1000)
    }
  })
  
  draw_bias_plot = eventReactive(c(input$repro_value, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value), {
    ggplot(SELECTION) +
      aes(x = bias.level) +
      geom_bar() +
      theme_minimal()
  })
  
  draw_prevalence_plot = eventReactive(c(input$repro_value, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value), {
    ggplot(SELECTION) +
      aes(x = weightB) +
      geom_density() +
      xlim(c(0,1)) +
      theme_minimal()
  })
  
  draw_interlab_plot = eventReactive(c(input$repro_value, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value), {
    ggplot(SELECTION) +
      aes(x = interlab.var) +
      geom_bar() +
      theme_minimal()
  })
  
  draw_power_plot = eventReactive(c(input$repro_value, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value), {
    ggplot(SELECTION) +
      aes(x = typical.power) +
      geom_bar() +
      theme_minimal()
  })
  
  draw_repro_plot = eventReactive(c(input$repro_value, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value), {
    ggplot(SELECTION) +
      aes(x = reorder(index, repro_rate), y = repro_rate) +
      geom_point(size = 0.5) +
      labs(x = "", y = "Reproducibility Rate") +
      theme_minimal() +
      theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
            panel.grid = element_blank())
  })
  
  draw_specification_plot = eventReactive(c(input$repro_value, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value), {
    SPECIFICATION = SELECTION %>%
      select(all_of(c("index","repro_rate","Above Min. = 20%","Above Min. = 40%","Above Min. = 80%","Above Min. = 60%","Bias = 0%","Bias = 50%","Bias = 20%","Bias = 80%","Interlab Var. = 0%","Interlab Var. = 50%","Interlab Var. = 67%","Interlab Var. = 33%","Power = 20%","Power = 50%","Power = 80%"))) %>%
      pivot_longer(cols = -c(index, repro_rate)) %>%
      mutate(param = name)

    ggplot(SPECIFICATION) +
      aes(x = reorder(index, repro_rate), y = name, fill = param, alpha = as.numeric(value)) +
      geom_tile() +
      scale_alpha(range = c(0,1)) +
      labs(x = "", y = "") +
      theme_minimal() +
      theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
            legend.position = "none", panel.grid = element_blank(),
            axis.text.y = element_text(size = 11))
  })
  
  output$repro_plot = renderPlot({
    draw_repro_plot()
  })
  
  output$specification_plot = renderPlot({
    draw_specification_plot()
  })
  
  output$bias_plot = renderPlot({
    draw_bias_plot()
  })
  
  output$prevalence_plot = renderPlot({
    draw_prevalence_plot()
  })
  
  output$interlab_plot = renderPlot({
    draw_interlab_plot()
  })
  
  output$power_plot = renderPlot({
    draw_power_plot()
  })
}