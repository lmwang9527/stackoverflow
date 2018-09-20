library(plotly)    

set.seed(1)
df <- data.frame(group1 = rep(c("low", "high"), each = 25),
                 x = rep(1:5, each = 5),
                 group2 = letters[1:5],
                 y = c(runif(25, 0, 2), runif(25, 3, 5)))

plot_ly(df, x = ~x, y = ~y, customdata=~group1, type = 'scatter',
        mode = 'line',
        color = ~group2,
        transforms = list(
          list(
            type = 'filter',
            target = 'customdata',
            operation = '=',
            value = 'high'
          )
        )
)


plot_ly(df %>% filter(group1=="high"), x = ~x, y = ~y, type = 'scatter',
        mode = 'line',
        color = ~group2
)



df <- data.frame(ID=1:3, 
                 Week_A=c(6,6,7), 
                 Weight_A=c(23,24,23), 
                 Week_B=c(7,7,8), 
                 Weight_B=c(25,26,27),
                 Week_C=c(8,9,9),
                 Weight_C=c(27,26,28))

library(tidyverse)
df_long <- df %>% gather(key="v", value="value", -ID) %>% 
  separate(v, into=c("v1", "v2")) %>% 
  spread(v1, value) %>% 
  complete(ID, Week) %>% 
  arrange(Week, ID)

df_long

df_long %>% select(-v2) %>% 
  spread(Week, Weight, sep="_")
