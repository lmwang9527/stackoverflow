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
# A tibble: 12 x 4
#      ID  Week v2    Weight
#   <int> <dbl> <chr>  <dbl>
# 1     1     6 A         23
# 2     2     6 A         24
# 3     3     6 <NA>      NA
# 4     1     7 B         25
# 5     2     7 B         26
# 6     3     7 A         23
# 7     1     8 C         27
# 8     2     8 <NA>      NA
# 9     3     8 B         27
#10     1     9 <NA>      NA
#11     2     9 C         26
#12     3     9 C         28

df_wide <- df_long %>% select(-v2) %>% 
  spread(Week, Weight, sep="_")
df_wide
# A tibble: 3 x 5
#     ID Week_6 Week_7 Week_8 Week_9
#  <int>  <dbl>  <dbl>  <dbl>  <dbl>
#1     1     23     25     27     NA
#2     2     24     26     NA     26
#3     3     NA     23     27     28
