# Sparkline example
library(DT)
library(tidyr)
library(dplyr)
library(sparkline)

prices <- data.frame(stringsAsFactors=FALSE,
                     MetroArea = c("Boston", "Detroit", "Phil", "SanFran", "SiValley"),
                     Q1_1996 = c(106.44, 107.99, 105.25, 100.72, 102.93),
                     Q1_1998 = c(116.78, 127.83, 107.15, 117.25, 126.01),
                     Q1_2000 = c(148.58, 150.8, 111.73, 159.11, 170.74),
                     Q1_2002 = c(189.41, 170.34, 132.86, 195.5, 205.14),
                     Q1_2004 = c(234.68, 181.89, 164.54, 223.02, 223.33),
                     Q1_2006 = c(272.14, 186.43, 219.74, 305.88, 311.17),
                     Q1_2008 = c(253.33, 158.29, 234.13, 291.35, 293.01),
                     Q1_2010 = c(227.91, 117.45, 219.46, 248.28, 238.12),
                     Q1_2012 = c(224.55, 111.14, 211.24, 238.37, 233),
                     Q1_2014 = c(237.61, 130.59, 214.87, 306.24, 300.89),
                     Q1_2016 = c(264.23, 148.26, 227.5, 387.34, 367.1),
                     Q1_2018 = c(300.96, 170.92, 258.49, 447.45, 428.45),
                     Change = c(2.01, 0.709, 1.585, 3.474, 3.284)
)


tidyprices <- prices %>%
  select(-Change) %>%
  gather(key ="Quarter", value ="Price", Q1_1996:Q1_2018)

tidyprices %>% group_by(MetroArea)

prices_sparkline_data <- tidyprices %>%
  group_by(MetroArea) %>%
  summarize(
    TrendSparkline = spk_chr(
      Price, type ="line",
      chartRangeMin = 100, chartRangeMax = max(Price)
    )
  )


prices <- left_join(prices, prices_sparkline_data)

#format
#sparkline_column = spk_chr(
#  vector_of_values, type ="type_of_chart",
#  chartRangeMin=0, chartRangeMax=max(.$vector_of_values)
#)

datatable(prices, 
          escape = FALSE,
          filter = 'top', 
          options = list(paging = FALSE
          )
) %>% 
  formatPercentage('Change', digits = 1)


datatable(prices, 
          escape = FALSE,
          filter = 'top', 
          options = list(paging = FALSE, 
                         fnDrawCallback = htmlwidgets::JS(
                           'function() {HTMLWidgets.staticRender();}')
                         )
          ) %>% 
  spk_add_deps() %>% 
  formatPercentage('Change', digits = 1)
