library(rgdal)
library(sp)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(viridis)
library(devtools)
# Dev mode ggplot2 needed for sf objects
dev_mode(on = T)

setwd("/Users/fse/Documents/Uganda/maps")
#install_github("tidyverse/ggplot2", force = T)
data.path <- "/Users/fse/Documents/Uganda"

shapefile.path <- "/Users/fse/Documents/Uganda/District_Boundaries_2014"

uganda_sf <- st_read(dsn = shapefile.path, layer = "District_Boundaries_2014")

# Read processed data created by Stata files
csv.path <- paste0(data.path, "/Uganda_W4_croparea.csv")
ag_df <- read.csv(csv.path)

mapUgandaW2 <- function(analysis_crop)
{
  # Calculates sum and percent
  ag_df$Sum <- rowSums(ag_df[,c(5:35)])
  ag_df$Percent <- (ag_df$crop_area_Sorghum / ag_df$Sum) * 100
  
  # Convert to sf and subset to needed vars
  ag_sf <- st_as_sf(ag_df, coords = c("lon_mod", "lat_mod"), crs = 4326)
  ag_sf <- ag_sf[, c(34, 35)]
  
  # Figure code
  percent_pts <- ggplot(uganda_sf) + 
    geom_sf() + 
    geom_sf(data = ag_sf, aes(color = Percent), size = 2) +
    scale_color_viridis(option = "viridis") +
    labs(title = paste0("Percent of ", analysis_crop, " by EA, Uganda LSMS W2")) + 
    theme_minimal()
  
  
  #percent_pts
  
  # Save to file
  ggsave(paste0("Uganda_W2_", analysis_crop,"Map.png"), percent_pts)
  
} 

mapUgandaW3 <- function(analysis_crop)
{
  # Calculate sum and percent
  ag_df$Sum <- rowSums(ag_df[,c(5:34)])
  ag_df$Percent <- (ag_df$crop_area_SORGHUM / ag_df$Sum) * 100
  
  # Convert to sf and subset to needed vars
  ag_sf <- st_as_sf(ag_df, coords = c("lon_mod", "lat_mod"), crs = 4326)
  ag_sf <- ag_sf[, c(33, 34)]
  
  # Figure code
  percent_pts <- ggplot(uganda_sf) + 
    geom_sf() + 
    geom_sf(data = ag_sf, aes(color = Percent), size = 2) +
    scale_color_viridis(option = "viridis") +
    labs(title = paste0("Percent of ", analysis_crop, " by EA, Uganda LSMS W3")) + 
    theme_minimal()
  
  
  #percent_pts
  
  # Save to file
  ggsave(paste0("Uganda_W3_", analysis_crop,"Map.png"), percent_pts)
  
}  


mapUgandaW4 <- function(analysis_crop)
{
  # Calculate sum and percent
  ag_df$Sum <- rowSums(ag_df[,c(5:32)])
  ag_df$Percent <- (ag_df$crop_area_Sorghum / ag_df$Sum) * 100
  
  # Convert to sf and keep needed vars
  ag_sf <- st_as_sf(ag_df, coords = c("lon_mod", "lat_mod"), crs = 4326)
  ag_sf <- ag_sf[, c(31, 32)]
  
  # Figure code
  percent_pts <- ggplot(uganda_sf) + 
    geom_sf() + 
    geom_sf(data = ag_sf, aes(color = Percent), size = 2) +
    scale_color_viridis(option = "viridis") +
    labs(title = paste0("Percent of ", analysis_crop, " by EA, Uganda LSMS W4")) + 
    theme_minimal()
  
  
  #percent_pts
  
  # Save to file
  ggsave(paste0("Uganda_W4_", analysis_crop,"Map.png"), percent_pts)
  
}

mapUgandaW4("Sorghum")

