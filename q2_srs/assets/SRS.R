#R  script to load SRS R package and run SRS function

cat(R.version$version.string, "\n")
args <- commandArgs(TRUE)

data <- args[[1]]
c_min <- args[[2]]
norm_data_name <- args[[3]]

errQuit <- function(mesg, status=1) {
  message("Error: ", mesg)
  q(status=status)
}

#Check SRS installations and install SRS if needed
if ("SRS" %in% installed.packages()[,"Package"]) {
    cat("SRS package already installed! \n\n")
} else {
    install.packages("SRS")
}

#transform python derived data into the R data that SRS likes

#run SRS

library(SRS)
cat("SRS R package version:", as.character(packageVersion("SRS")), "\n")

norm_data<-SRS(data,c_min)

write.table(norm_data, norm_data_name, sep = "\t",
            row.names = F,
            quote = F)

q(status=0)
