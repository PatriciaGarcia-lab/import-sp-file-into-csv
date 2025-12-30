### Import .sp from Perkim Elmer into a csv
### Dr. Patricia E Garcia (INIBIOMA)
### Bariloche, Argentina


library(tidyverse)
## locate the folder with the ".sp file"

folder <- "C:/Laboratorio de Fotobiologia/Fortin/EEM/fortin-DM/Ascii" ## set your folder

file_name <- list.files(path = folder, pattern = "\\.sp$", full.names = TRUE) ### files must be save in ASCII

### function for import the .sp
read_perkin_files <- function(ruta) {
  lines <- readLines(ruta)
    #extract excitation values 
  ex_val <- as.numeric(lines[22])
  
  # Read the emission data
  df <- read.table(ruta, skip = 54, nrows = 598, sep = "\t", header = FALSE)
  
  colnames(df) <- c("em", "int")
  df$ex <- ex_val
  df$name <- basename(ruta)
  
  return(df)
}
### Complete file 
file_complete <- lapply(file_name, read_perkin_files) %>% bind_rows()

### Format into a excitacion emission matrix 

file_eem  <- file_complete %>%
  select(em, ex, int) %>%
  pivot_wider(names_from = ex, names_prefix = "Ex_", values_from = int)

### Export the file into .csv

write.csv(file_eem, 
          file = sub("#01\\.sp", ".csv", file_complete$name[1]), 
          row.names = FALSE)
