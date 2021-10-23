library(tidyverse)
library(dplyr)
library(ggfortify)
storms <- dplyr::storms

filter(storms, year == 1998, category >= -1) %>%
# (cat5_05_10 <- filter(storms, between(year, 2005, 2010), category == 5))
pri <- filter(storms, !is.na(ts_diameter) | !is.na(hu_diameter))

# arrange(storms, desc(wind))
# arrange(storms, desc(category), lat) # Lowest to highest recorded latitude, in desc category. 
arrange(storms, desc(year), pressure) # Lowest to highest recorded pressure in a year, latest first.


select(storms, Name = name, category:pressure)
select(storms, starts_with(c("n", "w", "p")))
#storms %>% select(starts_with(c("l")))

mutate(storms, date = paste(day, month, year, sep="-")) %>%
  select(name, date, category, pressure) %>%
  slice_sample(n = 10)
# transmute(storms,Name = name, date = paste(year, month, day, sep="/"),disk_width = ts_diameter - hu_diameter 
#           # Transition Disk? 
#           ) %>%
#   filter(!is.na(disk_width)) %>%
#   slice_sample(n = 10)

group_by(storms, category) %>% summarise(avg_wind = mean(wind))
# group_by(storms, status) %>% summarise(avg_wind = mean(wind))

data(package = .packages(all.available = TRUE))

(storm_month <- storms %>% 
    mutate(
      mon = if_else(
        month < 10, 
        str_pad(month, width = 2, side = "left", pad = "0"), 
        paste(month)
      )
    ) %>% 
    group_by(Month = mon) %>% 
    distinct(name) %>% 
    summarise(No_of_Storms = n())
)
