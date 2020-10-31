library(shiny)
library(tidyverse)

N = 1000

SIMS = data.frame(
  index = 1:N,
  param1 = sample(c(T,F), N, replace = T),
  param2 = runif(N, 0, 1),
  param3 = sample(1:4, N, replace = T)
) %>%
  mutate(
    repro_rate = (30 + param1 * 40 - param2 * 30 + param3 * 7.5) / 100
  )

# Transforming all parameters in booleans
SIMS = SIMS %>% mutate(
  # Logical parameters: remain the same
  param1_T = param1,
  # Numerical parameters: are broken into a few categories
  param2_0.1 = param2 >= 0 & param2 < 0.25,
  param2_0.3 = param2 >= 0.25 & param2 < 0.5,
  param2_0.5 = param2 >= 0.5 & param2 < 0.75,
  param2_0.7 = param2 >= 0.75 & param2 <= 1,
  
  param3_1 = param3 == 1,
  param3_2 = param3 == 2,
  param3_3 = param3 == 3,
  param3_4 = param3 == 4
)

SELECTION = SIMS