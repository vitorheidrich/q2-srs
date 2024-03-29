#!/usr/bin/env Rscript
#R  script to load SRS R package and run SRS function

cat(R.version$version.string, "\n")
args <- commandArgs(TRUE)

filename <- as.character(args[[1]])
c_min <- as.numeric(args[[2]])
set_seed <- as.logical(args[[3]])
seed <- as.numeric(args[[4]])

errQuit <- function(mesg, status=1) {
  message("Error: ", mesg)
  q(status=status)
}

#Check SRS installations and install SRS if needed
if ("SRS" %in% installed.packages()[,"Package"]) {
  if(packageVersion("SRS")>="0.2.1"){
    cat("SRS package already installed! \n\n")
} else {
    install.packages("SRS",repos="http://cran.us.r-project.org")
}} else {
    install.packages("SRS",repos="http://cran.us.r-project.org")
}

library(SRS)
cat("SRS R package version:", as.character(packageVersion("SRS")), "\n")

#read raw data
data <- read.table(file = filename, skip = 0, header = F,row.names = NULL,check.names = FALSE,sep = "\t")[,-1]
#include sample names
colnames(data) <- colnames(read.csv(file = filename, nrows=1, skip=1, sep = "\t", check.names = FALSE))[-1]
#normalize at c_min
norm_data<-SRS(data, c_min, set_seed = set_seed, seed = seed)
#include features names
rownames(norm_data) <- read.table(file = filename, skip = 0, header = F, check.names = FALSE, sep = "\t")[,1]

write.table(norm_data, filename, sep = "\t", row.names = T, quote = F)

q(status=0)
