library(shiny)
library(tidyverse)

load(file = "sim_data.RData")
SIMS = repdata
rm(repdata)

SIMS = SIMS %>%
  rename(AboveMin = `% Above minimum`)

SIMS$weightB = ifelse(SIMS$AboveMin %in% c(0.2,0.4,0.6,0.8), SIMS$AboveMin,
  ifelse(SIMS$AboveMin == 0.21, 0.2,
         ifelse(SIMS$AboveMin == 0.41, 0.4,
                ifelse(SIMS$AboveMin == 0.61, 0.6,
                       ifelse(SIMS$AboveMin == 0.62, 0.6, 0.8)))))
SIMS = SIMS %>%
  mutate(
    weight.label = paste0("Above Min. = ", 100 * weightB, "%"),
    power.label = paste0("Power = ", 100 * typical.power, "%"),
    bias.label = paste0("Bias = ", 100 * bias.level, "%"),
    interlab.var.p = round(interlab.var / (interlab.var + 1), 2),
    interlab.label = paste0("Interlab Var. = ", round(100 * interlab.var / (interlab.var + 1), 0), "%")
  )

# Transforming all parameters in indicators
parameters_cols = c("weight.label","bias.label","interlab.label","power.label")

SIMS_WIDE = bind_cols(
  map(1:length(parameters_cols), function (i) {
    par_col = parameters_cols[i]
    values = unique(SIMS[[par_col]])
    DF = bind_cols(
      map(values, function (x) {
        df = data.frame(value = SIMS[[par_col]] == x)
        colnames(df) = x
        df
      })
    )
  })
)

SIMS = bind_cols(list(SIMS, SIMS_WIDE))

SIMS$index = 1:nrow(SIMS)
SIMS$repro_rate = SIMS$`Orig-in-RMA-PI_ReproRate_All`

SELECTION = SIMS