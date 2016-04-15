library(rgdal)
library(raster)
library(sp)

# Read in and plot a country basemap
world = readOGR("global_country_boundaries/", "TM_WORLD_BORDERS_SIMPL-0.3")
spplot(world, zcol = 1, col.regions = "gray", col = "blue")

# Read in and plot climate layer and country basemap
# Climate: bioclim layer 1, 2.5 min, generic
bio1c = raster("bioclim_current/bio1.bil")
plot(bio1c, col = grey(0:256/256), legend = FALSE, main = "Global Current Temp")
plot(world, border = "blue", col = "transparent", add = TRUE)

# Read in entire cleaned Vertnet dataset with body size
all_occurrences = read.csv("CompleteDatasetVN.csv")

# Pick one species with large number of occurrences
# Sorex trowbridgii (Trowbridge's shrew): range is along west coast of N America, mass 3.8-5g
shrew = all_occurrences[all_occurrences$clean_genus_species == "Sorex trowbridgii",]
# Put into spatial format, just longitude and latitude cols
shrew_sp = SpatialPointsDataFrame(shrew[, 19:18], shrew, proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
points(shrew_sp, col = "red")

# Not clipping climate layers because don't know how much of them will be necessary
# Climate: bioclim layers 1 and 4
bioclim_list = list.files(path = "bioclim_current/", full.names = TRUE, pattern = ".bil")
climate_layers = stack(bioclim_list)
plot(climate_layers)

# Visualizing climate layers
library(rasterVis)
histogram(climate_layers)
densityplot(climate_layers)
levelplot(climate_layers)

# Get climate values for all occurrences
vals = extract(climate_layers, shrew_sp, method = "bilinear")

# Occurrences csv for MaxEnt
shrew_maxent = shrew[, c("clean_genus_species", "decimallongitude", "decimallatitude")]
write.csv(shrew_maxent, file = "shrew_maxent.csv")
# Had to go in by hand and remove the first row from the csv

# Environmental asc for MaxEnt
bio1_layer = raster("bioclim_current/bio1.bil")
bio4_layer = raster("bioclim_current/bio4.bil")
writeRaster(bio1_layer, format = "EHdr", file.path("bioclim_current/", "bio1.asc"))
writeRaster(bio1_layer, filename = "bio1.asc", format = "EHdr", overwrite = TRUE)
writeRaster(bio4_layer, filename = "bio4.asc", format = "EHdr")
writeRaster(bio1_layer, filename = "bio1.asc", format = "EHdr")
