if (!require("pacman")) install.packages("pacman"); library(pacman)
p_load(tidyverse)

## gets file name to be read in
args <- commandArgs(trailingOnly = TRUE)

df2 <- read_tsv(args[1]) %>%
  mutate(CancerType = str_replace(CancerType, "^TCGA_", ""), Algorithm=factor(Algorithm)) %>%
  group_by(Algorithm, CancerType, Description) %>%
  summarize(AUROC=mean(AUROC))

df2 %>% group_by(CancerType, Description) %>% summarize(AUROC = max(AUROC)) %>% inner_join(df2, by = c("AUROC", "CancerType", "Description"))

df3 <- df2 %>% group_by(CancerType, Description) %>% summarize(AUROC = max(AUROC)) %>% inner_join(df2, by = c("AUROC", "CancerType", "Description"))

#cbPalette <- c("#8c510a", "#d8b365", "#f6e8c3", "gray50", "#c7eae5", "#5ab4ac", "#01665e")

cbPalette <- c("#8c510a", "gray50", "#01665e")
df3 %>%
  ggplot(aes(x = Description, y = AUROC, color = Description, fill = Description, shape = Algorithm)) +
  theme_bw() +
  scale_shape_manual(values=c(3,4,7,8,11,15,17,18,19,6)) +
  geom_jitter() +
  coord_flip() +

  geom_hline(yintercept = 0.5, color = "red", linetype = "dashed") +
  facet_grid(rows = vars(CancerType), scales='free') +
  scale_color_manual(values = cbPalette) +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

ggsave(args[2], height = 5, width = 10)
