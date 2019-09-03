##install.packages("devtools")
##devtools::install_github("r-lib/xml2")
##install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
library(stringr)

## gets file name to be read in
args <- commandArgs(trailingOnly = TRUE)

### reads in the file to be graphed
dataToBeGraphed <- read.table(args[1], header = TRUE)

### assigns the dataToBeGraphed to "x"
x <- dataToBeGraphed

### "y" is assinged the file name for naming the graph
y <- args[1]
y <- substr(y, 1, nchar(y)-4) 

### makes a new column that is the combination of CancerType and Algorithm
x$CancerType_Algorithm <- paste(x$CancerType,x$Algorithm,sep = "_")

### makes the table include only those four columns
### also, takes the mean of AUROC and condenses the table to only include the mean of AUROC
#x <- aggregate(AUROC ~ CancerType_Algorithm + CancerType + Algorithm + Description, x, mean)
x <- aggregate(AUROC ~ Description, x, median)
## just make a new table, aggregate probably isnt working here the second time.

#The Color blind friendly palette with black
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", '#000000')

### Makes the graph
myPlot <- ggplot(data = x) +
  geom_point(aes(x = Description, y = AUROC, color = Description, shape = Description)) +
  scale_shape_manual(values=c(25,19,7,8,11,15,17)) +
  ggtitle(y) +
  theme(axis.text.y = element_blank()) +
  # theme(axis.text.x = element_text(angle = 56.5, hjust = 1, vjust = 1, size = 12)) +
  theme(plot.title = element_text(hjust = .5, size = 20)) +
  theme(plot.margin=unit(c(1,1,1.5,2),"cm")) +
  coord_flip() +
  scale_fill_manual(values = cbPalette)

### save the plot to folder "graphs" (a new folder created in wd)
dir.create("Description_Graphs")
y <- paste(y, "_point.pdf", sep = "")
y <- paste("Description_Graphs/", y, sep = "")
pdf(y)
plot(myPlot)
dev.off()
print(y)

