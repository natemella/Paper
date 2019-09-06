

### load r packages


library(tidyverse)
library(readr)
library(stringr)


### download data set

list_of_dfs = list()
i <- 1
for (file in list.files(path = getwd())) {
  if ((startsWith(file, "combination_of_")) &(endsWith(file, "tsv"))) {
    df <- read_tsv(file)
    df = df %>% group_by(Algorithm) %>% summarise(AUROC = mean(AUROC)) %>% mutate(Combination = str_wrap(str_replace(file, ".tsv", ""), width= 2))
    list_of_dfs[[i]] <- df
    i <- i + 1
  }
}
df <- do.call("rbind", list_of_dfs)

df <- df %>% mutate(Combination = factor(Combination))

#"#8c510a","#bf812d","#dfc27d","#f6e8c3","#f5f5f5","#c7eae5","#80cdc1","#35978f","#01665e"
#"#40004b", "#762a83", "#9970ab", "#c2a5cf", "#e7d4e8", "#d9f0d3", "#a6dba0", "#5aae61", "#1b7837", "#00441b")
#"#1f77b4", "#ff7f0e", #2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"

cbPalette <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")
i = 1
df %>% ggplot(aes(x = Combination, y = AUROC, color = Algorithm, fill = Algorithm)) +
  theme_bw() +
  geom_point() +
  geom_line(aes(group=df$Algorithm)) +
  scale_color_manual(values = cbPalette) +
  theme() +
  # facet_grid(rows = vars(Algorithm)) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 2)) +
  xlab("Trial Differences")

ggsave("graphs/combination_difference_facted.png", height = 7, width = 15)


