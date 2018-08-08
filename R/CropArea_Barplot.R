library(ggplot2)
library(reshape)

# Creates distribution plot for specific country data
data.path <- "/Users/fse/Documents/Nigeria"
processed.path <- paste0(data.path, "/plots")

# Reads processed data from Stata, subsets to only crop variables
csv.path <- paste0(data.path, "/Nigeria_W1_croparea.csv")
ag_df <- read.csv(csv.path)
ag_df <- subset(ag_df, select = -c(1:4))

# Sums across EAs
ag_sums <- colSums(ag_df)
# Pulls formatted names of crops
ag_names <- names(ag_sums)
ag_names <- gsub(".*_", "", ag_names)

# Creates dataframe from formatted names
ag_sumsdf <- data.frame(Crop = ag_names)
ag_sumsdf$AreaSum <- ag_sums
# Orders in ascending order for area
ag_sumsdf <- ag_sumsdf[order(-ag_sumsdf$AreaSum),]

# Figure code
cropBarPlot <- ggplot(data = ag_sumsdf, aes(x = reorder(Crop, AreaSum), y = AreaSum)) + 
  geom_bar(stat = "identity") + 
  labs(x = "ZAO Code", y = "Crop Area (Acres)", title = "LSMS Uganda W2 Area by Crop") + 
  coord_flip()

# Saves to file
ggsave(paste0(processed.path, "/W2_BarplotArea.png"),cropBarPlot)
