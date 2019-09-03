if (!require("pacman")) install.packages("pacman"); library(pacman)
p_load(tidyverse)

read_tsv("all_data.tsv") %>%
  mutate(CancerType = str_replace(CancerType, "^TCGA_", "")) %>%
  ggplot(aes(x = Algorithm, y = AUROC, fill = Algorithm)) +
  geom_boxplot() +
  geom_hline(yintercept = 0.5, color = "red", linetype = "dashed") +
  facet_grid(CancerType ~ Description) + 
  theme(axis.text.x = element_blank())

ggsave("boxplots.png", height = 8, width = 7)