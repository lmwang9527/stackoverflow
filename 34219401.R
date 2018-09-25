df <- data.frame(group = c(1, 1, 2, 2, 2))
require(plyr)
ddply(df, .(group), mutate, value = c(10, 10, 10), .inform=TRUE)

require(tidyverse)
df %>% group_by(group) %>% 
  mutate(value = c(10, 10, 10))

# unsubmitted  
df_result <- df %>% group_by(group) %>% 
  nest() %>% 
  mutate(data=map(data, safely(~mutate(., value=c(10, 10, 10)))),
         result=map(data, "result"),
         error=map(data, "error"))

df_result %>% 
  filter(map_int(result, length)!=0) %>% 
  unnest(result)

df_result %>% 
  filter(map_int(error, length)!=0) %>% 
  mutate(err_msg = map_chr(error, as.character))
