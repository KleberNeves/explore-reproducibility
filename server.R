server <- function(input, output, session) {
  
  observeEvent(c(input$repro_value, input$param1_value, input$param2_value, input$param3_value), {
    if (input$param1_value == "All") { p1_value = c(T,F) }
    else { p1_value = input$param1_value == "TRUE" }

    SELECTION <<- SIMS %>%
      filter(
        repro_rate >= input$repro_value[1] / 100 & repro_rate <= input$repro_value[2] / 100 &
        param1 %in% p1_value &
        param2 >= input$param2_value[1] & param2 <= input$param2_value[2] &
        param3 >= input$param3_value[1] & param3 <= input$param3_value[2])
    
    if (nrow(SELECTION) > 1000) {
      SELECTION <<- SELECTION %>% sample_n(1000)
    }
  })
  
  draw_param1_plot = eventReactive(c(input$repro_value, input$param1_value, input$param2_value, input$param3_value), {
    ggplot(SELECTION) +
      aes(x = param1) +
      geom_bar() +
      theme_minimal()
  })
  
  draw_param2_plot = eventReactive(c(input$repro_value, input$param1_value, input$param2_value, input$param3_value), {
    ggplot(SELECTION) +
      aes(x = param2) +
      geom_density() +
      xlim(c(0,1)) +
      theme_minimal()
  })
  
  draw_param3_plot = eventReactive(c(input$repro_value, input$param1_value, input$param2_value, input$param3_value), {
    ggplot(SELECTION) +
      aes(x = param3) +
      geom_bar() +
      theme_minimal()
  })
  
  draw_repro_plot = eventReactive(c(input$repro_value, input$param1_value, input$param2_value, input$param3_value), {
    ggplot(SELECTION) +
      aes(x = reorder(index, repro_rate), y = repro_rate) +
      geom_point(size = 0.5) +
      labs(x = "", y = "Reproducibility Rate") +
      theme_minimal() +
      theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
            panel.grid = element_blank())
  })
  
  draw_specification_plot = eventReactive(c(input$repro_value, input$param1_value, input$param2_value, input$param3_value), {
    SPECIFICATION = SELECTION %>%
      select(index, repro_rate, param1_T, param2_0.1, param2_0.3, param2_0.5, param2_0.7, param3_1, param3_2, param3_3, param3_4) %>%
      pivot_longer(cols = -c(index, repro_rate)) %>%
      mutate(param = str_extract(name, "param[0-9]"))

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
  
  output$param1_plot = renderPlot({
    draw_param1_plot()
  })
  
  output$param2_plot = renderPlot({
    draw_param2_plot()
  })
  
  output$param3_plot = renderPlot({
    draw_param3_plot()
  })
}