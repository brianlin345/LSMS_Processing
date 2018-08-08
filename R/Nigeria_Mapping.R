library(rgdal)
library(sp)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(viridis)
library(devtools)

# Dev mode ggplot2 needed for sf objects
dev_mode(on = T)

setwd("/Users/fse/Documents/Nigeria/maps")
#install_github("tidyverse/ggplot2", force = T)
data.path <- "/Users/fse/Documents/Nigeria"

shapefile.path <- "/Users/fse/Documents/Nigeria/NIR-level_1_SHP"

nigeria_sf <- st_read(dsn = shapefile.path, layer = "NIR-level_1")
st_crs(nigeria_sf) <- 4326

# Reads processed data from Stata scripts 
csv.path <- paste0(data.path, "/Nigeria_W3_croparea.csv")
ag_df <- read.csv(csv.path)

mapNigeriaW1 <- function(analysis_crop)
{
  # Calculate sum and percent
  ag_df$Sum <- rowSums(ag_df[,c(5:77)])
  ag_df$Percent <- (ag_df$crop_area_beans_cowpea / ag_df$Sum) * 100
  
  # Convert to sf and subset to needed columns
  ag_sf <- st_as_sf(ag_df, coords = c("lon_dd_mod", "lat_dd_mod"), crs = 4326)
  ag_sf <- ag_sf[, c(77, 78)]
  
  # Figure code
  percent_pts <- ggplot(nigeria_sf) + 
    geom_sf() + 
    geom_sf(data = ag_sf, aes(color = Percent), size = 2) +
    scale_color_viridis(option = "viridis") +
    labs(title = paste0("Percent of ", analysis_crop, " by EA, Nigeria LSMS W1")) + 
    theme_minimal()
  
  
  #percent_pts
  
  # Save to file
  ggsave(paste0("Nigeria_W1_", analysis_crop,"Map.png"), percent_pts)
  
} 

mapNigeriaW2 <- function(analysis_crop)
{
  # Calculate sum and percent
  ag_df$Sum <- rowSums(ag_df[,c(5:75)])
  ag_df$Percent <- (ag_df$crop_area_beans_cowpea / ag_df$Sum) * 100
  
  # Convert to sf and subset to needed variables
  ag_sf <- st_as_sf(ag_df, coords = c("lon_dd_mod", "lat_dd_mod"), crs = 4326)
  ag_sf <- ag_sf[, c(74, 75)]
  
  # Figure code
  percent_pts <- ggplot(nigeria_sf) + 
    geom_sf() + 
    geom_sf(data = ag_sf, aes(color = Percent), size = 2) +
    scale_color_viridis(option = "viridis") +
    labs(title = paste0("Percent of ", analysis_crop, " by EA, Nigeria LSMS W2")) + 
    theme_minimal()
  
  
  #percent_pts
  
  # save to file
  ggsave(paste0("Nigeria_W2_", analysis_crop,"Map.png"), percent_pts)
  
} 


mapNigeriaW3 <- function(analysis_crop)
{
  # Calculate sum and percent
  ag_df$Sum <- rowSums(ag_df[,c(5:58)])
  ag_df$Percent <- (ag_df$crop_area_BEANS_COWPEA / ag_df$Sum) * 100
  
  # Convert to sf and keep needed vars
  ag_sf <- st_as_sf(ag_df, coords = c("lon_dd_mod", "lat_dd_mod"), crs = 4326)
  ag_sf <- ag_sf[, c(57, 58)]
  
  # Figure code 
  percent_pts <- ggplot(nigeria_sf) + 
    geom_sf() + 
    geom_sf(data = ag_sf, aes(color = Percent), size = 2) +
    scale_color_viridis(option = "viridis") +
    labs(title = paste0("Percent of ", analysis_crop, " by EA, Nigeria LSMS W3")) + 
    theme_minimal()
  
  
  #percent_pts
  
  # Save to file 
  ggsave(paste0("Nigeria_W3_", analysis_crop,"Map.png"), percent_pts)
  
} 


mapNigeriaW3("Beans")
