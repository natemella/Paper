if (!require("pacman")) install.packages("pacman"); library(pacman)
p_load(tidyverse)

## gets file name to be read in
args <- commandArgs(trailingOnly = TRUE)

df2 <- read_tsv(args[1]) %>%
  mutate(CancerType = str_replace(CancerType, "^TCGA_", ""), Algorithm=factor(Algorithm)) %>%
  group_by(Algorithm, CancerType, Description, Iteration) %>% summarize(AUROC=mean(AUROC)) %>%
  group_by(Algorithm, CancerType, Description) %>%
  summarize(AUROC=mean(AUROC))

df2 <- df2 %>% group_by(CancerType, Description) %>% summarize(AUROC_max = max(AUROC), AUROC_min = min(AUROC), AUROC=mean(AUROC)) #%>% inner_join(df2, by = c("AUROC", "CancerType", "Description"))

# df3 <- df2 %>% group_by(CancerType, Description) %>% summarize(AUROC = max(AUROC)) %>% inner_join(df2, by = c("AUROC", "CancerType", "Description"))

graph_name <- paste("Graphs/most_predictive_cancer_type",args[2],".png", sep = "")

cbPalette <- c("#8c510a", "#d8b365", "#f6e8c3", "gray50", "#c7eae5", "#5ab4ac", "#01665e")
df2 %>%
  ggplot(aes(x = Description, y = AUROC, color = Description, fill = Description)) +
  theme_bw() +
  scale_shape_manual(values=c(3,4,7,8,11,15,17,18,19,6)) +
  geom_linerange(ymin = df2$AUROC_min, ymax = df2$AUROC_max) +
  coord_flip() +
  geom_hline(yintercept = 0.5, color = "red", linetype = "dashed") +
  facet_grid(rows = vars(CancerType)) +
  scale_color_manual(values = cbPalette) +
  ylim(0.40, 0.78) +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

ggsave(graph_name, height = 7, width = 10, dpi = 300)


