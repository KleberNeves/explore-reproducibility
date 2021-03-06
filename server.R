server <- function(input, output, session) {
  
  observeEvent(c(input$repro_value_pi, input$repro_value_sss, input$repro_value_vote, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value, input$repro_measure, input$distribution), {
    repro_colname = repro_measure_choices[[input$repro_measure]]
    SELECTION <<- SIMS %>%
      mutate(repro_rate = SIMS[,repro_colname]) %>%
      rename(
        repro_rate_pi = `Orig-in-RMA-PI_ReproRate_All`,
        repro_rate_sss = `RMA-SSS_ReproRate_All`,
        repro_rate_vote = `VOTE-SSS_ReproRate_All`
      ) %>%
      filter(
        distribution == input$distribution,
        repro_rate_pi >= input$repro_value_pi[1] / 100 & repro_rate_pi <= input$repro_value_pi[2] / 100 &
        repro_rate_sss >= input$repro_value_sss[1] / 100 & repro_rate_sss <= input$repro_value_sss[2] / 100 &
        repro_rate_vote >= input$repro_value_vote[1] / 100 & repro_rate_vote <= input$repro_value_vote[2] / 100 &
        bias.level >= input$bias_value[1] / 100 & bias.level <= input$bias_value[2] / 100 &
        typical.power >= input$power_value[1] / 100 & typical.power <= input$power_value[2] / 100 &
        weightB >= input$prevalence_value[1] / 100 & weightB <= input$prevalence_value[2] / 100 &
        interlab.var.p >= input$interlab_value[1] / 100 & interlab.var.p <= input$interlab_value[2] / 100
      )
    
    if (nrow(SELECTION) > 1000) {
      SELECTION <<- SELECTION %>% sample_n(1000)
    }
  })
  
  draw_bias_plot = eventReactive(c(input$repro_value_pi, input$repro_value_sss, input$repro_value_vote, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value, input$repro_measure, input$distribution), {
    ggplot(SELECTION) +
      aes(x = as.factor(bias.level)) +
      geom_bar() +
      labs(x = "Bias", y = "") +
      theme_minimal()
  })
  
  draw_prevalence_plot = eventReactive(c(input$repro_value_pi, input$repro_value_sss, input$repro_value_vote, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value, input$repro_measure, input$distribution), {
    ggplot(SELECTION) +
      aes(x = as.factor(weightB)) +
      geom_bar() +
      labs(x = "Prevalence", y = "") +
      theme_minimal()
  })
  
  draw_interlab_plot = eventReactive(c(input$repro_value_pi, input$repro_value_sss, input$repro_value_vote, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value, input$repro_measure, input$distribution), {
    ggplot(SELECTION) +
      aes(x = as.factor(interlab.var.p)) +
      geom_bar() +
      labs(x = "Interlab variation", y = "") +
      theme_minimal()
  })
  
  draw_power_plot = eventReactive(c(input$repro_value_pi, input$repro_value_sss, input$repro_value_vote, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value, input$repro_measure, input$distribution), {
    ggplot(SELECTION) +
      aes(x = as.factor(typical.power)) +
      geom_bar() +
      labs(x = "Power", y = "") +
      theme_minimal()
  })
  
  draw_repro_plot = eventReactive(c(input$repro_value_pi, input$repro_value_sss, input$repro_value_vote, input$bias_value, input$prevalence_value, input$interlab_value, input$power_value, input$repro_measure, input$distribution), {
    
    # Making the plot with reproducibility rates
    plot_repro = ggplot(SELECTION) +
      aes(x = reorder(index, repro_rate), y = repro_rate) +
      geom_point(size = 0.5) +
      labs(x = "", y = "Reproducibility Rate") +
      ylim(c(0,1)) +
      theme_minimal() +
      theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
            panel.grid = element_blank(), plot.title = element_blank())

    # Making the frequency of specifications graph
    SPECIFICATION = SELECTION %>%
      select(all_of(c("index","repro_rate", spec_parameters))) %>%
      pivot_longer(cols = -c(index, repro_rate)) %>%
      mutate(param = name,
             param_type = ifelse(str_detect(param, "Above"), "Above Min",
                          ifelse(str_detect(param, "Bias"), "Bias",
                          ifelse(str_detect(param, "Power"), "Power",
                          ifelse(str_detect(param, "Interlab"), "Interlab Var","")))),
             param_type = factor(param_type, levels = c("Power","Interlab Var","Bias","Above Min")))
    
    DF = SPECIFICATION %>%
      arrange(repro_rate)
    
    unique_indexes = unique(DF$index)
    DF$bindex = map_int(DF$index, function (x) { which(unique_indexes == x) })
      
    DF = DF %>%
      mutate(bin = (bindex - 1) %/% 10) %>%
      group_by(bin, param_type, param, .drop = F) %>%
      summarise(N = sum(value)) %>%
      mutate(perc = N / sum(N))
    
    plot_spec = ggplot(DF) +
      aes(x = bin, y = perc, fill = param) +
      geom_col(position = "stack") +
      labs(x = "", y = "") +
      scale_fill_manual(breaks = spec_parameters, values = spec_colors) +
      scale_x_discrete(expand = c(0,0)) +
      scale_y_continuous(breaks = c(0, 0.5, 1)) +
      facet_wrap(~param_type, ncol = 1) +
      theme_minimal() +
      theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
            panel.grid = element_blank(), legend.position = "none",
            axis.text.y = element_text(size = 11))
  
    # Making the specification curve graph  
    SPECIFICATION = SELECTION %>%
      select(all_of(c("index","repro_rate", spec_parameters))) %>%
      pivot_longer(cols = -c(index, repro_rate)) %>%
      mutate(param = name)

    plot_spec2 = ggplot(SPECIFICATION) +
      aes(x = reorder(index, repro_rate), y = name, fill = param, alpha = as.numeric(value)) +
      geom_tile(height = 0.4) +
      scale_alpha(range = c(0,1)) +
      scale_fill_manual(breaks = spec_parameters, values = spec_colors) +
      labs(x = "", y = "") +
      theme_minimal() +
      theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
            legend.position = "none", panel.grid = element_blank(),
            axis.text.y = element_text(size = 11), plot.title = element_blank())
    
    # Plotting the aligned graphs
    plot_grid(plot_repro, plot_spec2, plot_spec, align = "v", axis = "l",
              ncol = 1, nrow = 3, rel_heights = c(1,1.5,1.5))
  })
  
  output$repro_plot = renderPlot({
    draw_repro_plot()
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