#! /usr/bin/Rscript
#R  script to load SRS R package and run SRScurve function

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

errQuit <- function(mesg, status=1) {
  message("Error: ", mesg)
  q(status=status)
}

#Check SRS installations and install SRS if needed
if ("SRS" %in% installed.packages()[,"Package"] & packageVersion("SRS")=="0.2.1") { 
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

#plot SRScurves
png(paste0(output_dir,"/SRScurve_plot.png"), 800, 600)
SRScurve(data, metric = metric, step = step, sample = sample, max.sample.size = max.sample.size,
              rarefy.comparison = rarefy.comparison, rarefy.repeats = rarefy.repeats,
              rarefy.comparison.legend = rarefy.comparison.legend, col = c(SRS.color, rarefy.color),
              lty = c(SRS.linetype, rarefy.linetype), label = label)
dev.off()

q(status=0)
