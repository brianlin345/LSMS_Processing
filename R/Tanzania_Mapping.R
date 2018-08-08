library(rgdal)
library(sp)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(viridis)
library(devtools)
# Dev mode ggplot2 for plotting sf objects
dev_mode(on = T)

setwd("/Users/fse/Documents/Tanzania/maps")
#install_github("tidyverse/ggplot2", force = T)
data.path <- "/Users/fse/Documents/Tanzania"

shapefile.path <- "/Users/fse/Documents/Tanzania/Tanzania_regions_2014"

tanzania <- readOGR(shapefile.path, "Tanzania_regions_2014")
tanzania_sf <- st_read(dsn = shapefile.path, layer = "Tanzania_regions_2014")
# read processed data created by Stata script
csv.path <- paste0(data.path, "/Tanzania_W1_croparea.csv")
ag_df <- read.csv(csv.path)


mapTanzaniaW3 <- function(analysis_crop)
{
  # Sums all crop rows + calculate percent
  ag_df$Sum <- rowSums(ag_df[,c(7:37)])
  ag_df$Percent <- (ag_df$Crop_Area_Sorghum / ag_df$Sum) * 100

  # Conversion to sf, subset to needed vars
  ag_sf <- st_as_sf(ag_df, coords = c("lon_dd_mod", "lat_dd_mod"), crs = 4326)
  ag_sf <- ag_sf[, c(37, 38)]
  
  # Figure code
  percent_pts <- ggplot(tanzania_sf) + 
                    geom_sf() + 
                    geom_sf(data = ag_sf, aes(color = Percent), size = 2) +
                    scale_color_viridis(option = "viridis") +
                    labs(title = paste0("Percent of ", analysis_crop, " by EA, Tanzania LSMS W3")) + 
                    theme_minimal()
  
  
  #percent_pts
  
  # Save to file
  ggsave(paste0("Tanzania_W3_", analysis_crop,"Map.png"), percent_pts)

}

mapTanzaniaW2 <- function(analysis_crop)
{
  # Sums all crop rows + calculate percent 
  ag_df$Sum <- rowSums(ag_df[,c(7:44)])
  ag_df$Percent <- (ag_df$Crop_Area_Sorghum / ag_df$Sum) * 100
  
  # Convert to sf, subset to needed vars
  ag_sf <- st_as_sf(ag_df, coords = c("lon_modified", "lat_modified"), crs = 4326)
  ag_sf <- ag_sf[, c(43, 44)]
  
  # Figure code
  percent_pts <- ggplot(tanzania_sf) + 
    geom_sf() + 
    geom_sf(data = ag_sf, aes(color = Percent), size = 2) +
    scale_color_viridis(option = "viridis") +
    labs(title = paste0("Percent of ", analysis_crop, " by EA, Tanzania LSMS W2")) + 
    theme_minimal()
  
  
  #percent_pts
  
  # Save to file
  ggsave(paste0("Tanzania_W2_", analysis_crop,"Map.png"), percent_pts)
  

}

mapTanzaniaW1 <- function(analysis_crop)
{
  
  # Sums crop rows + calculate percent
  ag_df$Sum <- rowSums(ag_df[,c(7:45)])
  ag_df$Percent <- (ag_df$Crop_Area_Maize / ag_df$Sum) * 100
  
  # Convert to sf + subset to needed vars
  ag_sf <- st_as_sf(ag_df, coords = c("lon_modified", "lat_modified"), crs = 4326)
  ag_sf <- ag_sf[, c(44, 45)]
  
  # Figure code
  percent_pts <- ggplot(tanzania_sf) + 
    geom_sf() + 
    geom_sf(data = ag_sf, aes(color = Percent), size = 2) +
    scale_color_viridis(option = "viridis") +
    labs(title = paste0("Percent of ", analysis_crop, " by EA, Tanzania LSMS W1")) + 
    theme_minimal()
  
  
  #percent_pts
  
  # save to file
  ggsave(paste0("Tanzania_W1_", analysis_crop,"Map.png"), percent_pts)
  
}
mapTanzaniaW1(analysis_crop = "Maize")

