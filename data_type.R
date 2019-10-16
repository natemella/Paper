if (!require("pacman")) install.packages("pacman"); library(pacman)
p_load(tidyverse)


### download data set

args <- commandArgs(trailingOnly = TRUE)


df2 <- read_tsv(args[1]) %>%
  mutate(CancerType = str_replace(CancerType, "^TCGA_", ""), Algorithm=factor(Algorithm)) %>%
  group_by(Algorithm, CancerType, Description) %>%
  summarize(AUROC=mean(AUROC))

df2 = df2 %>%
  group_by(Algorithm, Description) %>%
  summarise(AUROC=mean(AUROC)) %>% rename("Data Type" = Description)


# df2 %>% group_by(CancerType, Description) %>% summarize(AUROC = max(AUROC)) %>% inner_join(df2, by = c("AUROC", "CancerType", "Description"))
#
# df3 <- df2 %>% group_by(CancerType, Description) %>% summarize(AUROC = max(AUROC)) %>% inner_join(df2, by = c("AUROC", "CancerType", "Description"))


# ### average AUROC grouped by cancer type, algorithm and description(data type)
#
#
# dfmean = df %>% group_by(CancerType, Algorithm, Description) %>% summarise(AUROC = mean(AUROC))
#
# ### assign ranks to each algorithm grouped by cancer type and description(data type)
#
#
# dfranked = dfmean %>% group_by(CancerType, Description) %>% mutate(rank = rank(-AUROC)) %>% arrange(CancerType, Algorithm, rank)
#
#
# ### find the average across all cancer types grouped by description(data type) and algorithm
#
#
# dfAveragedRanks = dfranked %>% group_by(Description, Algorithm) %>% summarise(avg_alg_rank = mean(rank)) %>% arrange(Algorithm)


### make and save plot

graph_name <- paste("graphs/most_predictive_datatype",args[2],".png", sep="")
cbPalette <- c("#8c510a", "#d8b365", "#f6e8c3", "gray50", "#c7eae5", "#5ab4ac", "#01665e", "#bcbd22")
# cbPalette <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")
# cbPalette <- c("#40004b", "#762a83", "#9970ab", "#c2a5cf", "#e7d4e8", "#d9f0d3", "#a6dba0", "#5aae61", "#1b7837", "#00441b")
df2 %>%
  ggplot(aes(x = "Data Type", y = AUROC, color = Algorithm, shape = Algorithm)) +
  # scale_y_reverse() +
  theme_bw() +
  geom_jitter() +
  scale_shape_manual(values=c(3,4,7,8,11,15,17,18,19,6)) +
  coord_flip() +
  facet_grid(rows = vars("Data Type"), scales='free') +
  scale_color_manual(values = cbPalette) +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

ggsave(graph_name, height = 4, width =7, dpi = 300)
