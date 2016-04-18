library(rgdal)

# Read in and create occurrences csv for shrew species, MaxEnt format = species name, longitude, latitude
# Pick one species with large number of occurrences
# Sorex trowbridgii (Trowbridge's shrew): range is along west coast of N America, mass 3.8-5g
all_occurrences = read.csv("CompleteDatasetVN.csv")
shrew = all_occurrences[all_occurrences$clean_genus_species == "Sorex trowbridgii",]
shrew_maxent = shrew[, c("clean_genus_species", "decimallongitude", "decimallatitude")]
write.csv(shrew_maxent, file = "shrew_maxent.csv") #Removed rownames by hand

# Plot occurrences using countries basemap
world = readOGR("global_country_boundaries/", "TM_WORLD_BORDERS_SIMPL-0.3")
plot(world, border = "blue", col = "transparent")
shrew_sp = SpatialPointsDataFrame(shrew[, 19:18], shrew, proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
points(shrew_sp, col = "red", pch = 19, cex = 0.2)

# Current climate is bioclim layers 1 & 4, 2.5 min, generic
# Couldn't convert .bil to .asc using R
# Conversion steps in QGIS: 
  # Import .bil file as raster layer
  # Raster > Conversion > Translate (Convert format)
  # Select pencil icon at bottom
  # Command: gdal_translate -a_nodata 9999 -of AAIGrid Users/kristinariemer/Dropbox/Documents/Graduate_School/Projects/SDM_traits/bioclim_current/bio1.bil Users/kristinariemer/Documents/Graduate_School/Projects/SDM_traits/bioclim_current/bio1_translate.asc
  # Repeat for other layer file

# Future climate is bioclim layers 1 & 4, 2.5 min, 2050, rcp60, CCSM4
# Convert from .tif to .asc using same method as for current climate

# Ran current SDM using MaxEnt program