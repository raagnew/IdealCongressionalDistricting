
# -----------------------------
# Specify path to MT header file mtgeo2020.pl downloaded from https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/
# -----------------------------
header_file_path <- "c:/CONGRESSIONAL_DISTRICTING/mtgeo2020.pl"

# -----------------------------
# Import the data
# -----------------------------
header <- read.delim(header_file_path, header=FALSE, colClasses="character", sep="|")
colnames(header) <- c("FILEID", "STUSAB", "SUMLEV", "GEOVAR", "GEOCOMP", "CHARITER", "CIFSN", "LOGRECNO", "GEOID", 
                      "GEOCODE", "REGION", "DIVISION", "STATE", "STATENS", "COUNTY", "COUNTYCC", "COUNTYNS", "COUSUB",
                      "COUSUBCC", "COUSUBNS", "SUBMCD", "SUBMCDCC", "SUBMCDNS", "ESTATE", "ESTATECC", "ESTATENS", 
                      "CONCIT", "CONCITCC", "CONCITNS", "PLACE", "PLACECC", "PLACENS", "TRACT", "BLKGRP", "BLOCK", 
                      "AIANHH", "AIHHTLI", "AIANHHFP", "AIANHHCC", "AIANHHNS", "AITS", "AITSFP", "AITSCC", "AITSNS",
                      "TTRACT", "TBLKGRP", "ANRC", "ANRCCC", "ANRCNS", "CBSA", "MEMI", "CSA", "METDIV", "NECTA",
                      "NMEMI", "CNECTA", "NECTADIV", "CBSAPCI", "NECTAPCI", "UA", "UATYPE", "UR", "CD116", "CD118",
                      "CD119", "CD120", "CD121", "SLDU18", "SLDU22", "SLDU24", "SLDU26", "SLDU28", "SLDL18", "SLDL22",
                      "SLDL24", "SLDL26", "SLDL28", "VTD", "VTDI", "ZCTA", "SDELM", "SDSEC", "SDUNI", "PUMA", "AREALAND",
                      "AREAWATR", "BASENAME", "NAME", "FUNCSTAT", "GCUNI", "POP100", "HU100", "INTPTLAT", "INTPTLON", 
                      "LSADC", "PARTFLAG", "UGA")
header <- header[,c(3,10,33,34,91,93,94)]
x <- header[header[,1]=="150",c(2,3,4,5,6,7)]
write.table(x,file="c:/CONGRESSIONAL_DISTRICTING/MT_Blkgrps.txt",sep=",",row.names=FALSE,col.names=TRUE)


