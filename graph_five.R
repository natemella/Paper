
### load r packages

library(dplyr)
library(tidyverse)
library(readr)


### download data set
args <- commandArgs(trailingOnly = TRUE)
df <- read_csv("sample_summary.csv")

df <- df %>%
  mutate(CancerType = str_replace(CancerType, "^TCGA_", ""))
# gather(Data_Type, Number_of_Patients, -CancerType, -Outcome, -Total)

### average AUROC grouped by cancer type, algorithm and description(data type)


cbPalette <- c("#9ca5ac",  "#111e3e")
df %>%
  ggplot(aes(x = CancerType, y = Total, fill = Outcome)) +
  theme_bw() +
  geom_col() +
  scale_fill_manual(values = cbPalette) +
  theme() +
  xlab("CancerType")

ggsave("graphs/sample_info.png", height = 4, width = 15)