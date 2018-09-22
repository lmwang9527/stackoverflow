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



