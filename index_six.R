# Title     : TODO
# Objective : TODO
# Created by: nathanmella
# Created on: 2019-08-01

library(tidyverse)
library(readr)
library(stringr)


### download data set

list_of_dfs = list()
i <- 1
for (file in list.files(path = getwd())) {
  if (endsWith(file, "tsv")) {
    df <- read_tsv(file)
    df = df %>% group_by(Description, Algorithm, CancerType) %>% summarise(AUROC = mean(AUROC))
    df = df %>% group_by() %>% summarise(AUROC = max(AUROC)) %>% mutate(Combination = str_wrap(str_replace(file, ".tsv", ""), width= 2))
    list_of_dfs[[i]] <- df
    i <- i + 1
  }
}
df <- do.call("rbind", list_of_dfs)

df <- df %>% mutate(Combination = factor(Combination))

### average AUROC grouped by cancer type, algorithm and description(data type)

#"#8c510a","#bf812d","#dfc27d","#f6e8c3","#f5f5f5","#c7eae5","#80cdc1","#35978f","#01665e"
#"#40004b", "#762a83", "#9970ab", "#c2a5cf", "#e7d4e8", "#d9f0d3", "#a6dba0", "#5aae61", "#1b7837", "#00441b")
#"#1f77b4", "#ff7f0e", #2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"

cbPalette <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")
df %>%
  ggplot(aes(x = Combination, y = AUROC,group=1)) +
  theme_bw() +
  geom_point() +
  geom_line() +
  scale_color_manual(values = cbPalette) +
  theme() +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 2)) +
  xlab("Trial Differences")

ggsave("graphs/index_six.png", height = 7, width = 15, dpi = 300)
