# Title     : TODO
# Objective : TODO
# Created by: nathanmella
# Created on: 2019-08-01

### load r packages


library(tidyverse)
library(readr)
library(stringr)

### download data set

clinical_data = read_tsv("only_clinical.txt")
clinical_data = clinical_data %>% group_by(Description) %>% summarise(AUROC = mean(AUROC))
base_line = max(clinical_data$AUROC)

#add error bars

list_of_dfs = list()
i <- 1
for (file in list.files(path = getwd())) {
  if (endsWith(file, "tsv")) {
    df <- read_tsv(file)
    df = df %>% group_by(Description, CancerType, Iteration, Algorithm) %>% summarize(AUROC = mean(AUROC))
    df = df %>% group_by(Description, CancerType, Algorithm) %>% summarize(AUROC = mean(AUROC))
    df = df %>% group_by(Description, Algorithm) %>% summarise(AUROC = mean(AUROC))
    df = df %>% group_by(Description) %>% summarise(Max_AUROC = max(AUROC), Min_AUROC = min(AUROC), AUROC = mean(AUROC)) %>%
      mutate(Combination = str_wrap(str_replace(file, ".tsv", ""), width= 2))
    df$Description <- gsub("\\+.*", "", df$Description)
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
  ggplot(aes(x = Description, y = AUROC, color = Description, fill = Description)) +
  facet_grid(cols = vars(Combination), scales='free') +
  theme_bw() +
  # geom_point() +
  geom_col(aes(y = AUROC)) +
  # geom_line(aes(group=Description)) +
  geom_hline(yintercept = base_line, color = "#ff7f0e", linetype = "dashed") +
  scale_color_manual(values = cbPalette) +
  geom_errorbar(ymax=df$Max_AUROC, ymin=df$Min_AUROC) +
  theme() +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 2)) +
  scale_y_continuous(limits=c(0.5, 0.7), breaks=seq(from = 0.5, to = 0.7, by = 0.05)) +
  xlab("Trial Differences")

ggsave("graphs/index_three.png", height = 7, width = 15)
