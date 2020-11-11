#! /usr/bin/Rscript
#R  script to load SRS R package and run SRS function

cat(R.version$version.string, "\n")
args <- commandArgs(TRUE)

filename <- as.character(args[[1]])
metric <- as.character(args[[2]])
step <- as.numeric(args[[3]])
sample <- as.numeric(args[[4]])
max.sample.size <- as.numeric(args[[5]])
rarefy.comparison <- as.logical(args[[6]])
rarefy.repeats <- as.numeric(args[[7]])
rarefy.comparison.legend <- as.logical(args[[8]])
SRS.color <- as.character(args[[9]])
rarefy.color <- as.character(args[[10]])
SRS.linetype <- as.character(args[[11]])
rarefy.linetype <- as.character(args[[12]])
label <- as.logical(args[[13]])
output_dir <- as.character(args[[14]])

input_name, str(metric), str(step), str(sample),
              str(max.sample.size), str(rarefy.comparison), str(rarefy.repeats),
              str(rarefy.comparison.legend), str(SRS.color), str(label), str(output_dir)

if(set_seed%in%c("T","True")){set_seed<-T}
else{set_seed<-F}

errQuit <- function(mesg, status=1) {
  message("Error: ", mesg)
  q(status=status)
}

#Check SRS installations and install SRS if needed
if ("SRS" %in% installed.packages()[,"Package"] & packageVersion("SRS")=="0.2.0") { 
    cat("SRS package already installed! \n\n")
} else {
    install.packages("SRS")
}

library(SRS)
cat("SRS R package version:", as.character(packageVersion("SRS")), "\n")

#read raw data
data <- read.table(file = filename, skip = 0, header = F,row.names = NULL,check.names = FALSE)[,-1]
#include sample names
colnames(data) <- colnames(read.csv(file = filename, nrows=1, skip=1, sep = "\t", check.names = FALSE))[-1]
#normalize at c_min
norm_data<-SRS(data, c_min, set_seed = set_seed, seed = seed)
#include features names
rownames(norm_data) <- read.table(file = filename, skip = 0, header = F, check.names = FALSE)[,1]

write.table(norm_data, filename, sep = "\t", row.names = T, quote = F)

q(status=0)
