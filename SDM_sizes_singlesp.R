library(rgdal)

# Read in and create occurrences csv for shrew species, MaxEnt format = species name, longitude, latitude
# Pick one species with large number of occurrences
# Sorex trowbridgii (Trowbridge's shrew): range is along west coast of N America, mass 3.8-5g
all_occurrences = read.csv("occurrences_data/CompleteDatasetVN.csv")
shrew = all_occurrences[all_occurrences$clean_genus_species == "Sorex trowbridgii",]
shrew = shrew[shrew$mass < 10,] #Subset less than 10g
shrew$size_class = ifelse(shrew$mass <= 4.8, "small", "large")
shrew$sp_size = paste(shrew$clean_genus_species, shrew$size_class)
shrew_maxent = shrew[, c("sp_size", "decimallongitude", "decimallatitude")]
write.csv(shrew_maxent, file = "occurrences_data/shrew_maxent.csv") #Removed rownames by hand
shrew_small = shrew_maxent[shrew$sp_size == "Sorex trowbridgii small",]
shrew_large = shrew_maxent[shrew$sp_size == "Sorex trowbridgii large",]
write.csv(shrew_small, file = "occurrences_data/shrew_small.csv")
write.csv(shrew_large, file = "occurrences_data/shrew_large.csv")
# Peromyscus maniculatus (deer mouse): range is most of N America, mass 10-24g
mouse = all_occurrences[all_occurrences$clean_genus_species == "Peromyscus maniculatus",]
mouse = mouse[(mouse$mass < 40) & (mouse$mass > 5),] #Subset 5-40g
mouse$size_class = ifelse(mouse$mass <= 17, "small", "large")
mouse$sp_size = paste(mouse$clean_genus_species, mouse$size_class)
mouse_maxent = mouse[, c("sp_size", "decimallongitude", "decimallatitude")]
write.csv(mouse_maxent, file = "occurrences_data/mouse_maxent.csv") #Removed rownames by hand
mouse_small = mouse_maxent[mouse$sp_size == "Peromyscus maniculatus small",]
mouse_large = mouse_maxent[mouse$sp_size == "Peromyscus maniculatus large",]
write.csv(mouse_small, file = "occurrences_data/mouse_small.csv")
write.csv(mouse_large, file = "occurrences_data/mouse_large.csv")

# Plot occurrences using countries basemap
world = readOGR("global_country_boundaries/", "TM_WORLD_BORDERS_SIMPL-0.3")
plot(world, border = "blue", col = "transparent")
shrew_sp = SpatialPointsDataFrame(shrew[, 19:18], shrew, proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
points(shrew_sp, col = "red", pch = 19, cex = 0.2)
# TODO: plot mouse occurrences also

# Current climate is bioclim layers 1 & 4, 2.5 min, generic
# Couldn't convert .bil to .asc using R
# Conversion steps in QGIS: 
  # Import .bil file as raster layer
  # Raster > Conversion > Translate (Convert format)
  # Select pencil icon at bottom
  # Command: gdal_translate -of AAIGrid Users/kristinariemer/Dropbox/Documents/Graduate_School/Projects/SDM_traits/bioclim_current/bio1.bil Users/kristinariemer/Dropbox/Documents/Graduate_School/Projects/SDM_traits/bioclim_current/bio1_convert.asc
    # Removed band command because not needed, and removed no data command because it was messing up the tif files
  # Repeat for other layer file

# Future climate is bioclim layers 1 & 4, 2.5 min, 2050, rcp60, CCSM4
# Convert from .tif to .asc using same method as for current climate

# SDMs for current and future climate using MaxEnt program
# Options (always): 
  # Browse to folder with current environment for "Environmental layers", check relevant ones
  # Browse to occurrences csv for "Samples"
  # Browse to folder with future enviro for "Projection layers directory/file"
  # Browse to new empty folder for "Output directory"
  # Check "Create response curves" and "Do jackknife..."
  # Features set to "Auto features" (default)
  # Settings > Basic > 20 into "Random test percentage"
  # Settings > Basic > Background points changed to 150 (shrew) / 1000 (mouse)
  # Settings > Advanced > Select "Do clamping" and de-select "Extrapolate"
# Options (changed currently): 
  # Change feature to threshold only -- poor AUC/omission, and sharp response curves
# Options: 
  # Select different features than auto
  # Change output format
  # Set aside different amount of occurrences for testing
  # Extrapolate instead of clamp -- not really much of a difference
  # Do random seed
  # Change number of background points (should be less than occurrence points)
